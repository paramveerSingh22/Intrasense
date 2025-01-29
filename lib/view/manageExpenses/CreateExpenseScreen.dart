import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intrasense/view_models/expense_view_model.dart';
import '../../model/user_model.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CreateExpenseScreen extends StatefulWidget {
  final dynamic expenseDetail;

  const CreateExpenseScreen({Key? key, this.expenseDetail}) : super(key: key);

  @override
  _CreateExpenseScreen createState() => _CreateExpenseScreen();
}

class _CreateExpenseScreen extends State<CreateExpenseScreen> {
  bool isUpdate = false;
  UserModel? _userData;
  bool _isLoading = false;

  String? selectedFilePath;
  String? selectedFileName;

  String? selectCategoryValue;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _desController = TextEditingController();

  @override
  void initState() {
    getUserDetails(context);
    if (widget.expenseDetail != null) {
      isUpdate = true;
      _titleController.text = widget.expenseDetail.expenseTitle.toString();
      _amountController.text = widget.expenseDetail.amount.toString();

      if (widget.expenseDetail.expenseForDate != null) {
        _dateController.text = DateFormat('yyyy-MM-dd')
            .format(widget.expenseDetail.expenseForDate);
      }

      _desController.text = widget.expenseDetail.expenseDescription;
      selectCategoryValue = widget.expenseDetail.expenseCategory;
      selectedFilePath = "update";
    }
    super.initState();
  }

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    if (kDebugMode) {
      print(_userData);
    }
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

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
    final expenseViewModel = Provider.of<ExpenseViewModel>(context);
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
                Text(
                  isUpdate ? 'Update Expense' : 'Add Expense',
                  style: const TextStyle(
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
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              isUpdate ? 'Update Expense' : 'Add Expense',
                              style: const TextStyle(
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
                              'Category',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium'),
                            )),
                        const SizedBox(height: 5),
                        CustomDropdown(
                          value: selectCategoryValue,
                          items: const [
                            "Business travel",
                            "Healthcare",
                            "Business supplies",
                            "Business tools",
                            "Miscellaneous business-related expenses",
                            "Other expenses"
                          ],
                          onChanged: (String? newValue) {
                            setState(() {
                              selectCategoryValue = newValue;
                            });
                          },
                          hint: 'Select Category',
                        ),
                        const SizedBox(height: 15),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Amount',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium'),
                            )),
                        const SizedBox(height: 5),
                        CustomTextField(
                            controller: _amountController,
                            hintText: 'Enter Expense Amount',
                            keyboardType: TextInputType.number),

                        const SizedBox(height: 15),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Date',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium'),
                            )),
                        const SizedBox(height: 5),
                        CustomTextField(
                            controller: _dateController,
                            hintText: 'DD/MM/YYYY',
                            suffixIcon: Image.asset(
                              Images.calenderIcon,
                              height: 24,
                              width: 24,
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? startDate =
                                  _dateController.text.isNotEmpty
                                      ? DateTime.parse(_dateController.text)
                                      : DateTime.now();
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: startDate,
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (pickedDate != null) {
                                String formattedDate =
                                    "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                                setState(() {
                                  _dateController.text = formattedDate;
                                });
                              }
                            }),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            children: [
                              const Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Description',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textColor,
                                        fontFamily: 'PoppinsMedium'),
                                  )),
                              const SizedBox(height: 5),
                              CustomTextField(
                                  controller: _desController,
                                  hintText: 'Enter description...',
                                  minLines: 4,
                                  maxLines: 4),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Column(
                          children: [
                            Row(
                              children: [
                                const Align(
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
                                const Spacer(),
                                if (widget.expenseDetail != null) ...[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: SizedBox(
                                          height: 20.0,
                                          width: 20.0,
                                          child: Image.asset(Images.eyeIcon),
                                        ),
                                        onPressed: () async {
                                          showDocumentDialog(context);
                                        },
                                      ),
                                    ],
                                  )
                                ],
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
                  } else if (selectCategoryValue == null) {
                    Utils.toastMessage("Please select category");
                  } else if (_amountController.text.isEmpty) {
                    Utils.toastMessage("Please enter amount");
                  }
                  else if(double.parse(_amountController.text) <= 0){
                    Utils.toastMessage("Amount must be greater than 0");
                  }
                  else if (_dateController.text.isEmpty) {
                    Utils.toastMessage("Please select date");
                  } else if (_desController.text.isEmpty) {
                    Utils.toastMessage("Please enter description");
                  } else if (_desController.text.characters.length < 20) {
                    Utils.toastMessage(
                        "Please enter description min 20 characters");
                  } else if (selectedFilePath == null) {
                    Utils.toastMessage("Please upload document");
                  } else {
                    String? base64String =
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
                    expenseViewModel.addExpenseApi(data, context);
                  }
                },
                buttonText: 'SUBMIT',
                loading: expenseViewModel.loading,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showDocumentDialog(BuildContext context) {
    final url = "https://intrasense.co.uk/app/" +
        widget.expenseDetail.expenseReceipt.replaceAll(r'\', '');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Attachment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                url,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => const Text(
                  'Failed to load document.',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
