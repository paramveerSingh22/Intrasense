import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/model/projects/ProjectManagersModel.dart';
import 'package:intrasense/model/projects/ProjectTypesModel.dart';
import 'package:intrasense/res/component/ButtonOrangeBorder.dart';
import 'package:intrasense/view_models/projects_view_model.dart';
import '../../model/client_list_model.dart';
import '../../model/client_subs_diary_model.dart';
import '../../model/user_model.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/client_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class AddProjectScreen extends StatefulWidget {
  _AddProjectScreen createState() => _AddProjectScreen();
}

class _AddProjectScreen extends State<AddProjectScreen> {
  String? selectClientValue;
  String? selectClientId;
  List<ClientListModel> clientList = [];
  List<String> clientNamesList = [];

  String? selectSubClientValue;
  String? selectSubClientId;
  List<ClientSubsDiaryModel> subsDiaryList = [];
  List<String> subClientNamesList = [];

  String? selectProjectManagerValue;
  String? selectProjectManagerId;
  List<ProjectManagersModel> projectManagerList = [];
  List<String> projectManagerNamesList = [];

  String? selectProjectTypeValue;
  List<ProjectTypesModel> projectTypesList = [];
  List<String> projectTypesNamesList = [];

  bool _isLoading = false;
  UserModel? _userData;

  TextEditingController titleController = TextEditingController();
  TextEditingController shortNameController = TextEditingController();
  TextEditingController poNumberController = TextEditingController();
  TextEditingController clientContactController = TextEditingController();

  //TextEditingController hoursController = TextEditingController();
  //TextEditingController amountController = TextEditingController();
  TextEditingController quotationController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();

  List<TextEditingController> hoursControllers = [];
  List<TextEditingController> amountControllers = [];

  List<Map<String, String>> projectDetailsList = [
    {'projectType': '', 'projectTypeId': '', 'hours': '', 'amount': ''},
  ];

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  void initState() {
    super.initState();

    while (hoursControllers.length < projectDetailsList.length) {
      hoursControllers.add(TextEditingController(text: projectDetailsList[hoursControllers.length]['hours'] ?? ''));
    }

    while (amountControllers.length < projectDetailsList.length) {
      amountControllers.add(TextEditingController(text: projectDetailsList[amountControllers.length]['amount'] ?? ''));
    }
    updateTotalAmount();
    getUserDetails(context);
  }

