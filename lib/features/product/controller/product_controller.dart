import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Model_class/user_model.dart';
import 'package:e_commerce/core/providers/firebase_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../Model_class/banner_model.dart';
import '../../../Model_class/category_model.dart';
import '../../../Model_class/product_model.dart';
import '../../../core/common/firebase_constants.dart';
import '../../../core/providers/storage_repository_provider.dart';
import 'dart:io';

import '../../auth/controller/auth_controller.dart';
import '../repository/product_repository.dart';

final searchProductProvider=StreamProvider.family((ref, String query) {
  return ref.watch(productControllerProvider.notifier).searchProduct(query);
});

 final getProductProvider = StreamProvider.autoDispose((ref){
  return ref.watch(productControllerProvider.notifier).getProduct();
 });


final getBannerProvider = StreamProvider((ref){
  return ref.watch(productControllerProvider.notifier).getBanner();
});

final getDropProductProvider = StreamProvider.family.autoDispose((ref,String category){
  return ref.watch(productControllerProvider.notifier).getDropProduct(category);
});

final getFavoriteProductProvider = StreamProvider.family((ref,String uid){
  return ref.watch(productControllerProvider.notifier).getFavoriteProduct(uid);
});

final getCartProductProvider = StreamProvider.family.autoDispose((ref,String id){
  return ref.watch(productControllerProvider.notifier).getCartProduct(id: id);
});


final productControllerProvider= StateNotifierProvider<ProductController,bool>((ref) {
  final productRepository=ref.watch(productRepositoryProvider);
  final storageRepository=ref.watch(storageRepositoryProvider);
  return ProductController(
      productRepository: productRepository,
      ref: ref,
    storageRepository: storageRepository,
     );
});

class ProductController extends StateNotifier<bool> {
  final ProductRepository _productRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  ProductController({
    required ProductRepository productRepository,
    required StorageRepository storageRepository,
    required Ref ref,

   }):_productRepository=productRepository,
        _storageRepository=storageRepository,
        _ref=ref,
        super(false);

  void addProduct({
   required String name,
   required String brand,
    required double price,
    required bool delete,
    required String description,
    required int discount,
    required CategoryModel category,
    required BuildContext context,
    required File? file,
   })async{
    state =true;
    DocumentReference reference=_ref.watch(productRepositoryProvider).reference(name);
    String postId = const Uuid().v1();
    final imageRes = await _storageRepository.storeFile(
      path: 'products/${name}',
      id: postId,
      file: file,
      // webFile: webFile,
    );
    imageRes.fold((l) => showMessage(context,text:  l.message,color: Colors.red), (r) async {

    ProductList product=ProductList(
        prdctName: name,
        price: price,
        delete: delete,
        favourite:[],
        image: r,
        id: name,
        description: description,
        category: category.name,
        date: DateTime.now(),
        reference: reference,
        brand: brand,
        cart: [],
        discount: discount,
        ratingOne: 0,
      ratingTwo: 0,
      ratingThree: 0,
      ratingFour: 0,
      ratingFive: 0,
    );
    final res=await _productRepository.addProduct(product);
    state =false;
    res.fold((l) => showMessage(context,text:l.message,color: Colors.red), (r) {
      showMessage(context,text:"Product Created successfully..!",color: Colors.green);
      Navigator.of(context).pop();
    });
    });
  }

   addBanner({
    required File? file,
    required BuildContext context
}) async {
    state =true;
    String postId = const Uuid().v1();
    DocumentReference reference=_ref.read(firestoreProvider).collection(Constants.banner).doc();
    final imageRes = await _storageRepository.storeFile(
      path: 'banner/$postId',
      id: postId,
      file: file,
    );
    imageRes.fold((l) => showMessage(context,text:  l.message,color: Colors.red), (r) async {

      BannerModel banner=BannerModel(
          image: r,
          id: reference.id,
          delete: false,
          reference: reference);
      final res=await _productRepository.addBanner(banner,reference.id);
      state =false;
      res.fold((l) => showMessage(context,text:l.message,color: Colors.red), (r) {
        showMessage(context,text:"Banner Created successfully..!",color: Colors.green);
        Navigator.of(context).pop();
      });
    });
  }

  Future<void> updateRating({
    required BuildContext context,
    required ProductList product,
    required double value
}) async {
    final re=await _productRepository.updateRating(product,value);
          re.fold(
                (l) => showMessage(context,text: l.message,color: Colors.red),
                (r) => null,
          );

  }

