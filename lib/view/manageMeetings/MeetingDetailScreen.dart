import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/model/meeting/MeetingDetailModel.dart';
import 'package:intrasense/res/component/ButtonOrangeBorder.dart';
import 'package:intrasense/res/component/CustomTextField.dart';
import 'package:intrasense/view_models/meeting_view_model.dart';

import '../../model/user_model.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/common_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Home/HomeScreen.dart';

class MeetingDetailScreen extends StatefulWidget {
  final dynamic meetingId;

  const MeetingDetailScreen({Key? key, this.meetingId}) : super(key: key);

  @override
  _MeetingDetailScreen createState() => _MeetingDetailScreen();
}

class _MeetingDetailScreen extends State<MeetingDetailScreen> {
  UserModel? _userData;
  bool _isLoading = false;
  bool _isDataLoaded = false;
  late MeetingDetailModel meetingDetail;
  bool meetingRevertStatus = true;
  List<String> timeZoneList = [];

  @override
  void initState() {
    getUserDetails(context);
    fetchTimeZoneList();
    super.initState();
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    setState(() {});
    if (kDebugMode) {
      print(_userData);
    }
    getMeetingDetailApi();
  }

  void fetchTimeZoneList() async {
    final commonViewModel =
    Provider.of<CommonViewModel>(context, listen: false);
    await commonViewModel.timeZoneListApi(context);
    setState(() {
      timeZoneList = commonViewModel.timeZoneList;
    });
  }

  void getMeetingDetailApi() async {
    Utils.showLoadingDialog(context);
    setLoading(true);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_customer_track_id': _userData?.data?.customerTrackId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'meeting_id': widget.meetingId,
        'token': _userData?.token,
      };
      final meetingViewModel =
          Provider.of<MeetingViewModel>(context, listen: false);
      final response =
          await meetingViewModel.getMeetingDetailApi(data, context);
      if (response != null) {
        setState(() {
          meetingDetail = response[0];
          _isDataLoaded = true;

          var user = meetingDetail.userDetails
              .firstWhere((result) => result.userId == _userData?.data?.userId);
          if (user.meetingStatus == "1" ||user.meetingStatus == "2") {
            meetingRevertStatus = false;
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
      Utils.hideLoadingDialog(context);
    }
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  String getPriority(String meetingPriority) {
    switch (meetingPriority) {
      case "1":
        return 'High Priority';
      case "2":
        return 'Important';
      case "3":
        return 'Low Priority';
      default:
        return 'Low Priority';
    }
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void acceptMeetingPopUp(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: AppColors.secondaryOrange.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, bottom: 12.0, left: 10.0, right: 15.0),
                    // Adjust the padding value as needed
                    child: Text(
                      'Accept Meeting',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryOrange,
                        fontFamily: 'PoppinsMedium',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              Images.successTick,
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    meetingDetail.meetingTitle.toString(),
                    style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textColor,
                        fontFamily: 'PoppinsMedium'),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Meeting Start Time:\n${meetingDetail.meetingDate} at ${meetingDetail.meetingTime}, ${meetingDetail.meetingTimeZone}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.black,
                        fontFamily: 'PoppinsRegular',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Expanded(
                      flex: 10,
                      child: CustomElevatedButton(
                        onPressed: () {
                          meetingRevertApi("1");
                        },
                        buttonText: 'ACCEPT',
                      )),
                  Expanded(flex: 1, child: Container()),
                  Expanded(
                      flex: 10,
                      child: ButtonOrangeBorder(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        buttonText: 'CANCEL',
                      ))
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        );
      },
    );
  }

