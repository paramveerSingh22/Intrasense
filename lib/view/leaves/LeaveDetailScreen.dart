import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/user_model.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Constants.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/leave_view_model.dart';
import '../../view_models/user_view_model.dart';
import '../Home/HomeScreen.dart';

class LeaveDetailScreen extends StatefulWidget {
  final dynamic leaveDetail;

  const LeaveDetailScreen({Key? key, this.leaveDetail}) : super(key: key);

  @override
  _LeaveDetailScreen createState() => _LeaveDetailScreen();
}

class _LeaveDetailScreen extends State<LeaveDetailScreen> {
  final TextEditingController _desController = TextEditingController();
  final TextEditingController _AddDesController = TextEditingController();
  String? selectLeaveStatusValue;
  UserModel? _userData;
  bool _isLoading = false;

  @override
  void initState() {
    getUserDetails(context);
    _desController.text = widget.leaveDetail.levAppliedComment;
    super.initState();
  }

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    final leaveViewModel = Provider.of<LeaveViewModel>(context);

    DateTime startDate = DateTime.parse(widget.leaveDetail.levStartDate);
    DateTime endDate = DateTime.parse(widget.leaveDetail.levEndDate);
    int numberOfDays = endDate.difference(startDate).inDays + 1;

    String getStatusText(String status) {
      switch (status) {
        case "1":
          return 'PENDING';
        case "2":
          return 'APPROVED';
        case "3":
          return 'CANCELED';
        case "4":
          return 'REJECTED';
        default:
          return 'INPROGRESS';
      }
    }

