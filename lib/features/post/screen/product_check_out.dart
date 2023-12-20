import 'package:e_commerce/features/post/screen/credit_card_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../main.dart';
import '../../auth/controller/auth_controller.dart';
import '../../product/controller/product_controller.dart';

class CheckOutScreen extends ConsumerStatefulWidget {
  final double price;
  const CheckOutScreen({super.key,required this.price});

  @override
  ConsumerState<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends ConsumerState<CheckOutScreen> {
  final redioButton=StateProvider<String>((ref) => "");
  double discount=0;
  double price=0;
  String? cardNo;

  Future<void> addCard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   cardNo= prefs.getString("cardNo")!;
   setState(() {

   });
  }
  @override
  void initState() {
    addCard();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final redio =ref.watch(redioButton);
    return
      ref.watch(getCartProductProvider(ref.watch(userProvider)?.id??''))
          .when(data: (data) {
        discount=0;
        for(int i=0;i<data.cart.length;i++){
          discount+=(data.cart[i]["quantity"]*data.cart[i]["price"]*data.cart[i]["discount"])/100;
        }
        price=0;
        for(int i=0;i<data.cart.length;i++){
          price+=data.cart[i]["quantity"]*data.cart[i]["price"];
        }
            return data == null
        ? const Center(child: Text('noData'))
        :Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Checkout",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: w*0.06,
          color: Colors.white
        ),),
      ),
      floatingActionButton:  Container(
        height: w*0.13,
        width: w*0.9,
        decoration: BoxDecoration(
          color: Colors.deepOrangeAccent,
          borderRadius: BorderRadius.circular(w*0.03),
        ),
        child: Center(
          child: Text("Comfirm Order",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: w*0.055
              )),
        ),
      ),
      body: Padding(
        padding:EdgeInsets.all(w*0.06),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(w*0.04),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(w*0.03),
                border: Border.all(color: Colors.white)
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("My Order",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: w*0.055,
                            color: Colors.white
                        ),),
                      Text("₹${widget.price+85-discount}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: w*0.05,
                            color: Colors.white
                        ),),
                    ],
                  ),
                 const Divider(color: Colors.white,),
                  // ref.watch(getCartProductProvider(ref.watch(userProvider)?.id??''))
                  //     .when(data: (data) => data == null
                  //     ? const Center(child: Text('noData')) :
                  ListView.separated(
                        shrinkWrap: true,
                        itemCount: data.cart.length,
                        physics:const BouncingScrollPhysics() ,
                        itemBuilder: (context, index) {
                          // discount=0;
                          // for(int i=0;i<data.cart.length;i++){
                          //  discount+=(data.cart[i]["quantity"]*data.cart[i]["price"]*data.cart[i]["discount"])/100;
                          // }

                          // price=0;
                          // for(int i=0;i<data.cart.length;i++){
                          //   price+=data.cart[i]["quantity"]*data.cart[i]["price"];
                          // }
                          final cart=data.cart[index];

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${cart["prdctName"]}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: w * 0.05)),
                                  Text("${cart["quantity"]} x ₹ ${cart["price"]}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: w * 0.05)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Discount",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: w * 0.05)),
                                  Text("-₹ ${cart["quantity"]*cart["price"]*cart["discount"]/100}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: w * 0.05)),
                                ],
                              )
                            ],
                          );

                        }, separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: w*0.02,);
                  },),
                    // error: (error, stackTrace) => ErrorText(error: error.toString()),
                    // loading: () => const Loader(),),
                  SizedBox(height: w*0.03,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total price",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: w * 0.05)),
                      Text("₹ $price",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: w * 0.05)),
                    ],
                  ),
                  SizedBox(height: w*0.03,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Discount",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: w * 0.05)),
                      Text("-₹ $discount",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: w * 0.05)),
                    ],
                  ),
                  SizedBox(height: w*0.02,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Delivery",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: w * 0.05)),
                      Text("+₹ 85",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: w * 0.05)),
                    ],
                  ),
                  const Divider(color: Colors.white),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: w*0.055,
                            color: Colors.white
                        ),),
                      Text("₹${widget.price+85-discount}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: w*0.055,
                            color: Colors.white
                        ),),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: w*0.05,),
            Container(
              height: w*0.5,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(w*0.03),
              ),
              padding: EdgeInsets.all(w*0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(Icons.payment,color: Colors.white,),
                      SizedBox(width: w*0.03,),
                      Text("Payment method",
                      style: TextStyle(
                        fontSize: w*0.05,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("visa $cardNo ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: w*0.05
                        ),),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Radio(value: "visa",
                            

                            activeColor: Colors.white,
                            groupValue: ref.watch(redioButton),
                          fillColor:
                          MaterialStatePropertyAll(redio=='visa'?Colors.white:Colors.grey),
                            onChanged: (value) {
                              print(value);
                              ref.read(redioButton.notifier).update((state) => value.toString());
                            },),
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => creditCard(),));
                            },
                              child: Text("add new card",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: w*0.03
                              ),))
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Cash on delivery ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: w*0.05
                        ),),
                      Radio(value: "Cash on delivery",fillColor:
                      MaterialStatePropertyAll(redio=='Cash on delivery'?Colors.white:Colors.grey),

                        groupValue: ref.watch(redioButton),
                        onChanged: (value) {
                          print(value);
                          ref.read(redioButton.notifier).update((state) => value.toString());
                        },)
                    ],
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );},
        error: (error, stackTrace) => ErrorText(error: error.toString()),
    loading: () => const Loader(),);
  }
}