  void declineMeetingPopUp(BuildContext context) {
    final TextEditingController _declineReasonController =
        TextEditingController();
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
        isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
        child:   Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: AppColors.secondaryOrange.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, bottom: 12.0, left: 10.0, right: 15.0),
                    // Adjust the padding value as needed
                    child: Text(
                      'Decline Meeting',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryOrange,
                        fontFamily: 'PoppinsMedium',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding:EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Reason for decline",
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextField(
                        hintText: "Enter decline reason",
                        controller: _declineReasonController,
                        minLines: 4,
                        maxLines: 4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Expanded(
                      flex: 10,
                      child: CustomElevatedButton(
                        onPressed: () {
                          setLoading(true);
                          try {
                            Map data = {
                              'user_id': _userData?.data?.userId,
                              'usr_customer_track_id': _userData?.data?.customerTrackId,
                              'usr_role_track_id': _userData?.data?.roleTrackId,
                              'meeting_id': widget.meetingId,
                              'meeting_status': "2",
                              'user_name': meetingDetail.firstName.toString() + " " + meetingDetail.lastName.toString(),
                              'meeting_sender_emailid': meetingDetail.userEmail,
                              'meeting_date': meetingDetail.meetingDate,
                              'meeting_time': meetingDetail.meetingTime,
                              'token': _userData?.token,
                              'meeting_decline_Reason': _declineReasonController.text.toString()

                            };
                            final meetingViewModel =
                            Provider.of<MeetingViewModel>(context, listen: false);
                            meetingViewModel.meetingRevertApi(data, context,"2");
                          } catch (error, stackTrace) {
                            if (kDebugMode) {
                              print(error);
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Failed to load client list')),
                            );
                          } finally {
                            Utils.hideLoadingDialog(context);
                          }
                        },
                        buttonText: 'SUBMIT',
                      )),
                  Expanded(flex: 1, child: Container()),
                  Expanded(
                      flex: 10,
                      child: ButtonOrangeBorder(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        buttonText: 'CANCEL',
                      ))
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ));
      },
    );
  }

  void rescheduleMeetingPopUp(BuildContext context) {
    final TextEditingController _reschduleDateController = TextEditingController();
    final TextEditingController _reschduleTimeController = TextEditingController();
    String? rescheduleTimeZoneValue;
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
            child:   Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: AppColors.secondaryOrange.withOpacity(0.1),
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, bottom: 12.0, left: 10.0, right: 15.0),
                        // Adjust the padding value as needed
                        child: Text(
                          'Reschedule Meeting',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.secondaryOrange,
                            fontFamily: 'PoppinsMedium',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
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
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 10,
                                child: CustomTextField(
                                  controller: _reschduleDateController,
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
                                        _reschduleDateController.text = formattedDate;
                                      });
                                    }
                                  },
                                )),
                            Expanded(flex: 1, child: Container()),
                            Expanded(
                                flex: 10,
                                child: CustomTextField(
                                  controller: _reschduleTimeController,
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
                                        _reschduleTimeController.text = formattedTime;
                                      });
                                    }
                                  },
                                ))
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      const SizedBox(height: 15),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Time Zone',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium'),
                            )),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CustomDropdown(
                          value: rescheduleTimeZoneValue,
                          items: timeZoneList,
                          onChanged: (String? newValue) {
                            setState(() {
                              rescheduleTimeZoneValue = newValue;
                            });
                          },
                          hint: 'Select an option',
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 10,
                                child: CustomElevatedButton(
                                  onPressed: () {
                                    setLoading(true);
                                    try {
                                      Map data = {
                                        'user_id': _userData?.data?.userId,
                                        'usr_customer_track_id': _userData?.data?.customerTrackId,
                                        'usr_role_track_id': _userData?.data?.roleTrackId,
                                        'meeting_id': widget.meetingId,
                                        'meeting_status': "3",
                                        'user_name': meetingDetail.firstName.toString() + " " + meetingDetail.lastName.toString(),
                                        'meeting_sender_emailid': meetingDetail.userEmail,
                                        'meeting_date': meetingDetail.meetingDate,
                                        'meeting_time': meetingDetail.meetingTime,
                                        'token': _userData?.token,
                                        'meeting_reschedule_date': _reschduleDateController.text.toString(),
                                        'meeting_reschedule_time': _reschduleTimeController.text.toString(),
                                        'meeting_reschedule_timezone': rescheduleTimeZoneValue

                                      };
                                      final meetingViewModel = Provider.of<MeetingViewModel>(context, listen: false);
                                      meetingViewModel.meetingRevertApi(data, context,"3");
                                    } catch (error, stackTrace) {
                                      if (kDebugMode) {
                                        print(error);
                                      }
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Failed to load client list')),
                                      );
                                    } finally {
                                      Utils.hideLoadingDialog(context);
                                    }
                                  },
                                  buttonText: 'SUBMIT',
                                )),
                            Expanded(flex: 1, child: Container()),
                            Expanded(
                                flex: 10,
                                child: ButtonOrangeBorder(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  buttonText: 'CANCEL',
                                ))
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ));
      },
    );
  }

  void cancelMeetingPopUp(BuildContext context) {
    final meetingViewModel = Provider.of<MeetingViewModel>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: AppColors.secondaryOrange.withOpacity(0.1),
              padding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, bottom: 12.0, left: 10.0, right: 15.0),
                    // Adjust the padding value as needed
                    child: Text(
                      'Cancel Meeting',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryOrange,
                        fontFamily: 'PoppinsMedium',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              Images.successTick,
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Cancel Meeting!',
                    style: TextStyle(
                        fontSize: 16,
                        color: AppColors.skyBlueTextColor,
                        fontFamily: 'PoppinsRegular'),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Do you really want to close meeting?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.black,
                        fontFamily: 'PoppinsRegular',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Expanded(
                      flex: 10,
                      child: ButtonOrangeBorder(
                        onPressed: () {
                          setLoading(true);
                          try {
                            Map data = {
                              'user_id': _userData?.data?.userId,
                              'usr_customer_track_id': _userData?.data?.customerTrackId,
                              'usr_role_track_id': _userData?.data?.roleTrackId,
                              'meeting_id': widget.meetingId,
                              'meeting_status': "1",
                              'user_name': "${meetingDetail.firstName} ${meetingDetail.lastName}",
                              'meeting_date': meetingDetail.meetingDate,
                              'meeting_time': meetingDetail.meetingTime,
                              'token': _userData?.token,
                            };

                            meetingViewModel.meetingCancelApi(data, context);

                          } catch (error, stackTrace) {
                            if (kDebugMode) {
                              print(error);
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Failed to load client list')),
                            );
                          } finally {
                            Utils.hideLoadingDialog(context);
                          }
                        },
                        buttonText: 'YES',
                        loading: meetingViewModel.loading,
                      )),
                  Expanded(flex: 1, child: Container()),
                  Expanded(
                      flex: 10,
                      child: CustomElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        buttonText: 'NO',
                      ))
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  'Meeting Details',
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
          if (_isDataLoaded) ...{
            Positioned(
              top: 110,
              left: 0,
              right: 0,
              bottom: 120,
              // Adjust the bottom to leave space for the button
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
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
                                child: Transform.translate(
                                  offset: const Offset(0, -10),
                                  // This will move the content up by 10 dp
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.only(
                                        left: 0, right: 0, bottom: 0, top: 0),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        IgnorePointer(
                                          ignoring: true,
                                          child: Container(
                                            width: double.infinity,
                                            // Set width to match parent
                                            decoration: BoxDecoration(
                                              color: AppColors.secondaryOrange
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              // Adjusted padding
                                              child: Text(
                                                meetingDetail.meetingTitle
                                                    .toString(),
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.primaryColor,
                                                  fontFamily: 'PoppinsRegular',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  child: const Text(
                                                    'Meeting ID',
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
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  meetingDetail.meetingId
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.textColor,
                                                    fontFamily:
                                                        'PoppinsRegular',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const DividerColor(),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 10),
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
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  meetingDetail.meetingDate
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.textColor,
                                                    fontFamily:
                                                        'PoppinsRegular',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const DividerColor(),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  child: const Text(
                                                    'Time',
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
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  meetingDetail.meetingTime
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.textColor,
                                                    fontFamily:
                                                        'PoppinsRegular',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const DividerColor(),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  child: const Text(
                                                    'Priority',
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
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  getPriority(meetingDetail
                                                      .meetingPriority
                                                      .toString()),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.textColor,
                                                    fontFamily:
                                                        'PoppinsRegular',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const DividerColor(),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  child: const Text(
                                                    'Organised by',
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
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  meetingDetail.createdBy
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.textColor,
                                                    fontFamily:
                                                        'PoppinsRegular',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const DividerColor(),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Container(
                                                      child: const Text(
                                                        'Purpose',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: AppColors
                                                              .textColor,
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
                                                  meetingDetail.meetingTitle
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.textColor,
                                                    fontFamily:
                                                        'PoppinsRegular',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const DividerColor(),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Container(
                                                      child: const Text(
                                                        'Attendees',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: AppColors
                                                              .textColor,
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
                                                  meetingDetail.userDetails
                                                      .map((user) =>
                                                          '${user.firstName} ${user.lastName}')
                                                      .join(', '),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.textColor,
                                                    fontFamily:
                                                        'PoppinsRegular',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: GestureDetector(
                              onTap: () async {
                                if (meetingDetail.zoomLink?.isNotEmpty ==
                                    true) {
                                  final url = Uri.parse(
                                      meetingDetail.zoomLink.toString());
                                  _launchUrl(url);
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.lightBlue,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(width: 10.0),
                                      const Text(
                                        'Join Meeting Link',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textColor,
                                          fontFamily: 'PoppinsMedium',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Text(
                                        meetingDetail.zoomLink.toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.skyBlueTextColor,
                                          fontFamily: 'PoppinsRegular',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (meetingRevertStatus) ...{
              Positioned(
                left: 0,
                right: 0,
                bottom: 20.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [

                      if(meetingDetail.createdBy==_userData?.data?.userId)...{
                        CustomElevatedButton(
                          onPressed: () async {
                            cancelMeetingPopUp(context);
                          },
                          buttonText: 'CLOSE',
                        )
                      }

                      else...{
                      ButtonOrangeBorder(
                        onPressed: () async {
                          rescheduleMeetingPopUp(context);
                        },
                        buttonText: 'REQUEST TO RESCHEDULE',
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: ButtonOrangeBorder(
                                onPressed: () async {
                                  declineMeetingPopUp(context);
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
                                  acceptMeetingPopUp(context);
                                },
                                buttonText: 'ACCEPT',
                              ))
                        ],
                      )}
                    ],
                  ),
                ),
              )
            }
          }
        ],
      ),
    );
  }

  void meetingRevertApi(String meetingStatus) async {
    setLoading(true);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_customer_track_id': _userData?.data?.customerTrackId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'meeting_id': widget.meetingId,
        'meeting_status': meetingStatus,
        'user_name': "${meetingDetail.firstName} ${meetingDetail.lastName}",
        'meeting_sender_emailid': meetingDetail.userEmail,
        'meeting_date': meetingDetail.meetingDate,
        'meeting_time': meetingDetail.meetingTime,
        'token': _userData?.token,

      };
      final meetingViewModel =
          Provider.of<MeetingViewModel>(context, listen: false);
      meetingViewModel.meetingRevertApi(data, context,meetingStatus);
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load client list')),
      );
    } finally {
      Utils.hideLoadingDialog(context);
    }
  }
}
