import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../model/appraisal/AppraisalDetailModel.dart';
import '../../model/user_model.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomRatingBar.dart';
import '../../res/component/CustomTextField.dart';
import '../../res/component/ViewRatingsBar.dart';
import '../../utils/AppColors.dart';
import '../../utils/Constants.dart';
import '../../utils/Utils.dart';
import '../../view_models/appraisal_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';

import '../Home/HomeScreen.dart';

class FragmentManagerRatingAppraisal extends StatefulWidget{
  final AppraisalId;

  const FragmentManagerRatingAppraisal({
    Key? key,
    required this.AppraisalId,
  }): super(key: key);

  @override
  _FragmentManagerRatingAppraisal createState()=> _FragmentManagerRatingAppraisal();

}

class _FragmentManagerRatingAppraisal extends State<FragmentManagerRatingAppraisal>{

  UserModel? _userData;
  bool _isLoading = false;
  bool isDataLoaded = false;
  bool isManagerRatingAdded = false;
  AppraisalDetailModel? appraisalDetail;
  ManagerRating? managerRating;

  final TextEditingController _attendanceAndPunctuallyController = TextEditingController();
  final TextEditingController _workAndIntegrityController = TextEditingController();
  final TextEditingController _qualityOfWorkController = TextEditingController();
  final TextEditingController _leadershipQualityController = TextEditingController();
  final TextEditingController _communicationSkillsController = TextEditingController();
  final TextEditingController _problemSolvingController = TextEditingController();

