import 'package:e_commerce/features/banner/banner_screen.dart';
import 'package:e_commerce/features/category/screen/add_category.dart';
import 'package:e_commerce/features/post/screen/add_post_screen.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class AddCommunity extends StatelessWidget {
  const AddCommunity({super.key});

  void navigate(BuildContext context,Widget page){
    Navigator.push(context, MaterialPageRoute(builder: (context) => page,));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Add Product"),
        titleTextStyle: TextStyle(
            fontSize: w*0.07,
            fontWeight: FontWeight.bold
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: ()=> navigate(context, const AddPostScreen()) ,
                child: SizedBox(
                  height: w*0.4,
                  width: w*0.4,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    color: Colors.grey,
                    elevation: 16,
                    child: Center(
                      child: Icon(Icons.add_shopping_cart,
                        size: w*0.2,),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () =>navigate(context,const AddCategory() ),
                child: SizedBox(
                  height: w*0.4,
                  width: w*0.4,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    color: Colors.grey,
                    elevation: 16,
                    child: Center(
                      child: Icon(Icons.category_outlined,
                        size: w*0.2,),
                    ),
                  ),
                ),
              ),
              ],
          ),
          GestureDetector(
            onTap: ()=> navigate(context, const AddBannerScreen()),
            child: SizedBox(
              height: w*0.4,
              width: w*0.4,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                color: Colors.grey,
                elevation: 16,
                child: Center(
                  child: Icon(Icons.photo_filter_sharp,
                    size: w*0.2,),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
