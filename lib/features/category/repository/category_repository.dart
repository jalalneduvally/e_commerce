import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../Model_class/category_model.dart';
import '../../../core/common/firebase_constants.dart';
import '../../../core/providers/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/providers/typedef.dart';

final categoryRepositoryProvider =Provider((ref) {
  return CategoryRepository(firestore: ref.watch(firestoreProvider));
});
class CategoryRepository {
  final FirebaseFirestore _firestore;

  CategoryRepository({required FirebaseFirestore firestore})
      :_firestore=firestore;


  FutureVoid addCategory(CategoryModel category) async{
    try{
      var categoryDoc = await _category.doc(category.id).get();
      if (categoryDoc.exists){
        throw "Category with the same name exist!";
      }
      return right(_category.doc(category.name).set(category.toJson()));
    }on FirebaseException catch(e){
      throw e.message!;
    } catch(e){
      return left(Failure(e.toString()));
    }
  }

  Stream<List<CategoryModel>> getCategory(){
    return _category
        .where('delete', isEqualTo: false)
        .snapshots().map((event) => event.docs
        .map((e) => CategoryModel.fromjson(
      e.data() as Map<String, dynamic>,
    ),
    ).toList(),
    );
  }

  reference(String name){
    return _category.doc(name);
  }

  CollectionReference get _category => _firestore.collection(Constants.category);
}