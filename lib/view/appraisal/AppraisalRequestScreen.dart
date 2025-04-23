import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../model/projects/ProjectManagersModel.dart';
import '../../model/user_model.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomRatingBar.dart';
import '../../res/component/CustomTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/projects_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class AppraisalRequestScreen extends StatefulWidget{
  @override
  _AppraisalRequestScreen createState()=> _AppraisalRequestScreen();

}
class _AppraisalRequestScreen extends State<AppraisalRequestScreen>{
  bool _isLoading = false;
  UserModel? _userData;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _attendanceAndPunctuallyController = TextEditingController();
  final TextEditingController _workAndIntegrityController = TextEditingController();
  final TextEditingController _qualityOfWorkController = TextEditingController();
  final TextEditingController _leadershipQualityController = TextEditingController();
  final TextEditingController _communicationSkillsController = TextEditingController();
  final TextEditingController _problemSolvingController = TextEditingController();

  String? selectProjectManagerValue;
  String? selectProjectManagerId;
  List<ProjectManagersModel> projectManagerList = [];
  List<String> projectManagerNamesList = [];


  @override
  void initState() {
    getUserDetails(context);
    super.initState();
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    getProjectManagersList();

  }

  void getProjectManagersList() async {
    setLoading(true);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'customer_id': _userData?.data?.customerTrackId,
        'token': _userData?.token,
      };
      final projectViewModel = Provider.of<ProjectsViewModel>(context, listen: false);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: MediaQuery
                .of(context)
                .size
                .height,
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
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
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
                  'Request Appraisal',
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
            top: 120,
            left: 20,
            right: 20,
            bottom: 0,
            child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Request Appraisal",
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.secondaryOrange,
                              fontFamily: 'PoppinsMedium'),
                        )),
                    const SizedBox(height: 20),
                    const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'First Name',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsMedium'),
                        )),
                    const SizedBox(height: 5),
                    CustomTextField(
                      hintText: 'First Name',
                      controller: _firstNameController,
                    ),
                    const SizedBox(height: 15),

                    const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Last Name',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsMedium'),
                        )),
                    const SizedBox(height: 5),
                    CustomTextField(
                      hintText: 'Last Name',
                      controller: _lastNameController,
                    ),
                    const SizedBox(height: 15),

                    const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Employee ID',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsMedium'),
                        )),
                    const SizedBox(height: 5),
                    CustomTextField(
                      hintText: 'Employee ID',
                      controller: _employeeIdController,
                    ),

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
                      hintText: 'Department',
                      controller: _departmentController,
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
                          'Reason',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsMedium'),
                        )),
                    const SizedBox(height: 5),
                    CustomTextField(
                        controller: _reasonController,
                        hintText: 'Reason',
                        minLines: 4,
                        maxLines: 4),
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Attendance &\n Punctually',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium'),
                            )),

                        CustomRatingBar(
                          initialRating: 0.0,
                          onRatingUpdate: (rating) {
                            setState(() {
                              //_rating = rating;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      hintText: 'Attendance & Punctually',
                      controller: _attendanceAndPunctuallyController,
                    ),
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Work Ethic &\n Integrity',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium'),
                            )),

                        CustomRatingBar(
                          initialRating: 0.0,
                          onRatingUpdate: (rating) {
                            setState(() {
                              //_rating = rating;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      hintText: 'Work Ethic &\n Integrity',
                      controller: _workAndIntegrityController,
                    ),
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Quality of Work',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium'),
                            )),

                        CustomRatingBar(
                          initialRating: 0.0,
                          onRatingUpdate: (rating) {
                            setState(() {
                              //_rating = rating;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      hintText: 'Quality of Work',
                      controller: _qualityOfWorkController,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Leadership Qualities',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium'),
                            )),

                        CustomRatingBar(
                          initialRating: 0.0,
                          onRatingUpdate: (rating) {
                            setState(() {
                              //_rating = rating;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      hintText: 'Leadership Qualities',
                      controller: _leadershipQualityController,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Communication Skills',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium'),
                            )),

                        CustomRatingBar(
                          initialRating: 0.0,
                          onRatingUpdate: (rating) {
                            setState(() {
                              //_rating = rating;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      hintText: 'Communication Skills',
                      controller: _communicationSkillsController,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Problem Solving',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium'),
                            )),

                        CustomRatingBar(
                          initialRating: 0.0,
                          onRatingUpdate: (rating) {
                            setState(() {
                              //_rating = rating;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      hintText: 'Problem Solving',
                      controller: _problemSolvingController,
                    ),

                    const SizedBox(height: 15),

                    CustomElevatedButton(
                      onPressed: () {
                        if (_firstNameController.text.toString().isEmpty) {
                          Utils.toastMessage("Please enter first name");
                        }
                        else if (_lastNameController.text.toString().isEmpty) {
                          Utils.toastMessage("Please enter last name");
                        }
                        else if (_employeeIdController.text.toString().isEmpty) {
                          Utils.toastMessage("Please enter employee ID");
                        }
                        else if (_departmentController.text.toString().isEmpty) {
                          Utils.toastMessage("Please enter department");
                        }
                        else if (selectProjectManagerValue == null) {
                          Utils.toastMessage("Please select project manager");
                        }

                        else if (_reasonController.text.toString().isEmpty) {
                          Utils.toastMessage("Please enter reason");
                        }

                        else {
                         /* Map data = {
                            'user_id': _userData?.data?.userId.toString(),
                            'usr_role_track_id':
                            _userData?.data?.roleTrackId.toString(),
                            'deviceToken':Constants.deviceToken,
                            'deviceType':Constants.deviceType,
                            'title': _titleController.text.toString(),
                            'eventdate': _dateController.text.toString(),
                            'venue':_address1Controller.text.toString(),
                            'timefrom':_startTimeController.text.toString(),
                            'timeto':_endTimeController.text.toString(),
                            'timezone':selectTimeZoneValue,
                            'googlemapurl':_googleMapUrlController.text.toString(),
                            'description':_desController.text.toString(),
                            'token': _userData?.token.toString(),
                          };
                          */
                          //eventViewModel.addEventApi(data, context);
                        }
                      },
                      buttonText: 'SUBMIT APPRAISAL REQUEST',
                     // loading: eventViewModel.loading,
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }

}