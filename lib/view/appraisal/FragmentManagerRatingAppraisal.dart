import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../model/appraisal/AppraisalDetailModel.dart';
import '../../model/user_model.dart';
import '../../res/component/ButtonOrangeBorder.dart';
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

  String attendanceAndPunctuallyRating="0";
  String workEthicIntegrityRating="0";
  String qualityOfWorkRating="0";
  String leadershipQualityRating="0";
  String communicationSkillRating="0";
  String problemSolvingRating="0";

  final TextEditingController _declineCommentsController = TextEditingController();

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
    final appraisalViewModel = Provider.of<AppraisalViewModel>(context, listen: false);
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
                                  attendanceAndPunctuallyRating = rating.toString().split('.')[0];
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
                                  workEthicIntegrityRating = rating.toString().split('.')[0];
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
                                  qualityOfWorkRating = rating.toString().split('.')[0];
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
                                  leadershipQualityRating = rating.toString().split('.')[0];
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
                                  communicationSkillRating = rating.toString().split('.')[0];
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
                                  problemSolvingRating = rating.toString().split('.')[0];
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
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: ButtonOrangeBorder(
                                  onPressed: () async {
                                    appraisalRevertAPI("3");
                                  },
                                  buttonText: 'DECLINE',
                                )),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                                flex: 1,
                                child: CustomElevatedButton(
                                  onPressed: () async {
                                    appraisalRevertAPI("2");
                                  },
                                  buttonText: 'SUBMIT',
                                  loading: appraisalViewModel.loading,
                                ))
                          ],
                        ),
                      )
                    }
                  }
                ],
              ),
            )
          ],
        ));
  }

  void declineAppraisalPopUp(BuildContext context) {
      final appraisalViewModel = Provider.of<AppraisalViewModel>(context, listen: false);
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: AppColors.secondaryOrange.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Comment',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.secondaryOrange,
                            fontFamily: 'PoppinsMedium',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.textColor,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Comments',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: CustomTextField(
                      controller: _declineCommentsController,
                      hintText: 'Comments',
                      minLines: 4,
                      maxLines: 4,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: CustomElevatedButton(
                      onPressed: () async {
                        if (_declineCommentsController.text.toString().isEmpty) {
                          Utils.toastMessage("Please add comments");
                        } else {
                          Navigator.pop(context, true);
                          Utils.showLoadingDialog(context);
                          Map data = {
                            'user_id': _userData?.data?.userId.toString(),
                            'usr_role_track_id': _userData?.data?.roleTrackId.toString(),
                            'deviceToken':Constants.deviceToken,
                            'deviceType':Constants.deviceType,
                            'request_id':  widget.AppraisalId,
                            'attendence_rating':attendanceAndPunctuallyRating,
                            'workethics_rating':workEthicIntegrityRating,
                            'qualityofwork_rating':qualityOfWorkRating,
                            'leadershipqualities_rating':leadershipQualityRating,
                            'communication_rating':communicationSkillRating,
                            'problemsolving_rating':problemSolvingRating,
                            'attendence_comment':_attendanceAndPunctuallyController.text.toString(),
                            'workethics_comment':_workAndIntegrityController.text.toString(),
                            'qualityofwork_comment':_qualityOfWorkController.text.toString(),
                            'leadership_comment':_leadershipQualityController.text.toString(),
                            'communication_comment':_communicationSkillsController.text.toString(),
                            'problemsolving_comment':_problemSolvingController.text.toString(),
                            'reason':_declineCommentsController.text.toString(),
                            'appraisal_status':"3",
                            'token': _userData?.token.toString(),
                          };
                          await appraisalViewModel.appraisalPMRevertApi(data, context);
                          Utils.hideLoadingDialog(context);
                          Navigator.pop(context, true);
                        }
                      },
                      buttonText: 'SUBMIT',
                      loading: appraisalViewModel.loading,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
  }

  void appraisalRevertAPI(String revertStatus) async {
    if (_attendanceAndPunctuallyController.text.toString().isEmpty) {
      Utils.toastMessage("Please enter Attendance & Punctually");
    }

    else if (_workAndIntegrityController.text.toString().isEmpty) {
      Utils.toastMessage("Please enter work ethic & integrity");
    }

    else if (_qualityOfWorkController.text.toString().isEmpty) {
      Utils.toastMessage("Please enter quality of work");
    }

    else if (_leadershipQualityController.text.toString().isEmpty) {
      Utils.toastMessage("Please enter leadership qualities");
    }

    else if (_communicationSkillsController.text.toString().isEmpty) {
      Utils.toastMessage("Please enter communication skills");
    }

    else if (_problemSolvingController.text.toString().isEmpty) {
      Utils.toastMessage("Please enter problem solving");
    }

    else if(revertStatus=="3"){
      declineAppraisalPopUp(context);
    }
    else if(revertStatus=="2"){
      Utils.showLoadingDialog(context);
      Map data = {
        'user_id': _userData?.data?.userId.toString(),
        'usr_role_track_id': _userData?.data?.roleTrackId.toString(),
        'deviceToken':Constants.deviceToken,
        'deviceType':Constants.deviceType,
        'request_id':  widget.AppraisalId,
        'attendence_rating':attendanceAndPunctuallyRating,
        'workethics_rating':workEthicIntegrityRating,
        'qualityofwork_rating':qualityOfWorkRating,
        'leadershipqualities_rating':leadershipQualityRating,
        'communication_rating':communicationSkillRating,
        'problemsolving_rating':problemSolvingRating,
        'attendence_comment':_attendanceAndPunctuallyController.text.toString(),
        'workethics_comment':_workAndIntegrityController.text.toString(),
        'qualityofwork_comment':_qualityOfWorkController.text.toString(),
        'leadership_comment':_leadershipQualityController.text.toString(),
        'communication_comment':_communicationSkillsController.text.toString(),
        'problemsolving_comment':_problemSolvingController.text.toString(),
        'reason':"",
        'status':revertStatus,
        'token': _userData?.token.toString(),
      };
      final appraisalViewModel = Provider.of<AppraisalViewModel>(context, listen: false);
      await appraisalViewModel.appraisalPMRevertApi(data, context);
      Utils.hideLoadingDialog(context);

    }
  }
}