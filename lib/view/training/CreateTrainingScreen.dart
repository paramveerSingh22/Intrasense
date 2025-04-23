import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/user_model.dart';
import '../../res/component/CheckboxWithLabel.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/common_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'package:file_picker/file_picker.dart';

class CreateTrainingScreen extends StatefulWidget{
  @override
  _CreateTrainingScreen createState() => _CreateTrainingScreen();

}

class _CreateTrainingScreen extends State<CreateTrainingScreen>{
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _instructorController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _meetingLinkController = TextEditingController();

  String? selectTimeZoneValue;
  List<String> timeZoneList = [];
  bool enableZoomMeeting = false;

  UserModel? _userData;
  bool _isLoading = false;

  String? selectedFilePath;
  String? selectedFileName;


  @override
  void initState() {
    super.initState();
    fetchTimeZoneList();
    getUserDetails(context);
  }

  void fetchTimeZoneList() async {
    final commonViewModel =
    Provider.of<CommonViewModel>(context, listen: false);
    await commonViewModel.timeZoneListApi(context);
    setState(() {
      timeZoneList = commonViewModel.timeZoneList;
    });
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    setState(() {});
    if (kDebugMode) {
      print(_userData);
    }
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedFilePath = result.files.single.path;
        setState(() {
          selectedFileName = result.files.single.name;
        });
      });
    } else {
      // User canceled the picker
    }
  }

  Future<String?> convertFileToBase64(String filePath) async {
    try {
      // Read the file as bytes
      File file = File(filePath);
      List<int> fileBytes = await file.readAsBytes();

      // Convert the bytes to Base64
      String base64String = base64Encode(fileBytes);
      return base64String;
    } catch (e) {
      print('Error converting file to Base64: $e');
      return null;
    }
  }

  Future<String?> encodeImageToBase64(String filePath) async {
    try {
      File file = File(filePath);
      List<int> bytes = await file.readAsBytes();
      String base64String = base64Encode(bytes);
      return base64String;
    } catch (e) {
      print('Error encoding image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
   // final expenseViewModel = Provider.of<ExpenseViewModel>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          ),
          Positioned(
            top: 90,
            left: 0,
            child: Stack(
              children: [
                Image.asset(
                  Images.curveOverlay,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
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
            top: 36,
            left: 30,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Create Training Session",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'PoppinsMedium',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 110,
            left: 0,
            right: 0,
            bottom: 60,
            // Adjust the bottom to leave space for the button
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: [
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Create Training Session",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.secondaryOrange,
                                  fontFamily: 'PoppinsMedium'),
                            )),
                        const SizedBox(height: 15),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Title',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium'),
                            )),
                        const SizedBox(height: 5),
                        CustomTextField(
                            controller: _titleController,
                            hintText: 'Title of the Expense'),
                        const SizedBox(height: 15),

                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Instructor',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium'),
                            )),
                        const SizedBox(height: 5),
                        CustomTextField(
                            controller: _instructorController,
                            hintText: 'Instructor',
                            keyboardType: TextInputType.number),

                        const SizedBox(height: 15),

                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Department',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium'),
                            )),
                        const SizedBox(height: 5),
                        CustomTextField(
                            controller: _departmentController,
                            hintText: 'Department',
                            keyboardType: TextInputType.number),
                        const SizedBox(height: 15),

                        Row(
                          children: [
                            Expanded(
                                flex: 10,
                                child: Container(
                                  child: const Text(
                                    'Date',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textColor,
                                      fontFamily: 'PoppinsRegular',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                )),
                            Expanded(flex: 1, child: Container()),
                            const Expanded(
                                flex: 10,
                                child: Text(
                                  'Time',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                    fontFamily: 'PoppinsRegular',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ))
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                                flex: 10,
                                child: CustomTextField(
                                  controller: _dateController,
                                  hintText: 'DD/MM/YYYY',
                                  suffixIcon: Image.asset(
                                    Images.calenderIcon,
                                    height: 20,
                                    width: 20,
                                  ),
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 365 * 100)),
                                    );

                                    if (pickedDate != null) {
                                      // Format date with leading zeros in month and day
                                      String formattedDate =
                                          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                      setState(() {
                                        _dateController.text = formattedDate;
                                      });
                                    }
                                  },
                                )),
                            Expanded(flex: 1, child: Container()),
                            Expanded(
                                flex: 10,
                                child: CustomTextField(
                                  controller: _timeController,
                                  hintText: 'Select start time',
                                  suffixIcon: Image.asset(
                                    Images.clockIcon,
                                    height: 24,
                                    width: 24,
                                  ),
                                  readOnly: true,
                                  onTap: () async {
                                    TimeOfDay? pickedTime = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );

                                    if (pickedTime != null) {
                                      // Format the time to display in HH:mm format
                                      final formattedTime = pickedTime.format(context);
                                      setState(() {
                                        _timeController.text = formattedTime;
                                      });
                                    }
                                  },
                                ))
                          ],
                        ),

                        const SizedBox(height: 15),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Time Zone',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium'),
                            )),
                        const SizedBox(height: 5),
                        CustomDropdown(
                          value: selectTimeZoneValue,
                          items: timeZoneList,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectTimeZoneValue = newValue;
                            });
                          },
                          hint: 'Select an option',
                        ),
                       // const SizedBox(height: 15),

                        CheckboxWithLabel(
                          label: 'Enable zoom meeting',
                          value: enableZoomMeeting,
                          onChanged: (bool? value) {
                            setState(() {
                              enableZoomMeeting = value ?? false;
                            });
                          },
                        ),
                       // const SizedBox(height: 15),
                        if (enableZoomMeeting) ...{
                          Column(
                            children: [
                              const Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Enter Meeting Link',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textColor,
                                        fontFamily: 'PoppinsMedium'),
                                  )),
                              const SizedBox(height: 5),
                              CustomTextField(
                                hintText: 'Enter Meeting Link',
                                controller: _meetingLinkController,
                              ),
                              const SizedBox(height: 15),
                            ],
                          )
                        },

                        const SizedBox(height: 15),
                        Column(
                          children: [
                            const Row(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Upload documents',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textColor,
                                      fontFamily: 'PoppinsMedium',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Container(
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
                                height: 100,
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
                                        onPressed: () {
                                          pickFile();
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
                                                    color: AppColors
                                                        .skyBlueTextColor,
                                                    fontFamily:
                                                    'PoppinsMedium'),
                                              ),
                                              Text(
                                                'Add upto 25 mb',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: AppColors.textColor,
                                                    fontFamily:
                                                    'PoppinsRegular',
                                                    fontStyle:
                                                    FontStyle.italic),
                                              )
                                            ],
                                          ))
                                    ]))),
                            const SizedBox(height: 5),
                            if (selectedFileName != null) ...[
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
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
                              )
                            ]
                          ],
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Place the button at the bottom of the screen
          Positioned(
            left: 0,
            right: 0,
            bottom: 0, // Position button at the bottom of the screen
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: CustomElevatedButton(
                onPressed: () async {
                  if (_titleController.text.isEmpty) {
                    Utils.toastMessage("Please enter title");
                  }  else if (_instructorController.text.isEmpty) {
                    Utils.toastMessage("Please enter instructor");
                  }
                  else if (_departmentController.text.isEmpty) {
                    Utils.toastMessage("Please enter department");
                  }
                  else if (_dateController.text.isEmpty) {
                    Utils.toastMessage("Please select date");
                  }
                  else if (_timeController.text.isEmpty) {
                    Utils.toastMessage("Please select time");
                  }

                  else if (enableZoomMeeting==true && _meetingLinkController.text.isEmpty) {
                    Utils.toastMessage("Please enter meeting link");
                  }  else {
                   /* String? base64String =
                    await encodeImageToBase64(selectedFilePath!);

                    Map data = {
                      'user_id': _userData?.data?.userId.toString(),
                      'usr_role_track_id':
                      _userData?.data?.roleTrackId.toString(),
                      'expense_title': _titleController.text.toString(),
                      'expense_category': selectCategoryValue,
                      'expense_description': _desController.text.toString(),
                      'expense_forDate': _dateController.text.toString(),
                      'amount': _amountController.text.toString(),
                      if (selectedFilePath == "update") ...{
                        'expense_receipt': widget.expenseDetail.expenseReceipt,
                      } else ...{
                        'expense_receipt': base64String,
                      },
                      if (widget.expenseDetail != null) ...{
                        'expense_id': widget.expenseDetail.expenseId.toString(),
                      },
                      'token': _userData?.token.toString(),
                    };
                    expenseViewModel.addExpenseApi(data, context);*/
                  }
                },
                buttonText: 'CREATE',
                //loading: expenseViewModel.loading,
              ),
            ),
          ),
        ],
      ),
    );
  }

}