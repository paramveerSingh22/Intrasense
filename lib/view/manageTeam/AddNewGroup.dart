import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../res/component/CheckboxWithLabel.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';

class AddNewGroup extends StatefulWidget{
 _AddNewGroup createState() => _AddNewGroup();

}

class _AddNewGroup extends State<AddNewGroup>{
  String? selectGroupValue;
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Stack(
       children: <Widget>[
         Container(
           width: double.infinity,
           height: MediaQuery.of(context).size.height,
           decoration: BoxDecoration(
             image: DecorationImage(
               image: AssetImage(Images.headerBg),
               fit: BoxFit.cover,
             ),
           ),
           child: GestureDetector(
             onTap: () {
               Navigator.of(context).pop(); // Example navigation back
             },
             child: const Padding(
               padding: EdgeInsets.only(top: 50, left: 30),
               child: Align(
                 alignment: Alignment.topLeft,
                 // Top left alignment set karne ke liye
                 child: Row(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Icon(
                       Icons.arrow_back, // Back icon ka code
                       color: Colors.white,
                     ),
                     SizedBox(width: 8),
                     // Icon aur text ke beech thoda space dene ke liye
                     Text(
                       'Create Group',
                       style: TextStyle(
                         fontSize: 16,
                         color: Colors.white,
                         fontFamily: 'PoppinsRegular',
                       ),
                     ),
                   ],
                 ),
               ),
             ),
           ),
         ),
         Positioned(
           top: 90,
           left: 0,
           child: Stack(
             children: [
               Image.asset(
                 Images.curveOverlay,
                 width: MediaQuery.of(context).size.width,
               ),
               const Positioned(
                 top: 20, // Adjust the position of the text as needed
                 left: 30, // Adjust the position of the text as needed
                 child: Text(
                   'Create Group',
                   style: TextStyle(
                       fontSize: 14,
                       color: AppColors.secondaryOrange,
                       fontFamily: 'PoppinsMedium'),
                 ),
               ),
             ],
           ),
         ),
         Positioned(
           top: 140,
           left: 0,
           right: 0,
           bottom: 0,
           child: Image.asset(
             Images.curveBg,
             fit: BoxFit.cover,
           ),
         ),
         // Scrollable content wrapped with Expanded widget
          Positioned(
           top: 140,
           left: 20,
           right: 20,
           bottom: 70, // Make space for the button at the bottom
           child: SingleChildScrollView(
             child: Column(
               children: [
                 const Align(
                     alignment: Alignment.topLeft,
                     child: Text(
                       'Group Name',
                       style: TextStyle(
                           fontSize: 14,
                           color: AppColors.textColor,
                           fontFamily: 'PoppinsMedium'),
                     )),
                 const CustomTextField(
                   hintText: 'Group Name',
                 ),
                 const SizedBox(height: 15),
                 const Align(
                     alignment: Alignment.topLeft,
                     child: Text(
                       'Description',
                       style: TextStyle(
                           fontSize: 14,
                           color: AppColors.textColor,
                           fontFamily: 'PoppinsMedium'),
                     )),
                 const CustomTextField(
                   hintText: 'Description',
                 ),
                 const SizedBox(height: 15),

                 const Align(
                   alignment: Alignment.topLeft,
                     child:  Text(
                       'Add User(s) to group',
                       style: TextStyle(
                           fontSize: 14,
                           color: AppColors.secondaryOrange,
                           fontFamily: 'PoppinsMedium'),
                     )
                 ),

                 CheckboxWithLabel(
                   label: 'Select Group',
                   onChanged: (bool? value) {
                     setState(() {
                       // Handle checkbox change
                     });
                   },
                 ),
                 CheckboxWithLabel(
                   label: 'Select Individuals',
                   onChanged: (bool? value) {
                     setState(() {
                       // Handle checkbox change
                     });
                   },
                 ),
                 CheckboxWithLabel(
                   label: 'Select Client',
                   onChanged: (bool? value) {
                     setState(() {
                       // Handle checkbox change
                     });
                   },
                 ),
                 const SizedBox(height: 15),

                 CustomDropdown(
                   value: selectGroupValue,
                   items: ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
                   onChanged: (String? newValue) {
                     setState(() {
                       selectGroupValue = newValue;
                     });
                   },
                   hint: 'Select Group',
                 )

               ],
             ),
           ),
         ),
         Positioned(
           bottom: 15, // Space from the bottom of the screen
           left: 20,
           right: 20,
           child: CustomElevatedButton(
             onPressed: () {
             },
             buttonText: 'Create New Group',
           ),
         ),
       ],
     ),
   );
  }
}