  Stream<List<ProductList>> searchProduct(String query){
    return _productRepository.searchProduct(query);
  }

  // void editProduct({
  //   required BuildContext context,
  //   required String name,
  //   required double price,
  //   required bool favourite,
  //   required String description,
  //   required String category,
  //   required File? file,
  //   required ProductList product
  // })async{
  //   state=true;
  //   if(file != null){
  //     final res=await _storageRepository.storeFile(
  //         path: 'products/${product.id}',
  //         id: category,
  //         file: file);
  //     res.fold(
  //             (l) => showMessage(context,text: l.message,color: Colors.red),
  //             (r) => product=product.copyWith(image: r,));
  //   }
  //
  //   final re=await _productRepository.editProductName(product.copyWith(
  //       prdctName: name
  //   ));
  //   re.fold(
  //         (l) => showMessage(context,text: l.message,color: Colors.red),
  //         (r) => null,
  //   );
  //
  //   final result =await _productRepository.editProduct(product.copyWith(
  //       favourite:favourite,
  //       price: price,
  //       category: category,
  //       description: description
  //   ));
  //   state=false;
  //   result.fold(
  //           (l) => showMessage(context,text: l.message,color: Colors.red),
  //           (r) {
  //             showMessage(context,text: "Updated Successfully..!",color: Colors.green);
  //             Navigator.of(context).pop();
  //           }
  //   );
  // }

  // Future<void> editProductName(BuildContext context,String name, ProductList product) async {
  //   final re=await _productRepository.editProductName(product.copyWith(
  //       prdctName: name
  //   ));
  //   re.fold(
  //         (l) => showMessage(context,text: l.message,color: Colors.red),
  //         (r) => null,
  //   );
  // }

  void addFavourite(ProductList product)async{
    final id= _ref.read(userProvider)!.id;
    _productRepository.addFavourite(product, id);
  }

  void addCart(UserModel user,BuildContext context,List cart)async{

    final res=await _productRepository.addCart(user,cart);
    state=false;
    res.fold(
            (l) => showMessage(context,text: l.message,color: Colors.red),
            (r) {
          showMessage(context, text: "Add Cart Successfully..!", color: Colors.green);
        }
    );
  }

  void updateCart(UserModel user,BuildContext context,List cart)async{

    final res=await _productRepository.updateCart(user,cart);
    state=false;
    res.fold(
            (l) => showMessage(context,text: l.message,color: Colors.red),
            (r) {
          // showMessage(context, text: "update Cart Successfully..!", color: Colors.green);
        }
    );
  }


  void addCartId(UserModel user,BuildContext context,List cart)async{

    final res=await _productRepository.addCartId(user,cart);
    state=false;
    res.fold(
            (l) => showMessage(context,text: l.message,color: Colors.red),
            (r) {
          showMessage(context, text: "Add CartId Successfully..!", color: Colors.green);
        }
    );
  }

  void removeCart(BuildContext context,Map product)async{
    final user= _ref.read(userProvider)!;
    final res=await _productRepository.removeCart(user, product);
    state=false;
    res.fold(
            (l) => showMessage(context,text: l.message,color: Colors.red),
            (r) {
          showMessage(context, text: "remove Cart Successfully..!", color: Colors.green);
        }
    );
  }

  Future<void> deleteProduct(ProductList product,BuildContext context) async {
    final result =await _productRepository.deleteProduct(product.copyWith(
        delete: true
    ));
    state=false;
    result.fold(
            (l) => showMessage(context,text: l.message,color: Colors.red),
            (r) {
              showMessage(context, text: "Deleted Successfully..!", color: Colors.green);
              Navigator.pop(context);
            }
    );
  }



  Stream<List<ProductList>> getProduct(){
    return _productRepository.getProduct();
  }

  Stream<List<BannerModel>> getBanner(){
    return _productRepository.getBanner();
  }

  Stream<List<ProductList>> getDropProduct(String category){
    return _productRepository.getDropProduct(category);
  }

  Stream<List<ProductList>> getFavoriteProduct(String uid){
    return _productRepository.getFavoratieProduct(uid);
  }

  Stream<UserModel> getCartProduct({required String id}){
    return _productRepository.getCartProduct(id: id);
  }

}