    String getLeaveType(String type) {
      switch (type) {
        case "1":
          return 'Full Day';
        case "2":
          return 'Half Day';
        case "3":
          return 'Short leave';
        case "4":
          return 'Paternity leave';
        case "5":
          return 'Maternity leave';
        default:
          return 'Full Day';
      }
    }

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
                  'Leave Request Status',
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
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Leave Request Status',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.secondaryOrange,
                                    fontFamily: 'PoppinsMedium'),
                              )),
                        ),
                        const SizedBox(height: 15),
                        Stack(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 0.0, right: 0.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  ),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: AppColors.dividerColor,
                                    width: 1.0,
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.only(
                                    bottom: 10,
                                    top: 0,
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10, top: 13.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex: 10,
                                                child: Text(
                                                  'Staff ID-' +
                                                      widget
                                                          .leaveDetail.usrEmpID,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors
                                                        .skyBlueTextColor,
                                                    fontFamily: 'PoppinsMedium',
                                                  ),
                                                )),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 0.0),
                                              child: Expanded(
                                                  flex: 1,
                                                  child: Row(
                                                    children: [
                                                      Visibility(
                                                        visible: false,
                                                        child: IconButton(
                                                          icon: SizedBox(
                                                            height: 20.0,
                                                            width: 20.0,
                                                            child: Image.asset(
                                                                Images
                                                                    .editIcon),
                                                          ),
                                                          onPressed: () {
                                                            // Navigator.push logic or any other functionality
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                child: const Text(
                                                  'Employee Name',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.textColor,
                                                    fontFamily:
                                                        'PoppinsRegular',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                  widget.leaveDetail
                                                          .userFirstName +
                                                      " " +
                                                      widget.leaveDetail
                                                          .userLastName,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.textColor,
                                                    fontFamily:
                                                        'PoppinsRegular',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const DividerColor(),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Container(
                                                    child: const Text(
                                                      'Leave Type',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            AppColors.textColor,
                                                        fontFamily:
                                                            'PoppinsRegular',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                  getLeaveType(widget
                                                      .leaveDetail.levType),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.textColor,
                                                    fontFamily:
                                                        'PoppinsRegular',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const DividerColor(),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex: 1,
                                                child: Container(
                                                  child: const Text(
                                                    'Purpose',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          AppColors.textColor,
                                                      fontFamily:
                                                          'PoppinsRegular',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                )),
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                  widget.leaveDetail.levPurpose,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.textColor,
                                                    fontFamily:
                                                        'PoppinsRegular',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const DividerColor(),
                                      const SizedBox(height: 10),
                                      if (widget.leaveDetail.levType ==
                                              "Half Day" ||
                                          widget.leaveDetail.levType ==
                                              "Short leave") ...{
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    child: const Text(
                                                      'Date',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            AppColors.textColor,
                                                        fontFamily:
                                                            'PoppinsRegular',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  )),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    widget.leaveDetail
                                                        .levStartDate,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          AppColors.textColor,
                                                      fontFamily:
                                                          'PoppinsRegular',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const DividerColor(),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    child: const Text(
                                                      'Start time',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            AppColors.textColor,
                                                        fontFamily:
                                                            'PoppinsRegular',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  )),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    widget.leaveDetail
                                                        .levStartTime,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          AppColors.textColor,
                                                      fontFamily:
                                                          'PoppinsRegular',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const DividerColor(),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    child: const Text(
                                                      'End time',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            AppColors.textColor,
                                                        fontFamily:
                                                            'PoppinsRegular',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  )),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    widget
                                                        .leaveDetail.levEndTime,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          AppColors.textColor,
                                                      fontFamily:
                                                          'PoppinsRegular',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const DividerColor(),
                                        const SizedBox(height: 10),
                                      } else ...{
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    child: const Text(
                                                      'From',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            AppColors.textColor,
                                                        fontFamily:
                                                            'PoppinsRegular',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  )),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    widget.leaveDetail
                                                        .levStartDate,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          AppColors.textColor,
                                                      fontFamily:
                                                          'PoppinsRegular',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const DividerColor(),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    child: const Text(
                                                      'To',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            AppColors.textColor,
                                                        fontFamily:
                                                            'PoppinsRegular',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  )),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    widget
                                                        .leaveDetail.levEndDate,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          AppColors.textColor,
                                                      fontFamily:
                                                          'PoppinsRegular',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const DividerColor(),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    child: const Text(
                                                      'No. of Days',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            AppColors.textColor,
                                                        fontFamily:
                                                            'PoppinsRegular',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  )),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    numberOfDays.toString(),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          AppColors.textColor,
                                                      fontFamily:
                                                          'PoppinsRegular',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const DividerColor(),
                                        const SizedBox(height: 10),
                                      },
                                      if (widget.leaveDetail.levPurpose == "Medical Emergency")...{
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                          child: Row(
                                            children: [
                                              // Left section with "Medical"
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  child: const Text(
                                                    'Medical',
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
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        showDocumentDialog(context);
                                                      },
                                                      child: SizedBox(
                                                        height: 20.0,
                                                        width: 20.0,
                                                        child: Image.asset(Images.eyeIcon),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const DividerColor(),
                                        const SizedBox(height: 10),

                                      },

                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex: 1,
                                                child: Container(
                                                  child: const Text(
                                                    'Status',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          AppColors.textColor,
                                                      fontFamily:
                                                          'PoppinsRegular',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                )),
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                  getStatusText(widget
                                                      .leaveDetail.levStatus),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        AppColors.primaryColor,
                                                    fontFamily:
                                                        'PoppinsRegular',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 0.0, right: 0.0),
                              child: IgnorePointer(
                                ignoring: true,
                                child: Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: AppColors.secondaryOrange
                                          .withOpacity(0.1),
                                      // Making it semi-transparent
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
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
                          controller: _desController,
                          hintText: 'Description',
                          minLines: 4,
                          maxLines: 4,
                          readOnly: true,
                        ),
                        if (widget.leaveDetail.levStatus.toString() == "1" && widget.leaveDetail.userId.toString()!=_userData?.data?.userId.toString() && (_userData?.data?.roleTrackId.toString()=="2"||_userData?.data?.roleTrackId.toString()=="3")) ...{
                          const SizedBox(height: 15),
                          const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Leave status',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                    fontFamily: 'PoppinsMedium'),
                              )),
                          const SizedBox(height: 5),
                          CustomDropdown(
                            value: selectLeaveStatusValue,
                            items: [
                              "Pending",
                              "Approved",
                              "Rejected",
                              "Discuss with HR"
                            ],
                            onChanged: (String? newValue) {
                              setState(() {
                                selectLeaveStatusValue = newValue;
                              });
                            },
                            hint: 'Leave status',
                          ),
                        },
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.leaveDetail.levStatus == "1" && widget.leaveDetail.userId.toString()!=_userData?.data?.userId.toString() && (_userData?.data?.roleTrackId.toString()==Constants.roleProjectManager||_userData?.data?.roleTrackId.toString()==Constants.roleHR)) ...{
            Positioned(
              left: 0,
              right: 0,
              bottom: 0, // Position button at the bottom of the screen
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: CustomElevatedButton(
                    onPressed: ()  {
                       if (selectLeaveStatusValue == null) {
                        Utils.toastMessage("Please select leave status");
                        return;
                      }

                      // Map Dropdown Value to Leave Status
                      String leaveStatus = "1";
                      switch (selectLeaveStatusValue?.trim().toLowerCase()) {
                        case "pending":
                          leaveStatus = "1";
                          break;
                        case "approved":
                          leaveStatus = "2";
                          break;
                        case "rejected":
                          leaveStatus = "4";
                          openCommentPopUp(leaveStatus);
                          return; // Stop further execution
                        case "discuss with hr":
                          leaveStatus = "5";
                          openCommentPopUp(leaveStatus);
                          return; // Stop further execution
                        default:
                          Utils.toastMessage("Invalid leave status selected");
                          return;
                      }

                      Map<String, dynamic> data = {
                        'user_id': _userData?.data?.userId.toString(),
                        'usr_role_track_id': _userData?.data?.roleTrackId.toString(),
                        'usr_customer_track_id': _userData?.data?.customerTrackId.toString(),
                        'leave_id': widget.leaveDetail.leaveId,
                        'comments': "",
                        'leave_status': leaveStatus,
                        'token': _userData?.token.toString(),
                      };
                         leaveViewModel.acceptDeclineLeaveApi(data, context);
                      // Navigator.pop(context, true);
                    },
                    buttonText: 'SUBMIT',
                    loading: leaveViewModel.loading),
              ),
            )
          },
        ],
      ),
    );
  }


  void openCommentPopUp(String leaveStatus) {
    final leaveViewModel = Provider.of<LeaveViewModel>(context, listen: false);
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
                      'Description',
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
                    controller: _AddDesController,
                    hintText: 'Description',
                    minLines: 4,
                    maxLines: 4,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  child: CustomElevatedButton(
                    onPressed: () async {
                      if (_AddDesController.text.toString().isEmpty) {
                        Utils.toastMessage("Please add comments");
                      } else {
                        Navigator.pop(context, true);
                        Utils.showLoadingDialog(context);
                        Map data = {
                          'user_id': _userData?.data?.userId.toString(),
                          'usr_role_track_id': _userData?.data?.roleTrackId.toString(),
                          'usr_customer_track_id': _userData?.data?.customerTrackId.toString(),
                          'leave_id': widget.leaveDetail.leaveId,
                          'comments': _AddDesController.text.toString(),
                          'leave_status': leaveStatus,
                          'token': _userData?.token.toString(),
                        };
                        await leaveViewModel.acceptDeclineLeaveApi(data, context);
                        Utils.hideLoadingDialog(context);
                        Navigator.pop(context, true);
                      }
                    },
                    buttonText: 'SUBMIT',
                    loading: leaveViewModel.loading,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showDocumentDialog(BuildContext context) {
    final url = "https://intrasense.co.uk/app/assets/uploads/medicalcertificate/" +
        widget.leaveDetail.medicalCertificate.replaceAll(r'\', '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Medical Report'),
          content: SingleChildScrollView(  // Wrap content in SingleChildScrollView
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Add loading indicator until the image loads
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