  @override
  void initState() {
    getUserDetails(context);
    super.initState();
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    if (kDebugMode) {
      print(_userData);
    }
    getAppraisalDetail();
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  void getAppraisalDetail() async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'request_id': widget.AppraisalId,
        'deviceToken': Constants.deviceToken,
        'deviceType': Constants.deviceType,
        'token': _userData?.token,
      };
      final appraisalViewModel =
      Provider.of<AppraisalViewModel>(context, listen: false);
      final response =
      await appraisalViewModel.getAppraisalDetailApi(data, context);
      setState(() {
        if (response != null) {
          var appraisalList = response.toList();
          appraisalDetail = appraisalList[0];
          if(appraisalList[0].managerRating?.isNotEmpty==true){
          managerRating= appraisalList[0].managerRating?[0];
          setState(() {
            isManagerRatingAdded= true;
          });
          }

          setState(() {
            isDataLoaded = true;
          });
        }
      });
      Utils.hideLoadingDialog(context);
    } catch (error, stackTrace) {
      Utils.hideLoadingDialog(context);
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
            SingleChildScrollView(
              child: Column(
                children: [
                  if (isDataLoaded) ...{
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: const Text(
                                'Rate',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsRegular',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Text(
                                    ((appraisalDetail?.selfRating != null ? double.tryParse(appraisalDetail?.selfRating?.toString()??"0.0") : 0.0) ?? 0.0)
                                        .toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textColor,
                                      fontFamily: 'PoppinsMedium',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  ViewRatingsBar(rating: 3.0),
                                ],
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: const Text(
                                'Appraised by',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsRegular',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Text(
                                appraisalDetail!.firstName?.toString()??""+" "+appraisalDetail!.lastName.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium',
                                  fontWeight: FontWeight.w500,
                                ),
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: const Text(
                                'Department',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsRegular',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Text(
                                appraisalDetail!.department.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium',
                                  fontWeight: FontWeight.w500,
                                ),
                              ))
                        ],
                      ),
                    ),
                    if(isManagerRatingAdded)...{
                      const SizedBox(height: 20),
                      const DividerColor(),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Attendance &\nPunctually',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textColor,
                                      fontFamily: 'PoppinsMedium',
                                      fontWeight: FontWeight.w500),
                                )),
                            ViewRatingsBar(rating: double.tryParse(appraisalDetail?.attendanceRating ?? '0') ?? 0.0,),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              appraisalDetail!.attendanceComment.toString(),
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsRegular',
                                  fontWeight: FontWeight.w400),
                            )),
                      ),
                      const SizedBox(height: 20),
                      const DividerColor(),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Work Ethic &\nIntegrity',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textColor,
                                      fontFamily: 'PoppinsMedium',
                                      fontWeight: FontWeight.w500),
                                )),
                            ViewRatingsBar(rating: double.tryParse(appraisalDetail?.workEthicsRating ?? '0') ?? 0.0,),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              appraisalDetail!.workEthicsComment.toString(),
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsRegular',
                                  fontWeight: FontWeight.w400),
                            )),
                      ),
                      const SizedBox(height: 20),
                      const DividerColor(),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Quality of Work',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textColor,
                                      fontFamily: 'PoppinsMedium',
                                      fontWeight: FontWeight.w500),
                                )),
                            ViewRatingsBar(rating: double.tryParse(appraisalDetail?.qualityOfWorkRating ?? '0') ?? 0.0,),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              appraisalDetail!.qualityOfWorkComment.toString(),
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsRegular',
                                  fontWeight: FontWeight.w400),
                            )),
                      ),
                      const SizedBox(height: 20),
                      const DividerColor(),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Leadership Qualities',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textColor,
                                      fontFamily: 'PoppinsMedium',
                                      fontWeight: FontWeight.w500),
                                )),
                            ViewRatingsBar(rating: double.tryParse(appraisalDetail?.leadershipQualitiesRating ?? '0') ?? 0.0,),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              appraisalDetail!.leadershipComment.toString(),
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsRegular',
                                  fontWeight: FontWeight.w400),
                            )),
                      ),
                      const SizedBox(height: 20),
                      const DividerColor(),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Communication Skills',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textColor,
                                      fontFamily: 'PoppinsMedium',
                                      fontWeight: FontWeight.w500),
                                )),
                            ViewRatingsBar(rating: double.tryParse(appraisalDetail?.communicationRating ?? '0') ?? 0.0,),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              appraisalDetail!.communicationComment.toString(),
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsRegular',
                                  fontWeight: FontWeight.w400),
                            )),
                      ),
                      const SizedBox(height: 20),
                      const DividerColor(),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Problem Solving',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textColor,
                                      fontFamily: 'PoppinsMedium',
                                      fontWeight: FontWeight.w500),
                                )),
                            ViewRatingsBar(rating: double.tryParse(appraisalDetail?.problemSolvingRating ?? '0') ?? 0.0,),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              appraisalDetail!.problemSolvingComment.toString(),
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsRegular',
                                  fontWeight: FontWeight.w400),
                            )),
                      ),
                      const SizedBox(height: 20),
                    }
                    else...{
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child:  Row(
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
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child:  CustomTextField(
                          hintText: 'Attendance & Punctually',
                          controller: _attendanceAndPunctuallyController,
                        ),
                      ),
                      const SizedBox(height: 15),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
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
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child:CustomTextField(
                        hintText: 'Work Ethic &\n Integrity',
                        controller: _workAndIntegrityController,
                      )),
                      const SizedBox(height: 15),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child:  Row(
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
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CustomTextField(
                          hintText: 'Quality of Work',
                          controller: _qualityOfWorkController,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
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
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child:  CustomTextField(
                          hintText: 'Leadership Qualities',
                          controller: _leadershipQualityController,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child:  Row(
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
                      ),
                      const SizedBox(height: 5),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CustomTextField(
                          hintText: 'Communication Skills',
                          controller: _communicationSkillsController,
                        ),
                      ),

                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child:  Row(
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
                      ),
                      const SizedBox(height: 5),

                      Padding( padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child:CustomTextField(
                        hintText: 'Problem Solving',
                        controller: _problemSolvingController,
                      )),

                      const SizedBox(height: 15),

                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CustomElevatedButton(
                          onPressed: () {
                            /* if (_firstNameController.text.toString().isEmpty) {
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
                          *//* Map data = {
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
                          *//*
                          //eventViewModel.addEventApi(data, context);*/
                            // }
                          },
                          buttonText: 'SUBMIT',
                          // loading: eventViewModel.loading,
                        ) ,
                      ),
                    }
                  }

                ],
              ),
            )
          ],
        ));
  }

}