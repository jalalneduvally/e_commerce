import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Model_class/banner_model.dart';
import 'package:e_commerce/Model_class/cart_model.dart';
import 'package:e_commerce/Model_class/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../Model_class/product_model.dart';
import '../../../core/common/firebase_constants.dart';
import '../../../core/providers/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/providers/typedef.dart';



final productRepositoryProvider =Provider((ref) {
  return ProductRepository(firestore: ref.watch(firestoreProvider), ref: ref);
});
class ProductRepository {
  final FirebaseFirestore _firestore;
  final Ref _ref;

  ProductRepository({required FirebaseFirestore firestore,
  required Ref ref})
      :_firestore=firestore,_ref=ref;
  CollectionReference get _users => _firestore.collection(Constants.user);
  CollectionReference get _product => _firestore.collection(Constants.product);
  CollectionReference get _banner => _firestore.collection(Constants.banner);

  FutureVoid addProduct(ProductList product) async{
    try{
      var productDoc = await _product.doc(product.prdctName).get();
      if (productDoc.exists){
        throw "Product with the same name exist!";
      }
      return right(_product.doc(product.prdctName).set(product.toJson()));
    }on FirebaseException catch(e){
      throw e.message!;
    } catch(e){
      return left(Failure(e.toString()));
    }
  }

  //add banner

  FutureVoid
  addBanner(BannerModel banner,String id)async{
   try{
     return right(await _banner.doc(id).set(banner.toJson()));
   }on FirebaseException catch(e){
     return left(Failure(e.toString()));
   } catch(e){
     return left(Failure(e.toString()));
   }
  }

  Stream<List<ProductList>> getProduct(){
    return _product
        .where('delete', isEqualTo: false).orderBy('date', descending: true)
        .snapshots().map((event) => event.docs
        .map((e) => ProductList.fromJson(
      e.data() as Map<String, dynamic>,
    ),
    ).toList(),
    );
  }

  Stream<List<BannerModel>> getBanner(){
    return _banner
        .where('delete', isEqualTo: false)
        .snapshots().map((event) => event.docs
        .map((e) => BannerModel.fromJson(
      e.data() as Map<String, dynamic>,
    ),
    ).toList(),
    );
  }

  Stream<List<ProductList>> getDropProduct(String category){
    return _product
        .where('delete', isEqualTo: false).where("category",isEqualTo:category )
        .orderBy('date', descending: true)
        .snapshots().map((event) => event.docs
        .map((e) => ProductList.fromJson(
      e.data() as Map<String, dynamic>,
    ),
    ).toList(),
    );
  }

  Stream<List<ProductList>> getFavoratieProduct(String uid){
    return _product
        .where('delete', isEqualTo: false)
        .where("favourite",arrayContains:  uid)
        .orderBy('date', descending: true)
        .snapshots().map((event) => event.docs
        .map((e) => ProductList.fromJson(
      e.data() as Map<String, dynamic>,
    ),
    ).toList(),
    );
  }

  Stream<UserModel> getCartProduct({required String id}){
    return _users
        .doc(id)
        .snapshots().map((event) => UserModel.fromjson(event.data() as Map<String,dynamic>)
    );
  }

  FutureVoid editProduct(ProductList productList)async{
    try{

      return right(_product.doc(productList.id).update(productList.toJson()));

    }on FirebaseException catch(e){
      throw e.message!;
    } catch(e){
      return left(Failure(e.toString()));
    }
  }

  FutureVoid updateRating(ProductList productList,double value)async{
    try{
      return right(_product.doc(productList.id).update({
        if(value<=1)
        "ratingOne":FieldValue.increment(1),
        if(value<=2)
        "ratingTwo":FieldValue.increment(1),
        if(value<=3)
        "ratingThree":FieldValue.increment(1),
        if(value<=4)
        "ratingFour":FieldValue.increment(1),
        if(value<=5)
          "ratingFive":FieldValue.increment(1),
      })
      );
    }on FirebaseException catch(e){
      throw e.message!;
    } catch(e){
      return left(Failure(e.toString()));
    }
  }


  Stream<List<ProductList>> searchProduct(String query){
    return _product.where(
        'prdctName',isGreaterThanOrEqualTo: query.isEmpty?0:query
        ,isLessThan:query.isEmpty?null : query.substring(0,query.length-1)+
        String.fromCharCode(
            query.codeUnitAt(query.length-1)+1)).snapshots().map((event) {
      List<ProductList> allProduct =[];
      for(var products in event.docs){
        allProduct.add(ProductList.fromJson(products.data() as Map<String,dynamic>));
      }
      return allProduct;
    });
  }

  FutureVoid editProductName(ProductList productList)async{
    try{
      var productDoc = await _product.where("prdctName",isEqualTo:productList.prdctName ).get();
      if (productDoc.docs.isEmpty){
        return right(_product.doc(productList.id).update(productList.toJson()));
      }else {
        throw "Product with the same name exist!";
      }
    }on FirebaseException catch(e){
      throw e.message!;
    } catch(e){
      return left(Failure(e.toString()));
    }
  }

  FutureVoid deleteProduct(ProductList product)async{
    try{
      return right(_product.doc(product.id).update(product.toJson()));
    }on FirebaseException catch(e){
      throw e.message!;
    } catch(e){
      return left(Failure(e.toString()));
    }
  }



  void addFavourite(ProductList product,String userId)async{
    if(product.favourite.contains(userId)){
      _product.doc(product.id).update({
        "favourite":FieldValue.arrayRemove([userId]),
      });

    }else{
      _product.doc(product.id).update({
        "favourite":FieldValue.arrayUnion([userId]),
      });
    }
  }

  FutureVoid addCart(UserModel user,List cart)async{
    try{
        return right(_users.doc(user.id).update({
          "cart":FieldValue.arrayUnion(cart),
        }));

    }on FirebaseException catch(e){
      throw e.message!;
    } catch(e){
      return left(Failure(e.toString()));
    }
  }

  FutureVoid   updateCart(UserModel user,List cart)async{
    try{
        return right(_users.doc(user.id).update({
          "cart":cart,
        }));

    }on FirebaseException catch(e){
      throw e.message!;
    } catch(e){
      return left(Failure(e.toString()));
    }
  }

  FutureVoid addCartId(UserModel user,List cartId)async{
    try{
        return right(_users.doc(user.id).update({
          "cartId":FieldValue.arrayUnion(cartId),
        }));

    }on FirebaseException catch(e){
      throw e.message!;
    } catch(e){
      return left(Failure(e.toString()));
    }
  }

  FutureVoid removeCart(UserModel user,Map product)async{
    try{
      return right(_users.doc(user.id).update({
        "cart":FieldValue.arrayRemove([product]),
      }));
    }on FirebaseException catch(e){
      throw e.message!;
    } catch(e){
      return left(Failure(e.toString()));
    }
  }


  reference(String name){
    return _product.doc(name);
  }

}