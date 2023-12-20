import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../Model_class/user_model.dart';
import '../../../core/common/firebase_constants.dart';
import '../../../core/providers/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/providers/typedef.dart';

final authRepositoryProvider = Provider(
      (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  CollectionReference get _users => _firestore.collection(Constants.user);

  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async {
    try {

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential;

      userCredential = await _auth.signInWithCredential(credential);

   DocumentReference reference =_users.doc(userCredential.user!.uid);

      UserModel userModel;
      if(userCredential.additionalUserInfo!.isNewUser){
        userModel = UserModel(
          name: userCredential.user!.displayName ?? 'No Name',
          id: userCredential.user!.uid,
          delete: false,
          reference: reference,
          email: userCredential.user!.email!,
          date: DateTime.now(),
          profilePic: userCredential.user!.photoURL!,
          cartId: [],
          cart: [],

        );
        await reference.set(userModel.toJson());
      }else{
        userModel =await getUserData(userCredential.user!.uid).first;
        print(userCredential.user!.uid);
        print("+++++++++++++++++++++++");
      }
      return right(userModel) ;
    }on FirebaseException catch(e,a){
      print(a);
      throw e.message!;
    } catch (e){
      return left(Failure(e.toString()));
    }
  }



  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map((event) => UserModel.fromjson(event.data()));
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}