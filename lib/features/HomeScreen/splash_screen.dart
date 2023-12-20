
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../Model_class/user_model.dart';
import '../../main.dart';
import '../auth/controller/auth_controller.dart';
import '../auth/screen/login_screen.dart';
import 'home_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  loggedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('uid')){
      String? uid = prefs.getString('uid');
      UserModel user = await ref.watch(authControllerProvider.notifier).getUserData(uid!).first;
      ref.read(userProvider.notifier).update((state) => user);
      Future.delayed(const Duration(seconds: 2))
          .then((value) =>Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen(),), (route) => false));
    }else{
    Future.delayed(const Duration(seconds: 2))
        .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) =>const LoginScreen(),)));
  }
      }
  @override
  void initState() {
    loggedPref();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome to",
                style: TextStyle(
                  color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: w*0.08,
                ),),
              SizedBox(height: w*0.04,),
              Text("E-commerceApp",
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.w900,
                  fontSize: w*0.11,
                ),),
            ],
          ),
        ],
      ),
    );
  }
}
