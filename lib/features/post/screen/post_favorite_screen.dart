import 'package:e_commerce/core/common/error_text.dart';
import 'package:e_commerce/core/common/loader.dart';
import 'package:e_commerce/features/post/screen/post_details_screen.dart';
import 'package:e_commerce/features/product/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../main.dart';
import '../../auth/controller/auth_controller.dart';

class PostFavoriteScreen extends ConsumerStatefulWidget {
  const PostFavoriteScreen({super.key});

  @override
  ConsumerState createState() => _PostFavoriteScreenState();
}

class _PostFavoriteScreenState extends ConsumerState<PostFavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
          title: const Text("Favorite"),
        titleTextStyle: TextStyle(
            fontSize: w*0.07,
            fontWeight: FontWeight.bold
        ),),

      body: Column(
        children: [
          ref.watch(getFavoriteProductProvider(user.id))
              .when(data: (data) => data.isEmpty
              ? const Center(child: Text('noData'))
              : Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: data.length,
              physics:const BouncingScrollPhysics() ,
              itemBuilder: (context, index) {
                final favorite=data[index];
                return InkWell(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder:
                          (context) =>PostDetailsScreen(products: favorite),)),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: w * 0.4,
                        width: w * 0.3,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(w * 0.03),
                            image: DecorationImage(
                                image:
                                NetworkImage(favorite.image),
                                fit: BoxFit.cover)),
                      ),
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text("Name: ${favorite.prdctName}",
                              style: TextStyle(
                                color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: w * 0.04)),
                          SizedBox(
                            height: w * 0.03,
                          ),
                          Text("price: ${favorite.price.toString()}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: w * 0.04)),
                          SizedBox(
                            height: w * 0.03,
                          ),

                          Text(
                              "category: ${favorite.category.toString()}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: w * 0.04)),
                        ],
                      ),

                    ],
                  ),
                );

              }, separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: w*0.03,);
            } ,),
          ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),)
        ],
      ),
    );
  }
}
