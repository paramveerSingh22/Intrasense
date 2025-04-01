import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../model/user_model.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomRadioGroup.dart';
import '../../utils/AppColors.dart';
import '../../utils/Utils.dart';
import '../../view_models/common_view_model.dart';
import 'package:provider/provider.dart';

import '../../view_models/user_view_model.dart';

class PreferencesScreen extends StatefulWidget{
  @override
  _PreferencesScreen createState() => _PreferencesScreen();
}

class _PreferencesScreen extends State<PreferencesScreen>{
  UserModel? _userData;
  bool _isLoading = false;
  String? preferencesValue;
  List<String> prefsList =  ['Receive all notifications', 'Receive high priority notifications only', 'Disable all notifications', 'General updates, announcements, events', 'Send me notification on project activities'];

  Map<String, int> preferencesMap = {
    'Receive all notifications': 1,
    'Receive high priority notifications only': 2,
    'Disable all notifications': 3,
    'General updates, announcements, events': 4,
    'Send me notification on project activities': 5,
  };

  @override
  void initState() {
    super.initState();
    getUserDetails(context);
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    if (kDebugMode) {
      print(_userData);
    }
    getPreferencesApi();

  }

  Future<void> getPreferencesApi() async {
    //Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'token': _userData?.token,
      };
      final commonViewModel = Provider.of<CommonViewModel>(context, listen: false);
      final response = await commonViewModel.getPreferencesApi(data, context);
      setState(() {
        if (response != null) {
         var result= response[0];
         var selectedPref= result.notificationPreferenceId;

         if(selectedPref=="1"){
           preferencesValue=prefsList[0];
         }

        else if(selectedPref=="2"){
           preferencesValue=prefsList[2];
         }

        else if(selectedPref=="3"){
           preferencesValue=prefsList[2];
         }
         else  if(selectedPref=="4"){
           preferencesValue=prefsList[3];
         }
         else  if(selectedPref=="5"){
           preferencesValue=prefsList[2];
         }

        }
      });
    } catch (error) {
      print('Error fetching employee list: $error');
    } finally {
      //Utils.hideLoadingDialog(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    final commonViewModel = Provider.of<CommonViewModel>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child:SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Would you like to receive notifications?',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
                const SizedBox(height: 10),

                CustomRadioGroup(
                  options: prefsList,
                  groupValue: preferencesValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      preferencesValue = newValue;
                    });
                  },
                ),
                const SizedBox(height: 10),
                CustomElevatedButton(
                  onPressed: () async{
                    int selectedPreference = preferencesMap[preferencesValue]!;

                    Map data = {
                      'user_id': _userData?.data?.userId.toString(),
                      'notification_preference': selectedPreference.toString(),
                      'token': _userData?.token.toString(),
                    };
                    await commonViewModel.updatePreferencesApi(data, context);
                  },
                  buttonText:  'UPDATE',
                  loading: commonViewModel.loading,
                ),
              ],
            )
        ),
      ),
    );
  }

}