  @override
  void dispose() {
    for (var controller in hoursControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    getClientList();
    getProjectManagersList();
    getProjectTypesList();
  }

  void getClientList() async {
    setLoading(true);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'customer_id': _userData?.data?.customerTrackId,
        'token': _userData?.token,
      };
      final clientViewModel =
          Provider.of<ClientViewModel>(context, listen: false);
      final response = await clientViewModel.getClientListApi(data, context);
      setState(() {
        if (response != null) {
          clientList = response.toList();
          clientNamesList = clientList.map((item) => item.cmpName).toList();
        }
      });
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load client list')),
      );
    } finally {
      setLoading(false);
    }
  }

  void getSubClientsList() async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'company_id': selectClientId,
        'token': _userData?.token,
      };
      final clientViewModel =
          Provider.of<ClientViewModel>(context, listen: false);
      final response = await clientViewModel.getSubClientListApi(data, context);
      setState(() {
        if (response != null) {
          subsDiaryList = response.toList();
          subClientNamesList =
              subsDiaryList.map((item) => item.entityName.toString()).toList();
        }
      });
      // setLoading(false);
      Utils.hideLoadingDialog(context);
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load contact list')),
      );
      // setLoading(false);
      Utils.hideLoadingDialog(context);
    }
  }

  void getProjectManagersList() async {
    setLoading(true);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'customer_id': _userData?.data?.customerTrackId,
        'token': _userData?.token,
      };
      final projectViewModel =
          Provider.of<ProjectsViewModel>(context, listen: false);
      final response =
          await projectViewModel.getProjectManagersApi(data, context);

      if (response != null) {
        setState(() {
          projectManagerList = response.toList();
          projectManagerNamesList = projectManagerList
              .map((item) =>
                  "${item.projectManagerFirstName} ${item.projectManagerLastName}")
              .toList();
        });
      }
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load client list')),
      );
    } finally {
      setLoading(false);
    }
  }

  void getProjectTypesList() async {
    setLoading(true);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_customer_track_id': _userData?.data?.customerTrackId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'token': _userData?.token,
      };
      final projectViewModel =
          Provider.of<ProjectsViewModel>(context, listen: false);
      final response = await projectViewModel.getProjectTypesApi(data, context);

      if (response != null) {
        setState(() {
          projectTypesList = response;
          for (var item in projectTypesList) {
            projectTypesNamesList.add('**${item.moduleCatTitle}**');
            for (var itemCategory in item.categoryType) {
              projectTypesNamesList.add(itemCategory.moduleCatTitle);
            }
          }
        });
      }
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load client list')),
      );
    } finally {
      setLoading(false);
    }
  }

  void addNewItem() {
    setState(() {
      projectDetailsList.add(
          {'projectType': '', 'projectTypeId': '', 'hours': '', 'amount': ''});

      hoursControllers.add(TextEditingController(text: ''));
      amountControllers.add(TextEditingController(text: ''));
    });
  }

  Widget buildProjectDetailItem(int index) {
    return Container(
      padding: const EdgeInsets.all(0.0),
      // Padding for the content inside the container
      decoration: BoxDecoration(
        color: AppColors.lightOrange, // Set your desired background color here
        borderRadius: BorderRadius.circular(0.0), // Optional: Rounded corners
      ),
      child: Column(
        children: [
          if (index == 0) const SizedBox(height: 10),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Project Type',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
              ),
              if (index != 0) Spacer(),
              if (index != 0)
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.textColor,
                      ),
                      onPressed: () {
                        setState(() {
                          projectDetailsList.removeAt(index);
                          hoursControllers.removeAt(index);
                          amountControllers.removeAt(index);
                        });

                      },
                    )
                  ],
                ),
            ],
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomDropdown(
              value:
                  projectDetailsList[index]['projectType']?.isNotEmpty == true
                      ? projectDetailsList[index]['projectType']
                      : null,
              items: projectTypesNamesList,
              onChanged: (String? newValue) {
                setState(() {
                  projectDetailsList[index]['projectType'] = newValue ?? '';
                  projectDetailsList[index]['projectTypeId'] = projectTypesList
                      .firstWhere(
                          (item) => item.categoryType.any((category) => category.moduleCatTitle == newValue)
                  ).categoryType.firstWhere((category) => category.moduleCatTitle == newValue).moduleCategoryId;
                });
              },
              hint: 'Project type',
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                    flex: 10,
                    child: Container(
                      child: const Text(
                        'Hours',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      ),
                    )),
                Expanded(flex: 1, child: Container()),
                const Expanded(
                    flex: 10,
                    child: Text(
                      'Amount',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    ))
              ],
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                    flex: 10,
                    child: Container(
                      child: CustomTextField(
                          controller: hoursControllers[index],
                          hintText: 'Hours',
                          onChanged: (String newValue) {
                            setState(() {
                              projectDetailsList[index]['hours'] =
                                  newValue; // Update the value in the list
                            });
                          }),
                    )),
                Expanded(flex: 1, child: Container()),
                Expanded(
                    flex: 10,
                    child: Container(
                      child: CustomTextField(
                        controller: amountControllers[index],
                        hintText: 'Amount',
                          onChanged: (String newValue) {
                            setState(() {
                              projectDetailsList[index]['amount'] = newValue;
                              updateTotalAmount();
                            });
                          }
                      ),
                    ))
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Divider(
            color: Colors.white,
            height: 10,
          ),
        ],
      ),
    );
  }

  void updateTotalAmount() {
    double totalAmount = 0;
    for (var project in projectDetailsList) {
      double amount = double.tryParse(project['amount'] ?? '') ?? 0;
      totalAmount += amount;
    }
    totalAmountController.text = totalAmount.toString();
  }

  @override
  Widget build(BuildContext context) {
    final projectViewModel = Provider.of<ProjectsViewModel>(context);
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
                Navigator.of(context).pop();
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 50, left: 30),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Add Project',
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
                  top: 20,
                  left: 30,
                  child: Text(
                    'Add Project',
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
            bottom: 70,
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                    controller: titleController,
                    hintText: 'Title',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Short Name(3 character)',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  const SizedBox(height: 5),
                  CustomTextField(
                    controller: shortNameController,
                    hintText: 'Short Name(3 character)',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Client',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  const SizedBox(height: 5),
                  CustomDropdown(
                    value: selectClientValue,
                    items: clientNamesList,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectClientValue = newValue;
                        selectClientId = clientList
                            .firstWhere((item) => item.cmpName == newValue)
                            .companyId;
                        getSubClientsList();
                      });
                    },
                    hint: 'Select Client',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Sub-Client',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  const SizedBox(height: 5),
                  CustomDropdown(
                    value: selectSubClientValue,
                    items: subClientNamesList,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectSubClientValue = newValue;
                        selectSubClientId = subsDiaryList
                            .firstWhere((item) => item.entityName == newValue)
                            .entityId;
                      });
                    },
                    hint: 'Select Sub Client',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'P.O Number',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  const SizedBox(height: 5),
                  CustomTextField(
                    controller: poNumberController,
                    hintText: 'P.O Number',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Client Contact',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  const SizedBox(height: 5),
                  CustomTextField(
                    controller: clientContactController,
                    hintText: 'Client Contact',
                  ),
                  const SizedBox(height: 15),
                  for (int i = 0; i < projectDetailsList.length; i++)
                    buildProjectDetailItem(i),

                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Expanded(
                          flex: 5,
                          child:Text(
                            'Total Amount',
                            style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium'),
                          )),
                      Expanded(flex: 1, child: Container()),
                      Expanded(
                          flex: 10,
                          child: CustomTextField(
                            controller: totalAmountController,
                            hintText: '',
                            readOnly: true,
                          ))
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                          flex: 5,
                          child: ButtonOrangeBorder(
                            onPressed: () {
                              addNewItem();
                            },
                            buttonText: 'ADD',
                          )),
                      Expanded(flex: 1, child: Container()),
                      Expanded(
                          flex: 10,
                          child: ButtonOrangeBorder(
                            onPressed: () async {

                              bool isValid = projectDetailsList.isNotEmpty &&
                                  projectDetailsList.every((project) =>
                                  project['projectType']?.isNotEmpty == true &&
                                      project['projectTypeId']?.isNotEmpty == true &&
                                      project['hours']?.isNotEmpty == true &&
                                      project['amount']?.isNotEmpty == true);


                              if (!isValid) {
                                Utils.toastMessage("Please ensure all fields in the project list are filled out.");
                                return;
                              }

                              Map data = {
                                'user_id': _userData?.data?.userId.toString(),
                                'usr_customer_track_id':
                                _userData?.data?.customerTrackId.toString(),
                                'usr_role_track_id':
                                _userData?.data?.roleTrackId.toString(),
                                'quotation_amount': totalAmountController.text.toString(),
                                'token': _userData?.token.toString(),
                              };
                             final response= await projectViewModel.addProjectQuotationApi(data, context);

                             quotationController.text= response!.pdfLink.toString();
                            },
                            buttonText: 'Generate Quotation',
                            loading: projectViewModel.payslipLoading,
                          ))
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Create Quotation',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  const SizedBox(height: 5),
                  CustomTextField(
                    controller: quotationController,
                    hintText: '',
                    readOnly: true,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                          flex: 10,
                          child: Container(
                            child: const Text(
                              'Start Date',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium'),
                            ),
                          )),
                      Expanded(flex: 1, child: Container()),
                      const Expanded(
                          flex: 10,
                          child: Text(
                            'End date',
                            style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium'),
                          ))
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                          flex: 10,
                          child: Container(
                            child: CustomTextField(
                              hintText: 'Start date',
                              controller: startDateController,
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365 * 100)),
                                );

                                if (pickedDate != null) {
                                  String formattedDate =
                                      "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                                  setState(() {
                                    startDateController.text =
                                        formattedDate; // Set the selected date to the text field
                                  });
                                }
                              },
                            ),
                          )),
                      Expanded(flex: 1, child: Container()),
                      Expanded(
                          flex: 10,
                          child: CustomTextField(
                            hintText: 'End date',
                            controller: endDateController,
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365 * 100)),
                              );

                              if (pickedDate != null) {
                                String formattedDate =
                                    "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                                setState(() {
                                  endDateController.text =
                                      formattedDate; // Set the selected date to the text field
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
                        'Project Manager',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  const SizedBox(height: 5),
                  CustomDropdown(
                    value: selectProjectManagerValue,
                    items: projectManagerNamesList,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectProjectManagerValue = newValue;
                        selectProjectManagerId = projectManagerList
                            .firstWhere((item) =>
                                "${item.projectManagerFirstName} ${item.projectManagerLastName}" ==
                                newValue)
                            .userId;
                      });
                    },
                    hint: 'Select Project Manager',
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
                  const SizedBox(height: 5),
                  CustomTextField(
                    controller: descriptionController,
                    hintText: 'Description',
                  ),
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
                if (titleController.text.isEmpty) {
                  Utils.toastMessage("Please enter title");
                } else if (shortNameController.text.isEmpty) {
                  Utils.toastMessage("Please enter short name");
                } else if (selectClientId == null) {
                  Utils.toastMessage("Please select client");
                } else if (selectSubClientId == null) {
                  Utils.toastMessage("Please select sub-client");
                } else if (poNumberController.text.isEmpty) {
                  Utils.toastMessage("Please enter P.O number");
                } else if (clientContactController.text.isEmpty) {
                  Utils.toastMessage("Please enter client contact");
                } /*else if (hoursController.text.isEmpty) {
                  Utils.toastMessage("Please enter project hours");
                } else if (amountController.text.isEmpty) {
                  Utils.toastMessage("Please enter project amount");
                }*/ else if (quotationController.text.isEmpty) {
                  Utils.toastMessage("Please generate project quotation");
                } else if (startDateController.text.isEmpty) {
                  Utils.toastMessage("Please select project start date");
                } else if (endDateController.text.isEmpty) {
                  Utils.toastMessage("Please select project end date");
                } else if (selectProjectManagerId == null) {
                  Utils.toastMessage("Please select project manager");
                } else if (descriptionController.text.isEmpty) {
                  Utils.toastMessage("Please enter description");
                } else {
                  Map data = {
                    'user_id': _userData?.data?.userId.toString(),
                    'usr_customer_track_id':
                        _userData?.data?.customerTrackId.toString(),
                    'usr_role_track_id':
                        _userData?.data?.roleTrackId.toString(),
                    'project_name': titleController.text.toString(),
                    'project_shortname': shortNameController.text.toString(),
                    'client_id': selectClientId,
                    'sub_client_id': selectSubClientId,
                    'po_number': poNumberController.text.toString(),
                    'project_contact': clientContactController.text.toString(),
                    'project_total_amount': totalAmountController.text.toString(),
                    'project_quotation': quotationController.text.toString(),
                    'project_start_date': startDateController.text.toString(),
                    'project_end_date': endDateController.text.toString(),
                    'project_manager_id': selectProjectManagerId,
                    'project_description':
                        descriptionController.text.toString(),
                    'budget_hours': projectDetailsList[0]['hours'] ?? '',
                    'token': _userData?.token.toString(),
                  };

                  for (int i = 0; i < projectDetailsList.length; i++) {
                    data['project_activity[$i][type]'] = projectDetailsList[i]['projectTypeId'] ?? '';
                    data['project_activity[$i][hours]'] = projectDetailsList[i]['hours'] ?? '';
                    data['project_activity[$i][amount]'] = projectDetailsList[i]['amount'] ?? '';
                  }

                  projectViewModel.addProjectApi(data, context);
                }
              },
              buttonText: 'Save Project',
              loading: projectViewModel.loading,
            ),
          ),
        ],
      ),
    );
  }
}
