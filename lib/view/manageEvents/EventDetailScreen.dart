import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/utils/Utils.dart';
import 'package:intrasense/view_models/event_view_model.dart';

import '../../model/user_model.dart';
import '../../res/component/ButtonOrangeBorder.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../utils/AppColors.dart';
import '../../utils/Constants.dart';
import '../../utils/Images.dart';
import '../../view_models/user_view_model.dart';
import '../Home/HomeScreen.dart';
import 'package:provider/provider.dart';

class EventDetailScreen extends StatefulWidget {
  final dynamic eventDetail;

  const EventDetailScreen({Key? key, this.eventDetail}) : super(key: key);

  @override
  _EventDetailScreen createState() => _EventDetailScreen();
}

class _EventDetailScreen extends State<EventDetailScreen> {
  UserModel? _userData;
  bool _isLoading = false;

  @override
  void initState() {
    getUserDetails(context);
    super.initState();
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

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
                  'Event Detail',
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
                                'Event Detail',
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
                                                  widget.eventDetail.title,
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
                                                  'Title',
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
                                                  widget.eventDetail.title,
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
                                            ),
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                  widget.eventDetail.eventDate,
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
                                                )),
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                  widget.eventDetail.timeFrom +
                                                      "-" +
                                                      widget.eventDetail.timeTo,
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
                                                    'Venue',
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
                                                  widget.eventDetail.venue,
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
                                                    'Organiser',
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
                                                  widget.eventDetail
                                                          .organiserFirstName +
                                                      " " +
                                                      widget.eventDetail
                                                          .organiserLastName,
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
                                                    'Map Link',
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
                                                      .eventDetail.googleMapUrl,
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
                                      if(widget.eventDetail.eventStatus!=null)...{
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
                                                  widget.eventDetail.eventStatus == "1" ? "Accept" : "Declined",
                                                  style:  TextStyle(
                                                    fontSize: 14,
                                                    color: widget.eventDetail.eventStatus == "1"
                                                        ? Colors.green   // Green for "Accept"
                                                        : Colors.red,
                                                    fontFamily: 'PoppinsRegular',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ))
                                          ],
                                        ),
                                      )}
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.eventDetail.eventStatus == null) ...{
            Positioned(
              left: 0,
              right: 0,
              bottom: 0, // Position button at the bottom of the screen
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: ButtonOrangeBorder(
                          onPressed: () async {
                            acceptEventPopUp(context, "2");
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
                            acceptEventPopUp(context, "1");
                          },
                          buttonText: 'ACCEPT',
                        ))
                  ],
                ),
              ),
            )
          }
        ],
      ),
    );
  }

  void acceptEventPopUp(BuildContext context, String eventStatus) {
    final eventViewModel = Provider.of<EventViewModel>(context, listen: false);
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, bottom: 12.0, left: 10.0, right: 15.0),
                    // Adjust the padding value as needed
                    child: Text(
                      eventStatus == "1" ? "Accept Event" : "Decline Event",
                      style: const TextStyle(
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
              Images.deleteIconAlert,
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
                    'Are you sure!',
                    style: TextStyle(
                        fontSize: 16,
                        color: AppColors.skyBlueTextColor,
                        fontFamily: 'PoppinsRegular'),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "you wan't be able to revert this!",
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
                          eventRevertApi(eventStatus);
                        },
                        buttonText: 'YES',
                        loading: eventViewModel.loading,
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

  void eventRevertApi(String eventStatus) async {
    setLoading(true);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'event_id': widget.eventDetail.eventId,
        'userFullname':
            "${_userData?.data?.firstName} ${_userData?.data?.lastName}",
        'event_status': eventStatus,
        'deviceToken': Constants.deviceToken,
        'deviceType': Constants.deviceType,
        'token': _userData?.token,
      };
      final eventViewModel =
          Provider.of<EventViewModel>(context, listen: false);
      eventViewModel.eventRevertApi(data, context, eventStatus);
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
