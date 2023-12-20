import 'package:e_commerce/Model_class/banner_model.dart';
import 'package:e_commerce/core/common/error_text.dart';
import 'package:e_commerce/core/common/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../../core/common/firebase_constants.dart';
import '../../main.dart';
import '../product/controller/product_controller.dart';

class AddBannerScreen extends ConsumerStatefulWidget {
  const AddBannerScreen({super.key});

  @override
  ConsumerState createState() => _AddBannerScreenState();
}

class _AddBannerScreenState extends ConsumerState<AddBannerScreen> {

  final fileImage=StateProvider<File?>((ref) => null);
  void selectImage() async {
    final res= await pickImage();
    if(res !=null){
      ref.read(fileImage.notifier).update((state) => File(res.path));
    }
  }

  void addBanner(){
    ref.read(productControllerProvider.notifier).
    addBanner(
        file: ref.read(fileImage),
        context: context
    );
  }

  @override
  Widget build(BuildContext context) {
    final file=ref.watch(fileImage);

    return Scaffold(
      body: Column(
        children: [
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
          SizedBox(height: w*0.05,),
          InkWell(
            onTap: () {
              if(file!=null){
                addBanner();
              }else{
                showMessage(context,text: "please select image", color: Colors.red);
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

          ref.watch(getBannerProvider).when(
              data: (banners) => banners.isEmpty
                  ? const Center(child: Text('noData'))
                  :Expanded(
                  child: ListView.builder(
                    itemCount: banners.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                      final banner =banners[index];
                        return ListTile(
                          title: Image.network(banner.image),
                          trailing: InkWell(
                              onTap: () {
                                var a=banner.copyWith(
                                  delete: true
                                );
                                banner.reference.update(a.toJson());
                              },
                              child: Icon(Icons.delete)),
                        );
                      },
                  )
              ),
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => const Loader(),)
        ],
      ),
    );
  }
}
