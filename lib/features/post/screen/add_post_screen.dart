import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Model_class/category_model.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/firebase_constants.dart';
import '../../../core/common/loader.dart';
import '../../../main.dart';
import '../../category/controller/category_controller.dart';
import '../../product/controller/product_controller.dart';

class AddPostScreen extends ConsumerStatefulWidget {
  const AddPostScreen({super.key});

  @override
  ConsumerState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<AddPostScreen> {

  TextEditingController nameController=TextEditingController();
  TextEditingController brandController=TextEditingController();
  TextEditingController amountController=TextEditingController();
  TextEditingController discountController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();


  final fileImage=StateProvider<File?>((ref) => null);
  final dropValue=StateProvider<CategoryModel?>((ref) => null);

  void selectImage() async {
    final res= await pickImage();
    if(res !=null){
      ref.read(fileImage.notifier).update((state) => File(res.path));

    }
  }

  List <CategoryModel> category=[];
  // CategoryModel? dropDownValue;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    brandController.dispose();
    discountController.dispose();
  }
  void addProduct(){
    ref.read(productControllerProvider.notifier).
    addProduct(
      name: nameController.text.trim(),
      price:double.tryParse(amountController.text.trim().toString())??0 ,
      delete: false,
      description: descriptionController.text.trim(),
      category: ref.read(dropValue)??category[0],
      context: context,
      file: ref.read(fileImage),
      brand: brandController.text.trim(),
      discount: int.tryParse(discountController.text.trim().toString())??0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final file=ref.watch(fileImage);
    final dropDownValue =ref.watch(dropValue);

    return Scaffold(
      backgroundColor: Colors.black,

      body: Padding(
        padding: EdgeInsets.all(w*0.03),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: w*0.3,),
              Stack(
                children: [
                  file !=null?
                  Container(
                    height: w*0.5,
                    width: w*1,
                    decoration: BoxDecoration(
                      image: DecorationImage(image:  FileImage(file),fit: BoxFit.fill,),
                        borderRadius: BorderRadius.circular(w*0.03),
                        border: Border.all()
                    ),
                  ):
                  Container(
                    height: w*0.5,
                    width: w*1,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                        borderRadius: BorderRadius.circular(w*0.03),
                        border: Border.all()
                    ),
                  ),
                  Positioned(
                    right: w*0.02,
                    bottom: w*0.01,
                    child: InkWell(
                      onTap: () {
                        selectImage();
                      },
                      child: CircleAvatar(
                        radius: w*0.04,
                        child: Icon(Icons.add_a_photo_outlined,size: w*0.05),
                      ),
                    ),
                  ),
                ],
              ) ,
              SizedBox(height: w*0.07,),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  constraints: BoxConstraints(maxHeight: w*0.13),
                  filled: true,
                    fillColor: Colors.white,
                    hintText: "product name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(w*0.03),
                    )
                ),
              ),
              SizedBox(height: w*0.05,),
              TextFormField(
                controller: brandController,
                decoration: InputDecoration(
                    constraints: BoxConstraints(maxHeight: w*0.13),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "brand name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(w*0.03),
                    )
                ),
              ),
              SizedBox(height: w*0.05,),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: amountController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    constraints: BoxConstraints(maxHeight: w*0.13),
                    hintText: "amount",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(w*0.03),
                    )
                ),
              ),
              SizedBox(height: w*0.05,),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: discountController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    constraints: BoxConstraints(maxHeight: w*0.13),
                    hintText: "discount",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(w*0.03),
                    )
                ),
              ),
              SizedBox(height: w*0.05,),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    constraints: BoxConstraints(maxHeight: w*0.13),
                    hintText: "description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(w*0.03),
                    )
                ),
              ),
              SizedBox(height: w*0.05,),
              Container(
                  height: w*0.1,
                  width:w* 0.5,
                  margin: EdgeInsets.only(left:w*0.02),
                  padding: EdgeInsets.only(left:w*0.02,right: w*0.02),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(w*0.03)
                  ),
                  child:  ref.watch(getCategoryProvider).when(
                    data: (data) {
                      category =data;
                      if(data.isEmpty){
                        return const SizedBox();
                      }
                      return DropdownButton(
                        underline: const SizedBox(),
                        isExpanded: true,
                        hint: const Text("select Category",style: TextStyle(color: Colors.grey)),
                        icon: const Icon(Icons.keyboard_arrow_down_outlined,color: Colors.white),
                        borderRadius: BorderRadius.circular(w*0.03),
                        dropdownColor: Colors.teal,
                        value: dropDownValue,
                        items: data.map((e) =>
                            DropdownMenuItem(
                                value: e,
                                child: Text(e.name,
                                    style: TextStyle(
                                        color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: w*0.06
                                    )))).toList(),
                        onChanged: (value) {
                          ref.read(dropValue.notifier).update((state) => value);
                        },);
                    },
                    error: (error, stackTrace) => ErrorText(error: error.toString()),
                    loading: () => const Loader(),)
              ),
              SizedBox(height: w*0.05,),
              InkWell(
                onTap: () {
                  if(nameController.text.isNotEmpty&&
                      amountController.text.isNotEmpty&&
                      brandController.text.isNotEmpty&&
                      descriptionController.text.isNotEmpty&&
                      dropDownValue!=null)
                  {
                    addProduct();
                  }else{
                    nameController.text.isEmpty?showMessage(context,text: "please enter name", color: Colors.red):
                    amountController.text.isEmpty?showMessage(context,text: "please enter amount ", color: Colors.red):
                    brandController.text.isEmpty?showMessage(context,text: "please enter brand ", color: Colors.red):
                    descriptionController.text.isEmpty?showMessage(context,text: "please enter description ", color: Colors.red):
                    showMessage(context,text: "please select category", color: Colors.red);
                  }
                },
                child: Container(
                  height: w*0.1,
                  width: w*0.2,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(w*0.03)
                  ),
                  child: const Center(child: Text("Add")),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
