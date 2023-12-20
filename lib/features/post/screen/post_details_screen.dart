import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Model_class/product_model.dart';
import 'package:e_commerce/Model_class/user_model.dart';
import 'package:e_commerce/core/providers/firebase_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../Model_class/cart_model.dart';
import '../../../core/common/firebase_constants.dart';
import '../../../main.dart';
import '../../auth/controller/auth_controller.dart';
import '../../product/controller/product_controller.dart';

final productCounterProvider=StateProvider.autoDispose<int>((ref) =>1 );
final selectIntexProvider=StateProvider.autoDispose<int?>((ref) => null);
final selectSizeIntexProvider=StateProvider.autoDispose<int?>((ref) => null);

class PostDetailsScreen extends ConsumerStatefulWidget {
  final ProductList products;
  const PostDetailsScreen({super.key,required this.products});

  @override
  ConsumerState createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends ConsumerState<PostDetailsScreen> {

  void  addFavourite(WidgetRef ref,ProductList product)async{
    ref.read(productControllerProvider.notifier).addFavourite(product);
    if(widget.products.favourite.contains(ref.read(userProvider)!.id)){
      widget.products.favourite.remove(ref.read(userProvider)!.id);
      setState(() {

      });
    }else{
      widget.products.favourite.add(ref.read(userProvider)!.id);
      setState(() {

      });
    }

  }

  void addCart(WidgetRef ref,UserModel user,List cart)async{
    ref.read(productControllerProvider.notifier).addCart(user,context,cart);
  }

  void updateCart(WidgetRef ref,UserModel user,List cart)async{
    ref.read(productControllerProvider.notifier).updateCart(user,context,cart);
  }

  void addCartId(WidgetRef ref,UserModel user,List cart)async{
    ref.read(productControllerProvider.notifier).addCartId(user,context,cart);
  }


  List colors=[
    "red",
    "pink",
    "purple",
    "deepPurple",
    "indigo",
    "blue",
    "lightBlue",
    "cyan",
    "teal",
    "green",
    "lightGreen",
    "lime",
    "yellow",
    "amber",
    "orange",
    "deepOrange",
    "brown",
  ];

  List sizes=["S","M","L","XL"];
  String selectedColor="";
  String selectedSize="";
  int cartIndex=0;

  @override
  Widget build(BuildContext context) {

    var selectedIndex= ref.watch(selectIntexProvider);
    var selectedsize= ref.watch(selectSizeIntexProvider);
    final user=ref.watch(userProvider)!;
    final count=ref.watch(productCounterProvider);



    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding:  EdgeInsets.all(w*0.04),
        child: ElevatedButton(onPressed: () async {
          var a=CartModel(
              prdctName: widget.products.prdctName,
              price: widget.products.price,
              image: widget.products.image,
              id: widget.products.id,
              category: widget.products.category,
              brand: widget.products.brand,
              color: selectedColor,
              size: selectedSize,
              quantity: count,
              discount: widget.products.discount,
          );
          final snapshot = await ref.read(firestoreProvider).collection(Constants.user).doc(ref.read(userProvider)!.id).get();
          UserModel model = UserModel.fromjson(snapshot.data());
          if(selectedSize.isNotEmpty&&
          selectedColor.isNotEmpty){
            if(model.cartId.contains(widget.products.id)){
              for (int i=0;i<model.cart.length;i++){
                if (widget.products.prdctName==model.cart[i]["prdctName"]&&
                    // widget.products.price==user.cart[i]["price"]&&
                    widget.products.image==model.cart[i]["image"]&&
                    widget.products.category==model.cart[i]["category"]&&
                    widget.products.brand==model.cart[i]["brand"]&&
                    selectedColor==model.cart[i]["color"]&&
                    selectedSize==model.cart[i]["size"]){
                  cartIndex=i;
                  var cart=model.cart;
                  cart.removeAt(cartIndex);
                  cart.insert(cartIndex, a.toJson());

                  // FirebaseFirestore.instance.collection("user").doc(user.id).update({
                  //   "cart":cart
                  // });
                  print("----*****update*****-----");
                  updateCart(ref, model, cart);
                  print("-----******update****-------");
                  break;
                }else{
                  print("-----******add****-------");
                  addCart(ref,model,[a.toJson()]);
                  print("-----******add****-------");
                }
              }
              Navigator.pop(context);
              // showMessage(context, text: "Add Cart Successfully..!", color: Colors.green);

            }else{
              print("-----add-------");
              addCart(ref,model,[a.toJson()]);
              print("-----add-------");
              addCartId(ref,model,[widget.products.id]);
            }
          }else{

            selectedColor.isEmpty?showMessage(context,text: "please select color", color: Colors.red):
            showMessage(context,text: "please select size", color: Colors.red);
          }
        },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text("Add Cart",
              style: TextStyle(
                  fontSize: w*0.05,
                  fontWeight: FontWeight.bold
              ),)),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Details"),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.all(w*0.03),
            child: InkWell(
                onTap: ()=> addFavourite(ref,widget.products),
                child:CircleAvatar(
                backgroundColor: Colors.white,
                child:widget.products.favourite.contains(user.id)?
                const Icon(Icons.favorite,color: Colors.red,):const Icon(Icons.favorite_border) ,
                ) ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(w*0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Stack(
              children: [
                Container(
                  height: w*1,
                  width: w*1,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(w*0.05),
                      image: DecorationImage(image:  NetworkImage(widget.products.image),fit: BoxFit.cover)
                  ),
                ),
                Positioned(
                    top: w*0.05,
                    left: w*0.05,
                    child: Column(
                      children: [
                        Text(widget.products.discount.toString(),
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: w*0.2
                          ),),
                        Text("%off",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: w*0.08
                          ),)
                      ],
                    )),
              ] ,
            ),
            SizedBox(height: w*0.03,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.products.prdctName,
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: w*0.07
                    ),),
                    SizedBox(height: w*0.01,),
                    Text("₹ ${count*widget.products.price}",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: w*0.04
                      ),),
                    Text("₹ ${count*widget.products.price-(count*widget.products.price*widget.products.discount)/100}",
                      style: TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: w*0.06
                      ),),
                  ],
                ),
                Column(
                  children: [
                    Text("⭐${((1*widget.products.ratingOne+2*widget.products.ratingTwo
                        +3*widget.products.ratingThree+4*widget.products.ratingFour+5*widget.products.ratingFive)/
                        ( widget.products.ratingOne+widget.products.ratingTwo+widget.products.ratingThree+
                        widget.products.ratingFour+widget.products.ratingFive)).toStringAsExponential(2)
                    }",

                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: w*0.05
                      ),),
                    Text("(${( widget.products.ratingOne+widget.products.ratingTwo+widget.products.ratingThree+
                        widget.products.ratingFour+widget.products.ratingFive).truncate()
                    } reviews)",

                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: w*0.04
                      ),),
                    SizedBox(height: w*0.01,),
                    Text(widget.products.brand,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: w*0.07
                      ),),
                  ],
                ),
              ],
            ),
            SizedBox(height: w*0.04,),
            Text(widget.products.category,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: w*0.07
              ),),
            SizedBox(height: w*0.03,),
            Row(
              children: [
                Text("Description",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: w*0.07
                  ),),
              ],
            ),
            Text(widget.products.description,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: w*0.05
              ),),
            SizedBox(height: w*0.03,),
            SizedBox(
              height: w*0.1,
              width: w*1,
              child: ListView.separated(

                itemCount: colors.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                return InkWell(
                  onTap: (){
                    ref.read(selectIntexProvider.notifier).update((state) => index);
                   selectedColor= colors[index];

                  },
                  child: Container(
                    height: w*0.1,
                    padding: EdgeInsets.all(w*0.01),
                    decoration: BoxDecoration(
                      color: selectedIndex==index?Colors.primaries[index]:null,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(w*0.03)
                    ),
                    child: Center(
                      child: Text(colors[index],
                      style: TextStyle(
                        fontSize: w*0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),),
                    ),
                  ),
                );
              }, separatorBuilder: (context, index) {
                return SizedBox(width: w*0.03,);
              },),
            ),
            SizedBox(height: w*0.03,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: w*0.1,
                  width: w*0.6,
                  child: ListView.separated(

                    itemCount: 4,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: (){
                          ref.read(selectSizeIntexProvider.notifier).update((state) => index);
                          selectedSize= sizes[index];
                        },
                        child: CircleAvatar(
                          backgroundColor:selectedsize==index?Colors.teal: Colors.black,
                          child: Center(
                            child: Text(sizes[index],
                              style: TextStyle(
                                  fontSize: w*0.05,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),),
                          ),
                        ),
                      );
                    }, separatorBuilder: (context, index) {
                    return SizedBox(width: w*0.03,);
                  },),
                ),
               Row(
                 children: [
                   InkWell(
                     onTap: () =>  ref.read(productCounterProvider.notifier).update((state) => state == 1 ? 1:state-1),
                     child: Icon(Icons.remove_circle_outline,
                         color: Colors.white,
                         size: w*0.1),
                   ),
                   SizedBox(width: w*0.01,),
                   Text(count.toString(),
                     style: const TextStyle(
                       color: Colors.white,
                       fontWeight: FontWeight.bold,
                     ),),
                   SizedBox(width: w*0.01,),
                   InkWell(
                     onTap: () {
                       ref.read(productCounterProvider.notifier).state++;
                     },
                     child: Icon(Icons.add_circle_outline_outlined,
                         color: Colors.white,
                         size: w*0.1),
                   )
                 ],
               )
              ],
            )
          ],
        ),
      ),
    );
  }
}
