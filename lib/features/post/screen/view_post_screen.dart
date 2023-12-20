import 'package:e_commerce/features/post/screen/post_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Model_class/category_model.dart';
import '../../../Model_class/product_model.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../main.dart';
import '../../auth/controller/auth_controller.dart';
import '../../category/controller/category_controller.dart';
import '../../product/controller/product_controller.dart';

class ViewPost extends ConsumerStatefulWidget {
  const ViewPost({super.key});

  @override
  ConsumerState createState() => _ViewPostState();
}

class _ViewPostState extends ConsumerState<ViewPost> {

  void addFavourite(WidgetRef ref,ProductList product)async{
    ref.read(productControllerProvider.notifier).addFavourite(product);
  }

  void updateRating(ProductList product){
    ref.read(productControllerProvider.notifier).
   updateRating(
        context: context,
        product: product,
        value: ref.read(starProvider)
    );
  }

  final dropValue=StateProvider<String?>((ref) => null);
  final starProvider=StateProvider<double>((ref) => 0);
  // var dropDownValue;

  @override
  Widget build(BuildContext context) {

    final user=ref.watch(userProvider)!;
    final dropVal=ref.watch(dropValue);
    final star=ref.watch(starProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,

      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(w*0.03),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dropVal??"All",
                  style: TextStyle(
                      fontSize: w*0.06,
                      fontWeight: FontWeight.w800,
                      color: Colors.white
                  ),),
                Container(
                    height: w*0.1,
                    width:w* 0.35,
                    margin: EdgeInsets.only(left:w*0.02),
                    padding: EdgeInsets.only(left:w*0.02,right: w*0.02),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(w*0.03)
                    ),
                    child:  ref.watch(getCategoryProvider).when(
                      data: (data) {
                        List<String> category=[];
                        for(CategoryModel doc in data){
                          category.add(doc.name);
                        }
                        if(data.isEmpty){
                          return const SizedBox();
                        }
                        return DropdownButton(
                          underline: const SizedBox(),
                          isExpanded: true,
                          hint:Text("select Category",
                              style: TextStyle(color: Colors.grey,
                              fontSize: w*0.04)),
                          icon: const Icon(Icons.keyboard_arrow_down_outlined,color: Colors.white),
                          borderRadius: BorderRadius.circular(w*0.03),
                          dropdownColor: Colors.teal,
                          value: dropVal,
                          items: category.map((e) =>
                              DropdownMenuItem(
                                  value: e,
                                  child: Text(e,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: w*0.05
                                      )))).toList(),
                          onChanged: (value) {
                              ref.read(dropValue.notifier).update((state) => value.toString());
                          },);
                      },
                      error: (error, stackTrace) => ErrorText(error: error.toString()),
                      loading: () => const Loader(),)
                ),
              ],
            ),
            SizedBox(height: w*0.03,),
            ref.watch(dropVal!=null?getDropProductProvider(dropVal): getProductProvider).when(
              data: (products) => products.isEmpty
                  ? const Center(child: Text('noData'))
                  : Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount:  products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      mainAxisSpacing: w*0.04,
                      crossAxisSpacing: w*0.04),
                  itemBuilder: (BuildContext context, int index) {
                    ProductList product =products[index];
                    return InkWell(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              PostDetailsScreen(products: product),)),
                      child: Container(
                        padding: EdgeInsets.all(w*0.03),
                        decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(w*0.03)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: w*0.08,
                                  width: w*0.13,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(w*0.04)
                                  ),
                                  child: Center(
                                    child: Text("${product.discount}%off",
                                      style: TextStyle(
                                          color: Colors.indigo,
                                          fontWeight: FontWeight.w800,
                                          fontSize: w*0.033
                                      ),),
                                  ),
                                ),
                                InkWell(
                                  onTap: ()=> addFavourite(ref,product),
                                    child: product.favourite.contains(user.id)?
                                   const Icon(Icons.favorite,color: Colors.red,):const Icon(Icons.favorite_border))
                              ],
                            ),
                            Container(
                              height: w*0.3,
                              width: w*0.3,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: NetworkImage(product.image),fit: BoxFit.fill),
                                  shape: BoxShape.circle
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product.prdctName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500
                                      ),),
                                    Text(product.price.toString(),
                                      style: TextStyle(
                                          fontSize: w*0.043,
                                          fontWeight: FontWeight.w900
                                      ),),
                                   // Text("⭐⭐⭐⭐☆")
                        RatingBar.builder(
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemSize: w*0.05,
                          itemCount: 5,
                          // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                            ref.read(starProvider.notifier).update((state) => rating);
                            updateRating(product);
                          },
                        )
                                  ],
                                ),
                                const CircleAvatar(
                                  backgroundColor: Colors.pink,
                                  child: Icon(Icons.add,color: Colors.white,),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },),
              ),
              error: (error, StackTrace stackTrace) =>
                  ErrorText(error: error.toString()),
              loading: () => const Loader(),
            )
          ],
        ),
      ),
    );
  }
}
