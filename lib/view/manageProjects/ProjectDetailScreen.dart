import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/model/projects/ProjectDetailModel.dart';
import 'package:intrasense/utils/Utils.dart';
import '../../model/user_model.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../view_models/projects_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ProjectDetailScreen extends StatefulWidget {
  final dynamic projectId;

  const ProjectDetailScreen({Key? key, this.projectId}) : super(key: key);

  @override
  _ProjectDetailScreen createState() => _ProjectDetailScreen();
}

class _ProjectDetailScreen extends State<ProjectDetailScreen> {
  bool _isLoading = false;
  bool _isDataLoaded = false;
  UserModel? _userData;
  late ProjectDetailModel projectDetail;

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.projectId != null) {
      getUserDetails(context);
    }
  }

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    getProjectDetailApi();
    if (widget.projectId != null) {
      getProjectDetailApi();
    }
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getProjectDetailApi() async {
    Utils.showLoadingDialog(context);
    setLoading(true);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_customer_track_id': _userData?.data?.customerTrackId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'project_id': widget.projectId,
        'token': _userData?.token,
      };
      final projectViewModel =
          Provider.of<ProjectsViewModel>(context, listen: false);
      final response =
          await projectViewModel.getProjectDetailApi(data, context);
      if (response != null) {
        setState(() {
          projectDetail = response[0];
          _isDataLoaded= true;
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

  Future<String> downloadPDF(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/file.pdf');
      await file.writeAsBytes(response.bodyBytes);
      return file.path;
    } else {
      throw Exception('Failed to load PDF');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  "Project Details",
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
            top: 110.0,
            left: 0.0,
            right: 0.0,
            bottom: 70.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(_isDataLoaded)...{
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
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Title',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textColor,
                                        fontFamily: 'PoppinsRegular',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                      flex: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textColor,
                                          fontFamily: 'PoppinsMedium',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        projectDetail.prName.toString(),
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
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Short Name',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textColor,
                                        fontFamily: 'PoppinsRegular',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                      flex: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textColor,
                                          fontFamily: 'PoppinsMedium',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        projectDetail.prShortName.toString(),
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
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Client',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textColor,
                                        fontFamily: 'PoppinsRegular',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                      flex: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textColor,
                                          fontFamily: 'PoppinsMedium',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        projectDetail.clientName.toString(),
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
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Sub-Client',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textColor,
                                        fontFamily: 'PoppinsRegular',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                      flex: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textColor,
                                          fontFamily: 'PoppinsMedium',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        projectDetail.clientName.toString(),
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
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Expanded(
                                    flex: 3,
                                    child: Text(
                                      'P.O Number',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textColor,
                                        fontFamily: 'PoppinsRegular',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                      flex: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textColor,
                                          fontFamily: 'PoppinsMedium',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        projectDetail.prPoNumber.toString(),
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
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Client Contact',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textColor,
                                        fontFamily: 'PoppinsRegular',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                      flex: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textColor,
                                          fontFamily: 'PoppinsMedium',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        projectDetail.prContactNumber.toString(),
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
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Start Date',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textColor,
                                        fontFamily: 'PoppinsRegular',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                      flex: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textColor,
                                          fontFamily: 'PoppinsMedium',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        projectDetail.prStartDate.toString(),
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
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Due Date',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textColor,
                                        fontFamily: 'PoppinsRegular',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                      flex: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textColor,
                                          fontFamily: 'PoppinsMedium',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        projectDetail.prEndDate.toString(),
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
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Description',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textColor,
                                        fontFamily: 'PoppinsRegular',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                      flex: 1,
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textColor,
                                          fontFamily: 'PoppinsMedium',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        projectDetail.prComments.toString(),
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
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: GestureDetector(
                          onTap: () async {
                            String filePath =
                            await downloadPDF(projectDetail.prQuotation);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PDFView(
                                  filePath: filePath,
                                ),
                              ),
                            );
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
                      const SizedBox(height: 20),
                      const Text(
                        '   PROJECT ACTIVITIES',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      projectDetail.activityType.isEmpty
                          ? const Center(
                        child: Text(
                          'No data found',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textColor,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'PoppinsMedium',
                          ),
                        ),
                      )
                          : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: projectDetail.activityType.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 10);
                        },
                        itemBuilder: (context, index) {
                          final item = projectDetail.activityType[index];
                          return CustomActivityListTile(
                            item: item,
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    }
                  ],
                ),
              ),
            ),
          )


        ],
      ),
    );
  }
}

class CustomActivityListTile extends StatelessWidget {
  final ActivityType item;

  const CustomActivityListTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              color: Colors.white,
              border: Border.all(
                color: AppColors.secondaryOrange,
                width: 1.0,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.only(
                bottom: 10,
                top: 0,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: const Text(
                              'Activity',
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
                              item.categoryName,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
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
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Text(
                              item.activityHours,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                child: const Text(
                                  'Amount',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                    fontFamily: 'PoppinsRegular',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )),
                        ),
                        Expanded(
                            flex: 1,
                            child: Text(
                              item.activityAmount,
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
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
