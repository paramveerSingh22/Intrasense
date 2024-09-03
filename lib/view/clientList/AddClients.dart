import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';

class AddClients extends StatefulWidget {
  @override
  _AddClients createState() => _AddClients();
}

class _AddClients extends State<AddClients> {
  String? selectCountryValue;
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
                        'Add client',
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
                    'Add Client',
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
          Positioned(
            top: 140,
            left: 20,
            right: 20,
            bottom: 0,
            child: SingleChildScrollView(
                child: Column(
              children: [
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Client Name',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
                const CustomTextField(
                  hintText: 'Client Name',
                ),
                const SizedBox(height: 15),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Email',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
                const CustomTextField(
                  hintText: 'Email',
                ),
                const SizedBox(height: 15),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Contact',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
                const CustomTextField(
                  hintText: 'Contact',
                ),
                const SizedBox(height: 15),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Industry',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
                const CustomTextField(
                  hintText: 'Industry',
                ),
                const SizedBox(height: 15),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Address1',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
                const CustomTextField(
                  hintText: 'Address1',
                ),
                const SizedBox(height: 15),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Address2',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
                const CustomTextField(
                  hintText: 'Address2',
                ),
                const SizedBox(height: 15),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Country',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
                const SizedBox(height: 5),
                CustomDropdown(
                  value: selectCountryValue,
                  items: ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
                  onChanged: (String? newValue) {
                    setState(() {
                      selectCountryValue = newValue;
                    });
                  },
                  hint: 'Country',
                ),
                const SizedBox(height: 15),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'State',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
                const CustomTextField(
                  hintText: 'State',
                ),
                const SizedBox(height: 15),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'City',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
                const CustomTextField(
                  hintText: 'City',
                ),
                const SizedBox(height: 15),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Pincode',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
                const CustomTextField(
                  hintText: 'Pincode',
                ),
                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                        flex: 10,
                        child: CustomElevatedButton(
                          onPressed: () {},
                          buttonText: 'cancel',
                        )),
                    Expanded(
                        flex: 1,
                        child: Container()),
                    Expanded(
                        flex: 10,
                        child:  CustomElevatedButton(
                          onPressed: () {},
                          buttonText: 'Save Client',
                        ))
                  ],
                )
              ],
            )),
          )
        ],
      ),
    );
  }
}
