import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/model/client_list_model.dart';
import '../../model/country_list_model.dart';
import '../../model/industry_list_model.dart';
import '../../model/user_model.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/client_view_model.dart';
import '../../view_models/common_view_model.dart';
import 'package:provider/provider.dart';

import '../../view_models/user_view_model.dart';

class Editclients extends StatefulWidget{
  final ClientListModel client;

  const Editclients({
    Key? key,
    required this.client,
  }): super(key: key);
  @override
 _Editclients createState()=> _Editclients();
}
class _Editclients extends State<Editclients>{
  UserModel? _userData;

  String? selectCountryValue;
  List<CountryListModel> countryList = [];
  List<String> countryNamesList = [];

  String? selectedIndustryId;
  String? selectIndustryValue;
  List<IndustryListModel> industryList = [];
  List<String> industryNamesList = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.client.cmpName.toString();
    _emailController.text = widget.client.cmpEmailid.toString();
    _contactController.text = widget.client.cmpContact.toString();
    _address1Controller.text = widget.client.cmpAddress1.toString();
    _address2Controller.text = widget.client.cmpAddress2.toString();
    _stateController.text = widget.client.cmpState.toString();
    _cityController.text = widget.client.cmpCity.toString();
    _pincodeController.text = widget.client.cmpPincode.toString();
    getUserDetails(context);
    fetchCountries();
    fetchIndustries();
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();
  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    if (kDebugMode) {
      print(_userData);
    }
  }

  void fetchCountries() async {
    final commonViewModel = Provider.of<CommonViewModel>(context, listen: false);
    await commonViewModel.countryListApi(context);
    setState(() {
      countryList = commonViewModel.countryList;
      countryNamesList= countryList.map((country) => country.countryName).toList();
      if(countryNamesList.contains(widget.client.cmpCountry)){
        selectCountryValue= widget.client.cmpCountry;
      }
    });
  }

  void fetchIndustries() async {
    final commonViewModel = Provider.of<CommonViewModel>(context, listen: false);
    await commonViewModel.industryListApi(context);
    setState(() {
      industryList = commonViewModel.industryList;
      industryNamesList= industryList.map((industry) => industry.type.toString()).toList();
      if(industryNamesList.contains(widget.client.industryName)){
        selectIndustryValue= widget.client.industryName;
      }
      selectedIndustryId = industryList
          .firstWhere((industry) => industry.type == widget.client.industryName)
          .id;
    });
  }

  @override
  Widget build(BuildContext context) {
    final clientViewModel = Provider.of<ClientViewModel>(context);
   return  Scaffold(
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
                       'Edit client',
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
                   'Edit Client',
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
                   CustomTextField(
                     controller: _nameController,
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
                   CustomTextField(
                     controller: _emailController,
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
                   CustomTextField(
                     controller: _contactController,
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
                   const SizedBox(height: 5),
                   CustomDropdown(
                     value: selectIndustryValue,
                     items: industryNamesList,
                     onChanged: (String? newValue) {
                       setState(() {
                         selectIndustryValue = newValue;
                         selectedIndustryId = industryList
                             .firstWhere((industry) => industry.type == newValue)
                             .id;
                       });
                     },
                     hint: 'Industry',
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
                   CustomTextField(
                     controller: _address1Controller,
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
                   CustomTextField(
                     controller: _address2Controller,
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
                     items: countryNamesList,
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
                   CustomTextField(
                     controller: _stateController,
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
                   CustomTextField(
                     controller: _cityController,
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
                   CustomTextField(
                     controller: _pincodeController,
                     hintText: 'Pincode',
                   ),
                   const SizedBox(height: 15),

                   Row(
                     children: [
                       Expanded(
                           flex: 10,
                           child: CustomElevatedButton(
                             onPressed: () {
                               Navigator.of(context).pop();
                             },
                             buttonText: 'cancel',
                           )),
                       Expanded(
                           flex: 1,
                           child: Container()),
                       Expanded(
                           flex: 10,
                           child:  CustomElevatedButton(
                             onPressed: () {
                               if (_nameController.text.isEmpty) {
                                 Utils.toastMessage('Please enter name');
                               }
                               else  if (_emailController.text.isEmpty) {
                                 Utils.toastMessage('Please enter email');
                               }
                               else  if (_contactController.text.isEmpty) {
                                 Utils.toastMessage('Please enter contact');
                               }
                               else  if (selectedIndustryId!.isEmpty) {
                                 Utils.toastMessage('Please enter industry');
                               }
                               else  if (_address1Controller.text.isEmpty) {
                                 Utils.toastMessage('Please enter address1');
                               }
                               else  if (_address2Controller.text.isEmpty) {
                                 Utils.toastMessage('Please enter address2');
                               }
                               else  if (_stateController.text.isEmpty) {
                                 Utils.toastMessage('Please enter state');
                               }
                               else  if (_cityController.text.isEmpty) {
                                 Utils.toastMessage('Please enter city');
                               }
                               else  if (_pincodeController.text.isEmpty) {
                                 Utils.toastMessage('Please enter pincode');
                               }
                               else{
                                 Map data = {
                                   'user_id' : _userData?.data?.userId.toString(),
                                   'usr_role_track_id' : _userData?.data?.roleTrackId.toString(),
                                   'customer_id' : _userData?.data?.customerTrackId,
                                   'cmp_name' : _nameController.text.toString(),
                                   'cmp_emailid' : _emailController.text.toString(),
                                   'cmp_contact' : _contactController.text.toString(),
                                   'cmp_industry' : selectedIndustryId,
                                   'cmp_address1' : _address1Controller.text.toString(),
                                   'cmp_address2' : _address2Controller.text.toString(),
                                   'cmp_country' : selectCountryValue,
                                   'cmp_state' : _stateController.text.toString(),
                                   'cmp_city' : _cityController.text.toString(),
                                   'cmp_pincode' : _pincodeController.text.toString(),
                                   'company_id' : widget.client.companyId,
                                   'token' : _userData?.token.toString(),
                                 };
                                 clientViewModel.addClientsApi(data,context);
                               }
                             },
                             buttonText: 'Update Client',
                             loading: clientViewModel.loading,
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