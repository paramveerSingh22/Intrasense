import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../model/client_list_model.dart';
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
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class Addsubsidiary extends StatefulWidget{

  final dynamic clientDetail;

  Addsubsidiary({
    Key? key,
    this.clientDetail,
  }) : super(key: key);

  @override
  _AddSubsidiary createState() => _AddSubsidiary();
}

class _AddSubsidiary extends State<Addsubsidiary>{
  UserModel? _userData;

  String? selectCountryValue;
  List<CountryListModel> countryList = [];
  List<String> countryNamesList = [];

  String? selectedIndustryId;
  String? selectIndustryValue;
  List<IndustryListModel> industryList = [];
  List<String> industryNamesList = [];

  TextEditingController _clientNameController = TextEditingController();
  TextEditingController _subClientNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _address1Controller = TextEditingController();
  TextEditingController _address2Controller = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserDetails(context);
    _clientNameController.text= widget.clientDetail.cmpName;
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();
  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    fetchCountries();
    fetchIndustries();
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
    });
  }

  void fetchIndustries() async {
    final commonViewModel = Provider.of<CommonViewModel>(context, listen: false);
    await commonViewModel.industryListApi(context);
    setState(() {
      industryList = commonViewModel.industryList;
      industryNamesList= industryList.map((industry) => industry.type.toString()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final clientViewModel = Provider.of<ClientViewModel>(context);
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
                        'Add Subsidiary',
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
                    'Add Subsidiary',
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
                        controller: _clientNameController,
                        hintText: 'Client Name',
                        readOnly: true),
                    const SizedBox(height: 15),

                    const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Sub Client Name',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsMedium'),
                        )),
                     CustomTextField(
                      controller: _subClientNameController,
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
                      items: countryNamesList ,
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
                                if(_subClientNameController.text.isEmpty){
                                  Utils.toastMessage('Please enter sub client name');
                                }
                                else if(_emailController.text.isEmpty){
                                  Utils.toastMessage('Please enter email');
                                }
                                else if(_contactController.text.isEmpty){
                                  Utils.toastMessage('Please enter contact');
                                }
                                else if(selectedIndustryId==null){
                                  Utils.toastMessage('Please select industry');
                                }
                                else if(_address1Controller.text.isEmpty){
                                  Utils.toastMessage('Please enter address1');
                                }
                                else if(_address2Controller.text.isEmpty){
                                  Utils.toastMessage('Please enter address2');
                                }
                                else if(selectCountryValue==null){
                                  Utils.toastMessage('Please select country');
                                }
                                else if(_cityController.text.isEmpty){
                                  Utils.toastMessage('Please enter city');
                                }
                                else if(_pincodeController.text.isEmpty){
                                  Utils.toastMessage('Please enter pin code');
                                }
                                else{
                                  Map data = {
                                    'user_id': _userData?.data?.userId.toString(),
                                    'usr_role_track_id': _userData?.data?.roleTrackId.toString(),
                                    'company_id': widget.clientDetail.companyId,
                                    'subCompany_name': _subClientNameController.text.toString(),
                                    'billing_address1': _address1Controller.text.toString(),
                                    'billing_address2': _address2Controller.text.toString(),
                                    'country': selectCountryValue,
                                    'state': _stateController.text.toString(),
                                    'city': _cityController.text.toString(),
                                    'postal_code': _pincodeController.text.toString(),
                                    'industry_type': selectedIndustryId,
                                    'email': _emailController.text.toString(),
                                    'contact_no': _contactController.text.toString(),
                                    'token': _userData?.token.toString(),
                                  };
                                  clientViewModel.addSubClientApi(data, context);
                                }
                              },
                              buttonText: 'Save Subsidiary',
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