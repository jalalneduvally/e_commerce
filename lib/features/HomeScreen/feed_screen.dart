import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce/Model_class/banner_model.dart';
import 'package:e_commerce/features/HomeScreen/delegates/search_community_delegate.dart';
import 'package:e_commerce/features/post/screen/post_details_screen.dart';
import 'package:e_commerce/features/post/screen/view_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/common/error_text.dart';
import '../../core/common/loader.dart';
import '../../main.dart';
import '../auth/controller/auth_controller.dart';
import '../category/controller/category_controller.dart';
import '../product/controller/product_controller.dart';
Map <String,dynamic> prod={};


class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {

  final bannerIntexProvider=StateProvider<int>((ref) => 0);
  final categoryIntexProvider=StateProvider<int?>((ref) => null);
  int count=0;
  String categoryName="";

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    var currentIndex = ref.watch(bannerIntexProvider);
    var selectIndex = ref.watch(categoryIntexProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Home"),
        titleTextStyle:
            TextStyle(fontSize: w * 0.07, fontWeight: FontWeight.bold),
        centerTitle: true,
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        actions: [
          Padding(
            padding: EdgeInsets.all(w * 0.03),
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
              radius: w * 0.05,
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(w * 0.04),
        child: Column(
          children: [
            TextFormField(
              onTap: () {
                showSearch(context: context, delegate: SearchProductDelegate(ref));
              },
              readOnly: true,
              decoration: InputDecoration(
                  constraints: BoxConstraints(maxHeight: w * 0.13),
                  suffixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Search',
                  border: OutlineInputBorder(
                      gapPadding: w * 0.03,
                      borderSide: BorderSide(
                          color: Colors.white,
                          width: w * 0.03,
                          strokeAlign: w * 0.03),
                      borderRadius: BorderRadius.circular(w * 0.03))),
            ),
            ref.watch(getBannerProvider).when(
                  data: (banners) => banners.isEmpty
                      ? const Center(child: Text('noData'))
                      : CarouselSlider.builder(
                          itemCount: banners.length,
                          options: CarouselOptions(
                              autoPlay: false,
                              viewportFraction: 1.03,
                              onPageChanged: (index, reason) {
                                ref.read(bannerIntexProvider.notifier).update((state) => index);
                              },
                              autoPlayAnimationDuration: const Duration(seconds: 2,)),
                          itemBuilder: (BuildContext context, int index, int realIndex) {
                            BannerModel banner=banners[index];
                            count=banners.length;
                            return Container(
                              height: w * 0.12,
                              margin: EdgeInsets.all(w * 0.03),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(w * 0.03),
                                color: Colors.indigo,
                                image: DecorationImage(
                                    image: NetworkImage(banner.image),
                                    fit: BoxFit.cover)
                              ),
                            );
                          },
                        ),
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader(),
                ),
            AnimatedSmoothIndicator(
              activeIndex: currentIndex,
              count: count,
              effect: ExpandingDotsEffect(
                activeDotColor: Colors.indigo,
                dotHeight: w * 0.02,
                dotWidth: w * 0.02,
              ),
            ),
            ref.watch(getCategoryProvider).when(data: (data) => data.isEmpty?Text("No data"):
            SizedBox(
              height: w*0.2,
              width: w*1,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  final category=data[index];

                  return Row(
                    children: [
                      InkWell(
                        onTap: () {
                          ref.read(categoryIntexProvider.notifier).update((state) => index);
                          categoryName=category.name;
                        },
                        child: Container(
                          padding: EdgeInsets.all(w*0.03),
                          decoration: BoxDecoration(
                              color:selectIndex==index? Colors.pinkAccent:Colors.indigo,
                              borderRadius: BorderRadius.circular(w*0.03)
                          ),
                          child: Row(
                            children: [
                              Text (category.name,
                                  style:TextStyle(
                                    fontWeight: FontWeight.bold,
                                      fontSize: w*0.04,
                                      color: Colors.white
                                  )),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: w*0.04,)
                    ],
                  );
                },),
            ),
                error: (error, stackTrace) => ErrorText(error: error.toString()),
                loading: () => Loader(),),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  categoryName.isEmpty?"Popular":categoryName,
                  style: TextStyle(
                      fontSize: w * 0.045,
                      fontWeight: FontWeight.w800,
                      color: Colors.white
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewPost(),
                      )),
                  child: const Text(
                    "View All",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: w * 0.03,
            ),
            ref.watch(categoryName.isNotEmpty?getDropProductProvider(categoryName): getProductProvider).when(
                  data: (products) => products.isEmpty
                      ? const Center(child: Text('noData'))
                      : Expanded(
                          child: MasonryGridView.count(
                            itemCount: products.length,
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            crossAxisSpacing: w * 0.02,
                            mainAxisSpacing: w * 0.02,
                            itemBuilder: (BuildContext context, int index) {
                              for(var doc in products){
                                prod[doc.id] = doc.toJson();
                                // print(prod);

                              }


                              final product = products[index];
                              return InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PostDetailsScreen(products: product),
                                    )),
                                child: Container(
                                  height: (index % 4 == 0 || index % 4 == 3)
                                      ? w * 0.6
                                      : w * 0.65,
                                  padding: EdgeInsets.all(w * 0.03),
                                  decoration: BoxDecoration(
                                      color: Colors.primaries[index],
                                      borderRadius:
                                          BorderRadius.circular(w * 0.03)),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: w * 0.06,
                                        width: w * 0.13,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                w * 0.04)),
                                        child: Center(
                                          child: Text(
                                            "New",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w800,
                                                fontSize: w * 0.033),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Container(
                                          height: w * 0.35,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      product.image),
                                                  fit: BoxFit.fill),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      w * 0.04)),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.prdctName,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                product.price.toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.white,
                                                    fontSize: w * 0.05),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "${product.discount.toString()}",
                                                style: TextStyle(
                                                    fontSize: w * 0.06,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                "%off",
                                                style: TextStyle(
                                                    fontSize: w * 0.04,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.amberAccent),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
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
