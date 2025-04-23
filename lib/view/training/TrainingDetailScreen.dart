import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../res/component/ButtonOrangeBorder.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../Home/HomeScreen.dart';

class TrainingDetailScreen extends StatefulWidget {
  @override
  _TrainingDetailScreen createState() => _TrainingDetailScreen();
}

class _TrainingDetailScreen extends State<TrainingDetailScreen> {
  bool _isDataLoaded = true;

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
                  'Training Details',
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
              bottom: 80,
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
                                                "Training Details-Decision making",
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
                                                  "10 April, 2025",
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
                                                  "2:00 PM - 3:00 PM",
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
                                                    'Instructor',
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
                                                  "Justine Robbins",
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
                                                    'Department',
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
                                                  "Product Development",
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
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  "Conference Hall, Floor 3, Block A",
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
                                                  "Narinder, Pooja, Sumesh, Sarabjit"
                                                  /*meetingDetail.userDetails
                                                      .map((user) =>
                                                  '${user.firstName} ${user.lastName}')
                                                      .join(', ')*/,
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
                            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: GestureDetector(
                              onTap: () async {
                               /* String filePath =
                                await downloadPDF(projectDetail.prQuotation);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PDFView(
                                      filePath: filePath,
                                    ),
                                  ),
                                );*/
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.lightBlue,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 10.0),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Download Document',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.darkBlueTextColor,
                                            fontFamily: 'PoppinsRegular',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Icon(
                                          Icons.download,
                                          color: AppColors.textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: GestureDetector(
                              onTap: () async {
                                /*if (meetingDetail.zoomLink?.isNotEmpty ==
                                    true) {
                                  final url = Uri.parse(
                                      meetingDetail.zoomLink.toString());
                                  _launchUrl(url);
                                }*/
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
                                        "https://demoUrl.com",
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
            Positioned(
              left: 0,
              right: 0,
              bottom: 20.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: ButtonOrangeBorder(
                              onPressed: () async {
                               // declineMeetingPopUp(context);
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
                                //acceptMeetingPopUp(context);
                              },
                              buttonText: 'ACCEPT',
                            ))
                      ],
                    )
                  ],
                ),
              ),
            )
          }
        ],
      ),
    );
  }
}
