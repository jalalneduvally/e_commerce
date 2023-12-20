import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../Model_class/category_model.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/firebase_constants.dart';
import '../../../core/common/loader.dart';
import '../../../main.dart';
import '../controller/category_controller.dart';

class AddCategory extends ConsumerStatefulWidget {
  const AddCategory({super.key});

  @override
  ConsumerState<AddCategory> createState() => _catogaryPageState();
}

class _catogaryPageState extends ConsumerState<AddCategory> {

  addCategory(){
    ref.read(categoryControllerProvider.notifier).addCategory(
        name: categoryController.text.trim(),
        context: context);
    categoryController.clear();
  }

  TextEditingController categoryController=TextEditingController();

  @override
  void dispose() {
    super.dispose();
    categoryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(w*0.03),
        child: Column(
          children: [
            SizedBox(height: w*0.05,),
          TextFormField(
          controller: categoryController,
          decoration: InputDecoration(
              constraints: BoxConstraints(maxHeight: w*0.13),
              filled: true,
              fillColor: Colors.white,
              hintText: "Category",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(w*0.03),
              )
          ),
        ),
            SizedBox(height: w*0.03,),
            InkWell(
              onTap: () {
                if(
                categoryController.text.isNotEmpty){
                  addCategory();

                }else{
                  showMessage(context,text: "please enter category", color: Colors.red);
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
            ),
        ref.watch(getCategoryProvider).when(
          data: (categories) =>categories.isEmpty?const Center(child: Text('noData'))
              :
          Expanded(
              child:  ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  CategoryModel category =categories[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text("Category :   ${category.name}",
                              style: TextStyle(
                                color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: w*0.06
                              )),
                        ],
                      ),
                      InkWell(
                          onTap: () {
                            showDialog(context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Do you want to delete?"),
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          var a =category.copyWith(
                                              delete: true
                                          );
                                          category.reference.update(a.toJson());
                                          showMessage(context, text: "Deleted successfully", color: Colors.green);
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: w*0.1,
                                          width: w*0.15,
                                          decoration: BoxDecoration(
                                            color: Colors.purple,
                                            borderRadius: BorderRadius.circular(w*0.03),
                                          ),
                                          child: const Center(
                                            child: Text("Yes",style:
                                            TextStyle(
                                                color: Colors.white
                                            )),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: w*0.1,
                                          width: w*0.15,
                                          decoration: BoxDecoration(
                                            color: Colors.purple,
                                            borderRadius: BorderRadius.circular(w*0.03),
                                          ),
                                          child: const Center(
                                            child: Text("No",style:
                                            TextStyle(
                                                color: Colors.white
                                            )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },);
                          },
                          child: Icon(Icons.delete,color: Colors.redAccent,size: w*0.08,)),
                    ],
                  );
                }, separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: w*0.03,);
              },
              )

          ), error: (error, StackTrace stackTrace)=>ErrorText(error: error.toString()),
          loading: () =>const Loader(),
        )
          ],
        ),
      ),
    );
  }
}
