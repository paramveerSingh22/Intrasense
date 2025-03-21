import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/model/teams/GroupListModel.dart';
import 'package:intrasense/view/manageTeam/AddNewGroup.dart';
import 'package:intrasense/view/manageTeam/EditGroupScreen.dart';
import 'package:intrasense/view/manageTeam/GroupDetailScreen.dart';
import 'package:intrasense/view/manageTeam/ManageRoleScreen.dart';
import '../../model/user_model.dart';
import '../../res/component/ButtonOrangeBorder.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/UserProvider.dart';
import '../../view_models/teams_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';

import '../Home/HomeScreen.dart';

class ManageGroupScreen extends StatefulWidget {
  @override
  _ManageGroupScreen createState() => _ManageGroupScreen();
}

class _ManageGroupScreen extends State<ManageGroupScreen> {
  UserModel? _userData;
  bool _isLoading = false;
  List<GroupListModel> groupList = [];

  @override
  void initState() {
    super.initState();
    getUserDetails(context);
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    if (kDebugMode) {
      print(_userData);
    }
    getGroupList();
  }

  Future<void> getGroupList() async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'usr_customer_track_id': _userData?.data?.customerTrackId,
        'token': _userData?.token,
      };
      final teamViewModel = Provider.of<TeamsViewModel>(context, listen: false);
      final response = await teamViewModel.getGroupListApi(data, context);
      setState(() {
        if (response != null) {
          groupList = response;
        }
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching employee list: $error');
      }
    } finally {
      Utils.hideLoadingDialog(context);
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
                  "Manage Groups",
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
                        child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Manage Groups",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.secondaryOrange,
                                  fontFamily: 'PoppinsMedium'),
                            ))),
                    Expanded(
                        child: groupList.isEmpty
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
                            : Align(
                                alignment: Alignment.topCenter,
                                child: ListView.separated(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  itemCount: groupList.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const SizedBox(height: 10);
                                  },
                                  itemBuilder: (context, index) {
                                    final item = groupList[index];
                                    return CustomGroupListTile(
                                        item: item,
                                        onListUpdated: () {
                                          getGroupList();
                                        });
                                  },
                                ),
                              )),
                  ],
                )),
          ),
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
                    MaterialPageRoute(builder: (context) => AddNewGroup()),
                  );
                  if (result == true) {
                    getGroupList();
                  }
                },
                buttonText: 'CREATE NEW GROUP',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomGroupListTile extends StatelessWidget {
  final GroupListModel item;
  final VoidCallback onListUpdated;

  const CustomGroupListTile(
      {super.key, required this.item, required this.onListUpdated});

  void deleteGroupApi(BuildContext context, String? groupId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUserData();
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': userProvider.user?.data?.userId,
        'usr_role_track_id': userProvider.user?.data?.roleTrackId,
        'usr_customer_track_id': userProvider.user?.data?.customerTrackId,
        'group_id': groupId,
        'token': userProvider.user?.token,
      };

      final teamViewModel = Provider.of<TeamsViewModel>(context, listen: false);
      await teamViewModel.deleteGroupApi(data, context);
      onListUpdated();

      Utils.hideLoadingDialog(context);
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete this role')),
      );
      Utils.hideLoadingDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    void deleteGroupPopUp(BuildContext context) {
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
                        'Delete Group',
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
                            deleteGroupApi(context, item.groupId);
                          },
                          buttonText: 'YES',
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
                              item.groupName.toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.darkBlueTextColor,
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
                                                    GroupDetailScreen(
                                                        groupDetails: item)));
                                        if (result == true) {
                                          onListUpdated();
                                        }

                                      }),
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
                                      child: Image.asset(Images.editIcon),
                                    ),
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditGroupScreen(
                                                      groupDetails: item)));
                                      if (result == true) {
                                        onListUpdated();
                                      }
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
                                      deleteGroupPopUp(context);
                                    },
                                  ),
                                ],
                              )),
                        )
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
                              'Description',
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
                              item.comments.toString(),
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
                              'Added On',
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
                              item.addedOn.toString(),
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
                              'Added by',
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
                              item.addedByName.toString(),
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
