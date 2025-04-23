import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/model/appraisal/AppraisalDetailModel.dart';
import 'package:intrasense/res/component/ViewRatingsBar.dart';

import '../../model/user_model.dart';
import '../../res/component/CustomRatingBar.dart';
import '../../utils/AppColors.dart';
import '../../utils/Constants.dart';
import '../../utils/Utils.dart';
import '../../view_models/appraisal_view_model.dart';
import '../../view_models/user_view_model.dart';
import '../Home/HomeScreen.dart';
import 'package:provider/provider.dart';

class FragmentSelfRatingAppraisal extends StatefulWidget {
  final AppraisalId;

  const FragmentSelfRatingAppraisal({
    Key? key,
    required this.AppraisalId,
  }): super(key: key);

  @override
  _FragmentSelfRatingAppraisal createState() => _FragmentSelfRatingAppraisal();
}

class _FragmentSelfRatingAppraisal extends State<FragmentSelfRatingAppraisal> {
  UserModel? _userData;
  bool _isLoading = false;
  bool isDataLoaded = false;
  AppraisalDetailModel? appraisalDetail;

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
            ],
          ),
        )
      ],
    ));
  }
}
