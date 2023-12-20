import 'package:e_commerce/features/post/screen/post_cart_screen.dart';
import 'package:e_commerce/features/post/screen/post_favorite_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../auth/controller/auth_controller.dart';
import '../auth/screen/login_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {

  Future<void> logOut(WidgetRef ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("uid");
    ref.read(authControllerProvider.notifier).logout();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
        LoginScreen(),), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user=ref.watch(userProvider)!;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Profile"),
        titleTextStyle: TextStyle(
          fontSize: w*0.07,
          fontWeight: FontWeight.bold
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: ()=>logOut(ref),
                child: Icon(Icons.logout_rounded,color: Colors.white,size: w*0.075,)),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(w*0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
                radius: w*0.23,
              ),
            ),
            SizedBox(height: w*0.04,),
            Text(user.name,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: w*0.05
            ),),
            Text(user.email,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
              ),),
            SizedBox(height: w*0.05,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () =>
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PostFavoriteScreen(),)),
                  child: Container(
                    height: w*0.1,
                    width: w*0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(w*0.04),
                      border: Border.all(color: Colors.white)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.favorite,color: Colors.red),
                        Text("favorite",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: w*0.05,
                        ),)
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () =>
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PostCartScreen(),)),
                  child: Container(
                    height: w*0.1,
                    width: w*0.3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(w*0.04),
                        border: Border.all(color: Colors.white)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.shopping_cart,color: Colors.white),
                        Text("Cart",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: w*0.05,
                          ),)
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: w*0.5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: w*0.05,),
                Icon(Icons.logout_rounded,color: Colors.redAccent,size: w*0.075,),
                SizedBox(width: w*0.03,),
                InkWell(
                  onTap: ()=>logOut(ref),
                  child: Text("Log out",
                    style: TextStyle(
                        fontSize:w*0.06 ,
                        fontWeight: FontWeight.w800,
                        color: Colors.redAccent
                    ),),
                )
              ],
            )

          ],
        ),
      ),
    );
  }
}
