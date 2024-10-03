import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/model/projects/ProjectManagersModel.dart';
import 'package:intrasense/model/projects/ProjectTypesModel.dart';
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
  TextEditingController hoursController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController quotationController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDetails(context);
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
      await clientViewModel.getClientListApi(data, context);
      clientList = clientViewModel.clientList;
      setState(() {
        clientNamesList = clientList.map((item) => item.cmpName).toList();
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
      await clientViewModel.getSubClientListApi(data, context);
      subsDiaryList = clientViewModel.subsDiaryList;
      setState(() {
        subClientNamesList =
            subsDiaryList.map((item) => item.entityName.toString()).toList();
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
          projectManagerList = response;
          projectManagerNamesList =
              projectManagerList.map((item) => item.userName).toList();
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
      final projectViewModel = Provider.of<ProjectsViewModel>(context, listen: false);
      final response = await projectViewModel.getProjectTypesApi(data, context);

      if (response != null) {
        setState(() {
          projectTypesList = response;
          for (var item in projectTypesList) {
            projectTypesNamesList.add('**${item.moduleCatTitle}**');
            for (var itemCategory in item.categoryType){
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
                   CustomTextField(
                     controller: clientContactController,
                    hintText: 'Client Contact',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Project Type',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  CustomDropdown(
                    value: selectProjectTypeValue,
                    items: projectTypesNamesList,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectProjectTypeValue = newValue;
                      });
                    },
                    hint: 'Project type',
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                          flex: 10,
                          child: Container(
                            child: const Text(
                              'Hours',
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
                            'Amount',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w500,
                            ),
                          ))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 10,
                          child: Container(
                            child: CustomTextField(
                              controller: hoursController,
                              hintText: 'Hours',
                            ),
                          )),
                      Expanded(flex: 1, child: Container()),
                      Expanded(
                          flex: 10,
                          child: Container(
                            child: CustomTextField(
                              controller: amountController,
                              hintText: 'Amount',
                            ),
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
                   CustomTextField(
                    controller: quotationController,
                    hintText: '',
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
                                fontFamily: 'PoppinsRegular',
                                fontWeight: FontWeight.w400,
                              ),
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
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w500,
                            ),
                          ))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 10,
                          child: Container(
                            child: CustomTextField(
                              hintText: 'Start date',
                              controller: startDateController,
                              readOnly: true,
                              onTap: () async{
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now().add(const Duration(days: 365 * 100)),
                                );

                                if (pickedDate != null) {
                                  String formattedDate = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                                  setState(() {
                                    startDateController.text = formattedDate; // Set the selected date to the text field
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
                            onTap: () async{
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now().add(const Duration(days: 365 * 100)),
                              );

                              if (pickedDate != null) {
                                String formattedDate = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                                setState(() {
                                  endDateController.text = formattedDate; // Set the selected date to the text field
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
                  CustomDropdown(
                    value: selectProjectManagerValue,
                    items: projectManagerNamesList,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectProjectManagerValue = newValue;
                        selectProjectManagerId = projectManagerList
                            .firstWhere((item) => item.userName == newValue)
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
                if(titleController.text.isEmpty){
                  Utils.toastMessage("Please enter title");
                }
                else if(shortNameController.text.isEmpty){
                  Utils.toastMessage("Please enter short name");
                }
                else if(selectClientId==null){
                  Utils.toastMessage("Please select client");
                }
                else if(selectSubClientId==null){
                  Utils.toastMessage("Please select sub-client");
                }
                else if(poNumberController.text.isEmpty){
                  Utils.toastMessage("Please enter P.O number");
                }
                else if(clientContactController.text.isEmpty){
                  Utils.toastMessage("Please enter client contact");
                }
                else if(hoursController.text.isEmpty){
                  Utils.toastMessage("Please enter project hours");
                }
                else if(amountController.text.isEmpty){
                  Utils.toastMessage("Please enter project amount");
                }
                else if(quotationController.text.isEmpty){
                  Utils.toastMessage("Please enter project quotation");
                }
                else if(startDateController.text.isEmpty){
                  Utils.toastMessage("Please select project start date");
                }
                else if(endDateController.text.isEmpty){
                  Utils.toastMessage("Please select project end date");
                }
                else if(selectProjectManagerId==null){
                  Utils.toastMessage("Please select project manager");
                }
                else if(descriptionController.text.isEmpty){
                  Utils.toastMessage("Please enter description");
                }
                else{
                  Map data = {
                    'user_id' : _userData?.data?.userId.toString(),
                    'usr_customer_track_id' : _userData?.data?.customerTrackId.toString(),
                    'usr_role_track_id' : _userData?.data?.roleTrackId.toString(),
                    'project_name' : titleController.text.toString(),
                    'project_shortname' : shortNameController.text.toString(),
                    'client_id' : selectClientId,
                    'sub_client_id' : selectSubClientId,
                    'po_number' : poNumberController.text.toString(),
                    'project_contact' : clientContactController.text.toString(),
                    'project_total_amount' : amountController.text.toString(),
                    'project_quotation' : quotationController.text.toString(),
                    'project_start_date' : startDateController.text.toString(),
                    'project_end_date' : endDateController.text.toString(),
                    'project_manager_id' : selectProjectManagerId,
                    'project_description' : descriptionController.text.toString(),
                    'budget_hours' : hoursController.text.toString(),
                    //'project_activity[0][type]:' : '',
                    'token' : _userData?.token.toString(),
                  };
                  projectViewModel.addProjectApi(data,context);
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
