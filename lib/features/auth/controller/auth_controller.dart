import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Model_class/user_model.dart';
import '../../../core/common/firebase_constants.dart';
import '../../HomeScreen/home_screen.dart';
import '../repository/auth_repository.dart';


final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
      (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider), ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

// final getUserDataProvider = StreamProvider.family((ref, String uid) {
//   final authController = ref.watch(authControllerProvider.notifier);
//   return authController.getUserData(uid);
// });

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository authRepository,required Ref ref})
      : _authRepository = authRepository,_ref = ref,super(false);

  // loading

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithGoogle(BuildContext context)  async {
    state =true;
    final user=await _authRepository.signInWithGoogle();
    state =false;
    user.fold((l) => showMessage(context, text:l.message,color: Colors.red),
            (userModel) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('uid', userModel.id);
      _ref.read(userProvider.notifier).update((state) => userModel);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen(),), (route) => false);
            });

  }


  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void logout() async {
    _authRepository.logOut();
  }
}