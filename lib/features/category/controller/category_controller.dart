import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../Model_class/category_model.dart';
import '../../../core/common/firebase_constants.dart';
import '../repository/category_repository.dart';


final getCategoryProvider = StreamProvider.autoDispose((ref){
  return ref.watch(categoryControllerProvider.notifier).getCategory();
});

final categoryControllerProvider= StateNotifierProvider<CategoryController,bool>((ref) {
  final categoryRepository=ref.watch(categoryRepositoryProvider);
  return CategoryController(
    categoryRepository: categoryRepository,
    ref: ref,
  );
});

class CategoryController extends StateNotifier<bool> {
  final CategoryRepository _categoryRepository;
  final Ref _ref;

  CategoryController({
    required CategoryRepository categoryRepository,
    required Ref ref,
  }):_categoryRepository=categoryRepository,
        _ref=ref,
        super(false);

  void addCategory({
    required String name,
    required BuildContext context
  })async{
    state =true;
    DocumentReference reference=_ref.watch(categoryRepositoryProvider).reference(name);

    CategoryModel category=CategoryModel(
        name: name, 
        id: name, 
        delete: false, 
        reference: reference);
    final res= await _categoryRepository.addCategory(category);
    state =false;
    res.fold((l) => showMessage(context,text:l.message,color: Colors.red), (r) {
      showMessage(context,text:"Category Created successfully..!",color: Colors.green);
    });
  }

  Stream<List<CategoryModel>> getCategory(){
    return _categoryRepository.getCategory();
  }
}