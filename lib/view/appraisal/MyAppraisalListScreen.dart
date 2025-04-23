import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/view/appraisal/AppraisalDetailScreen.dart';
import 'package:intrasense/view/appraisal/AppraisalRequestScreen.dart';
import '../../model/appraisal/AppraisalListModel.dart';
import '../../model/events/EventListModel.dart';
import '../../model/user_model.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomSearchTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Constants.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/appraisal_view_model.dart';
import '../../view_models/event_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';

import '../manageEvents/AddEventScreen.dart';
import '../manageEvents/EventDetailScreen.dart';

class MyAppraisalListScreen  extends StatefulWidget{
  @override
  _MyAppraisalListScreen createState()=> _MyAppraisalListScreen();
}

class _MyAppraisalListScreen extends State<MyAppraisalListScreen>{
  UserModel? _userData;
  bool _isLoading = false;
  List<AppraisalListModel> appraisalList = [];
  List<AppraisalListModel> filteredList = [];
  TextEditingController searchController = TextEditingController();


  @override
  void dispose() {
    searchController.removeListener(_filterList);
    searchController.dispose();
    super.dispose();
  }

  void _filterList() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = appraisalList
          .where((item) =>
      (item.appraisedByFirstName?.toLowerCase() ?? '').contains(query) ||
          (item.appraisedByLastName?.toLowerCase() ?? '').contains(query) ||
          (item.usrDesignation?.toLowerCase() ?? '').contains(query) ||
          (item.department?.toLowerCase() ?? '').contains(query))
          .toList();
    });
  }

  @override
  void initState() {
    getUserDetails(context);
    searchController.addListener(_filterList);
    super.initState();
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    if (kDebugMode) {
      print(_userData);
    }
    getAppraisalList();
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  void getAppraisalList() async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'deviceToken': Constants.deviceToken,
        'deviceType': Constants.deviceType,
        'token': _userData?.token,
      };
      final appraisalViewModel = Provider.of<AppraisalViewModel>(context, listen: false);
      final response = await appraisalViewModel.getAppraisalListApi(data, context);
      setState(() {
        if (response != null) {
          appraisalList = response.toList();
          filteredList = appraisalList;
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
                  "Appraisal List",
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          children: [
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Appraisal List",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.secondaryOrange,
                                      fontFamily: 'PoppinsMedium'),
                                )),
                            const SizedBox(height: 10),
                            Padding(
                              padding:  const EdgeInsets.only(right: 10.0),
                              child: CustomSearchTextField(
                                controller: searchController,
                                hintText: 'Search',
                                suffixIcon: SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: Image.asset(Images.searchIconOrange),
                                ),
                              ),
                            ),
                          ],
                        )),

                    Expanded(
                      child: filteredList.isEmpty ? const Center(
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
                          : Align(
                        alignment: Alignment.topCenter,
                        child: ListView.separated(
                          padding: const EdgeInsets.only(top: 10.0),
                          itemCount: filteredList.length,
                          separatorBuilder:
                              (BuildContext context, int index) {
                            return const SizedBox(height: 10);
                          },
                          itemBuilder: (context, index) {
                            final item = filteredList[index];
                            return CustomAppraisalListTile(
                              item: item,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                )),
          ),

          if (_userData?.data?.roleTrackId==Constants.roleProjectManager||_userData?.data?.roleTrackId==Constants.roleHR)...{
            Positioned(
              left: 0,
              right: 0,
              bottom: 20.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: CustomElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AppraisalRequestScreen()),
                    );
                    if (result == true) {
                      getAppraisalList();
                    }
                  },
                  buttonText: 'REQUEST APPRAISAL',
                ),
              ),
            )
          }
        ],
      ),
    );
  }

}

class CustomAppraisalListTile extends StatelessWidget {
  final AppraisalListModel item;

  const CustomAppraisalListTile(
      {super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 10,
                            child: Text(
                              "Date ${item.createdOn}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.skyBlueTextColor,
                                fontFamily: 'PoppinsMedium',
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  IconButton(
                                      icon: SizedBox(
                                        height: 20.0,
                                        width: 20.0,
                                        child: Image.asset(Images.eyeIcon),
                                      ),
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AppraisalDetailScreen(
                                                      AppraisalId:item.requestId.toString()
                                                  )),
                                        );
                                        if (result == true) {
                                          // onTaskUpdated();
                                        }
                                      }),
                                ],
                              )),
                        ),

                      /*  Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: SizedBox(
                                      height: 20.0,
                                      width: 20.0,
                                      child: Image.asset(Images.editIcon),
                                    ),
                                    onPressed: () async {
                                      *//* final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Editclients(
                                                      client: item
                                                  )
                                          )
                                      );
                                      if (result == true) {
                                        onUpdate();
                                      }*//*
                                    },
                                  ),
                                ],
                              )),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: SizedBox(
                                      height: 20.0,
                                      width: 20.0,
                                      child: Image.asset(Images.deleteIcon),
                                    ),
                                    onPressed: () {
                                      //deleteClientPopUp(context);

                                    },
                                  ),
                                ],
                              )),
                        )*/

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
                              'Appraisal by',
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
                              "${item.appraisedByFirstName ?? "-"} ${item.appraisedByLastName ?? "-"}",
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
                  const DividerColor(),
                  const SizedBox(height: 10),
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
                                  'Designation',
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
                              item.usrDesignation.toString(),
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
                  const DividerColor(),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
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
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              item.department.toString(),
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
                  const DividerColor(),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              child: const Text(
                                'Self-Rating',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsRegular',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              ((item.selfRating != null ? double.tryParse(item.selfRating.toString()) : 0.0) ?? 0.0)
                                  .toStringAsFixed(1),
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
                  const DividerColor(),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              child: const Text(
                                'Manager-Rating',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsRegular',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              ((item.selfRating != null ? double.tryParse(item.manRating.toString()) : 0.0) ?? 0.0)
                                  .toStringAsFixed(1),
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
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: IgnorePointer(
            ignoring: true,
            child: Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.secondaryOrange.withOpacity(0.1),
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
    );
  }
}

class DividerColor extends StatelessWidget {
  const DividerColor({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: AppColors.dividerColor,
      height: 0.5,
    );
  }
}