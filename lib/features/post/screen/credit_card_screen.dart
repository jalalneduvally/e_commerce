import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';



class creditCard extends StatefulWidget {
  // String id;
   creditCard({super.key });

  @override
  State<creditCard> createState() => _creditCardState();
}

class _creditCardState extends State<creditCard> {
    bool tick=false;
   TextEditingController holdername=TextEditingController();
   TextEditingController cardnumber=TextEditingController();
   TextEditingController validthru=TextEditingController();
   TextEditingController cvv=TextEditingController();

   Future<void> addCard() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setString("cardNo", cardnumber.text.trim());
   }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Colors.black,
       body:Padding(
         padding:  EdgeInsets.all(w*0.03),
         child: SingleChildScrollView(
           child: Column(
             children: [
               CreditCardWidget(
                  // backgroundImage: imagePicture.creditcard,
                 cardNumber:cardnumber.text,
                  expiryDate: validthru.text,
                 cardHolderName: holdername.text,
                 cvvCode: cvv.text,
                 showBackView: false,
                 // glassmorphismConfig: Glassmorphism.defaultConfig(),
                 onCreditCardWidgetChange: (CreditCardBrand ) {  },
                 isHolderNameVisible: true,
                 //true when you want to show cvv(back) view
               ),
               SizedBox(height: w*0.04,),
               TextFormField(
                 onChanged: (value) {
                   setState(() {

                   });
                 },
                 controller: holdername,
                 textInputAction: TextInputAction.done,
                 textCapitalization: TextCapitalization.words,
                 decoration: InputDecoration(
                     fillColor: Colors.grey,
                     filled: true,
                     labelText: "Cardholder name",
                     labelStyle: TextStyle(
                         fontSize: w*0.05
                     ),
                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(w*0.03))
                 ),
               ),
               SizedBox(height: w*0.07,),
               TextFormField(
                 onChanged: (value) {
                   setState(() {

                   });
                 },
                 maxLength: 16,
                 controller: cardnumber,
                 keyboardType: TextInputType.number,
                 textInputAction: TextInputAction.done,
                 obscureText: true,
                 obscuringCharacter: "*",
                 decoration: InputDecoration(
                   fillColor: Colors.grey,
                     filled: true,
                     labelText: "Card number",
                     labelStyle: TextStyle(
                         fontSize: w*0.05
                     ),
                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(w*0.03))
                 ),
               ),
               SizedBox(height: w*0.07,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: w*0.17,
                    width: w*0.4,
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {

                        });
                      },
                      controller: validthru,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      obscuringCharacter: "*",
                      decoration: InputDecoration(
                          fillColor: Colors.grey,
                          filled: true,
                          labelText: "Valid thru",
                          labelStyle: TextStyle(
                              fontSize: w*0.05
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(w*0.03))
                      ),
                    ),
                  ),
                  Container(
                    height: w*0.17,
                    width: w*0.4,
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {

                        });
                      },
                      controller: cvv,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      obscuringCharacter: "*",
                      decoration: InputDecoration(
                          fillColor: Colors.grey,
                          filled: true,
                          labelText: "CVV",
                          labelStyle: TextStyle(
                              fontSize: w*0.05
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(w*0.03))
                      ),
                    ),
                  ),
                ],
              ),
               Row(
                 children: [
                   Checkbox(
                     activeColor: Colors.indigo,
                     fillColor: MaterialStatePropertyAll(Colors.indigo),
                     value: tick,
                     onChanged: (value) {
                       setState(() {
                         tick =!tick;
                       });
                     },),
                   Text("Set as default servicing",
                     style: TextStyle(
                         fontSize: w*0.04,
                         color:Colors.grey,
                         fontWeight: FontWeight.w300
                     ),)
                 ],
               ),
               SizedBox(height: w*0.5 ,),
               InkWell(
                 onTap: () {
                   if(holdername.text.isNotEmpty&&cardnumber.text.isNotEmpty&&
                   validthru.text.isNotEmpty&&cvv.text.isNotEmpty){
                     addCard();
                     showModalBottomSheet(context: context,
                       backgroundColor: Colors.white,
                       shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.only(
                               topRight: Radius.circular(w*0.05),
                               topLeft: Radius.circular(w*0.05)
                           )
                       ),
                       builder: (context) {
                         return vehicleAddedBottomSheet();
                       },).then((value) =>  Navigator.pop(context));
                   }else{
                     holdername.text.isEmpty? ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("enter holder name"))):
                     cardnumber.text.isEmpty? ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("enter card number"))):
                     validthru.text.isEmpty? ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("enter validthru"))):
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("enter cvv")));
                   }
                 },
                 child: Container(
                   width: w*0.5,
                   height: w*0.14,
                   child: Center(child: Text("Confirm",
                     style: TextStyle(
                         fontSize: w*0.06,
                         color: Colors.white,
                         fontWeight: FontWeight.w600
                     ),)),
                   decoration: BoxDecoration(
                       color: Colors.indigo,
                       borderRadius: BorderRadius.circular(w*0.08)
                   ),
                 ),
               ),
             ],
           ),
         ),
       ) ,
      );



  }

}
class vehicleAddedBottomSheet extends StatefulWidget {
  const vehicleAddedBottomSheet({super.key});

  @override
  State<vehicleAddedBottomSheet> createState() => _vehicleAddedBottomSheetState();
}

class _vehicleAddedBottomSheetState extends State<vehicleAddedBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: w*1,
       width: w*1,
       child:  Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Text("Payment successefull",
             style: TextStyle(
                 fontWeight: FontWeight.w700,
                 color: Colors.indigo,
                 fontSize: w*0.09
             ),),
           Text("Booking ID- #24352",
             style: TextStyle(
                 fontWeight: FontWeight.w300,
                 color: Colors.indigo,
                 fontSize: w*0.05
             ),),
         ],
       ),
    );
  }
}

