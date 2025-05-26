import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../model/user_model.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../utils/AppColors.dart';
import '../../utils/Constants.dart';
import '../../utils/Images.dart';
import 'package:file_picker/file_picker.dart';

import '../../utils/Utils.dart';
import '../../view_models/documents_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class UploadFileScreen {
  static String? selectedFilePath;
  static String? selectedFileName;

  static UserModel? _userData;

  static Future<UserModel> getUserData() => UserViewModel().getUser();

  static Future<void> show(BuildContext context) async {
    _userData = await getUserData();
    if (kDebugMode) {
      print(_userData);
    }

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      builder: (BuildContext context) {
        bool isDetailSelected = true;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return FractionallySizedBox(
              /*heightFactor: 0.8,*/
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      color: AppColors.secondaryOrange.withOpacity(0.1),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Upload File',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.secondaryOrange,
                              fontFamily: 'PoppinsMedium',
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close,
                                color: AppColors.textColor),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 10.0),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                            color: AppColors.lightBlue,
                            border: Border.all(
                              color: AppColors.lightBlue,
                              width: 1.0,
                            ),
                          ),
                          height: 80,
                          child: Align(
                              alignment: Alignment.topCenter,
                              child: Row(children: [
                                const SizedBox(width: 10),
                                IconButton(
                                  icon: Image.asset(
                                    Images.uploadIcon,
                                    height: 50,
                                    width: 50,
                                  ),
                                  onPressed: () async {
                                    await pickFile();
                                    setState(() {});
                                  },
                                ),
                                const SizedBox(width: 10),
                                const Align(
                                    alignment: Alignment.topCenter,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'UPLOAD FILE',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: AppColors.skyBlueTextColor,
                                              fontFamily: 'PoppinsMedium'),
                                        ),
                                        Text(
                                          'Add upto 25 mb',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: AppColors.textColor,
                                              fontFamily: 'PoppinsRegular',
                                              fontStyle: FontStyle.italic),
                                        )
                                      ],
                                    ))
                              ]))),
                    ),

                    const SizedBox(height: 10),

                    if (selectedFileName != null) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 23.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedFileName.toString(),
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.hintColor,
                                fontFamily: 'PoppinsRegular',
                              ),
                            ),
                            IconButton(
                              icon: Image.asset(
                                Images.orangeRoundCrossIcon,
                                height: 30,
                                width: 30,
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedFileName = null;
                                  selectedFilePath = null;
                                });
                              },
                            ),
                          ],
                        ),
                      )
                    ],

                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: CustomElevatedButton(
                        onPressed: () async {
                          uploadFileApi(context);
                        },
                        buttonText: 'UPLOAD FILE',
                        //loading: expenseViewModel.loading,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      selectedFilePath = result.files.single.path;
      selectedFileName = result.files.single.name;
    } else {
      // User canceled the picker
    }
  }

  static void uploadFileApi(BuildContext context) async {
    if (selectedFilePath == null) {
      Utils.toastMessage("Please upload document");
    } else {
      Navigator.pop(context);
      Utils.showLoadingDialog(context);
      final documentViewModel = Provider.of<DocumentsViewModel>(context, listen: false);
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'customer_id': _userData?.data?.customerTrackId,
        // 'file': _titleController.text.toString(),
        'deviceType': Constants.deviceType,
        'deviceToken': Constants.deviceToken,
        'token': _userData?.token,
      };
      await documentViewModel.uploadFileApi(data, context, selectedFilePath);
      Utils.hideLoadingDialog(context);
    }
  }
}
