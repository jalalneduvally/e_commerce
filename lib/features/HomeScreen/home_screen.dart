import 'package:e_commerce/features/HomeScreen/feed_screen.dart';
import 'package:e_commerce/features/HomeScreen/profile_screen.dart';
import 'package:e_commerce/features/post/screen/post_cart_screen.dart';
import 'package:e_commerce/features/post/screen/post_favorite_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add_community.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  final navIndex=StateProvider<int>((ref) => 0);

  void onPageChanged(int page){
      ref.read(navIndex.notifier).update((state) => page);
  }
 static const List changePage=[
    FeedScreen(),
   AddCommunity(),
   PostFavoriteScreen(),
   PostCartScreen(),
     ProfileScreen(),

  ];
  @override
  Widget build(BuildContext context) {
    final nav=ref.watch(navIndex);
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: CupertinoTabBar(
        activeColor: Colors.teal,
        backgroundColor: Colors.black,
        items:  const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              ),
        ],
        onTap: onPageChanged,
        currentIndex: nav,
      ),
      body: changePage[nav],
    );
  }
}
