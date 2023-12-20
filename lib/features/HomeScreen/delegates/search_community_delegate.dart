import 'package:e_commerce/features/post/screen/post_details_screen.dart';
import 'package:e_commerce/features/product/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';

class SearchProductDelegate extends SearchDelegate{
  final WidgetRef ref;
  SearchProductDelegate(this.ref);
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () {
        query ="";
      }, icon: Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
   return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
   return ref.watch(searchProductProvider(query)).when(
      data: (communities) =>ListView.builder(
        itemCount: communities.length,
        itemBuilder: (context, index) {
          final community=communities[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(community.image),
            ),
            title: Text(community.prdctName),
            onTap: () =>Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetailsScreen(products: community),)),
          );
        } ,) ,
        error:(error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => Loader(),);
  }
}