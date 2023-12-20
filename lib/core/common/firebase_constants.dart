import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Constants {
  static const product ="product";
  static const category ="category";
  static const user ="user";
  static const banner ="banner";
  static const google ="assets/images/google.png";
}
void showMessage(BuildContext context,{required String text,required Color color}){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: color,
          content: Text(text))
  );
}
Future pickImage() async {
  final imagefile=await ImagePicker.platform.pickImage(source: ImageSource.gallery);
  return imagefile;
}