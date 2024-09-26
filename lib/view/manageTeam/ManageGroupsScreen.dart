import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/model/teams/GroupListModel.dart';
import 'package:intrasense/view/manageTeam/AddNewGroup.dart';
import 'package:intrasense/view/manageTeam/EditGroupScreen.dart';
import 'package:intrasense/view/manageTeam/ManageRoleScreen.dart';
import '../../model/user_model.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/UserProvider.dart';
import '../../view_models/teams_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';

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
    setLoading(true);
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
        setLoading(false);
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching employee list: $error');
      }
    } finally {
      setLoading(false);
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
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.grey),
                        suffixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1.0,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.fromLTRB(12.0, 5.0, 50.0, 5.0),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: groupList.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: 10);
                      },
                      itemBuilder: (context, index) {
                        final item = groupList[index];
                        return CustomGroupListTile(item: item);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: CustomElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddNewGroup(),
                          ),
                        );
                      },
                      buttonText: 'Add New Group',
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}

class CustomGroupListTile extends StatelessWidget {
  final GroupListModel item;

  const CustomGroupListTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.only(bottom: 20, top: 10, left: 20, right: 20),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: Container(
                          child: Text(
                        item.groupName.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsRegular',
                        ),
                      ))),
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTapDown: (TapDownDetails details) {
                          showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(
                              details.globalPosition.dx,
                              details.globalPosition.dy,
                              details.globalPosition.dx,
                              details.globalPosition.dy + 20,
                            ),
                            items: [
                              const PopupMenuItem(
                                value: 1,
                                child: Text('View'),
                              ),
                              const PopupMenuItem(
                                value: 2,
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem(
                                value: 3,
                                child: Text('Delete'),
                              ),
                            ],
                          ).then((value) {
                            if (value != null) {
                              if (value == 2) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditGroupScreen(
                                                groupDetails:item
                                            )));
                              }
                              else if (value == 3) {
                                Utils.showConfirmationDialog(
                                  context,
                                  message:
                                  "Are you sure you want to delete this group?",
                                  onConfirm: () {
                                    deleteGroupApi(context, item.groupId);
                                  },
                                );
                              }
                            }
                          });
                        },
                        child: Image.asset(
                          Images.threeDotsRed,
                          width: 15.0,
                          height: 15.0,
                        ),
                      ))
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(
                    flex: 1,
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
                  Expanded(
                      flex: 1,
                      child: Text(
                        item.comments.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular',
                          fontWeight: FontWeight.w500,
                        ),
                      ))
                ],
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: const Text(
                          'Added on',
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
                        item.addedOn.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular',
                          fontWeight: FontWeight.w500,
                        ),
                      ))
                ],
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              Row(
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
                      )),
                  Expanded(
                      flex: 1,
                      child: Text(
                        item.addedByName.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular',
                          fontWeight: FontWeight.w500,
                        ),
                      ))
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

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

    final teamViewModel = Provider.of<TeamsViewModel>(context,listen: false);
    await teamViewModel.deleteGroupApi(data, context);

    final manageGroupScreenState = context.findAncestorStateOfType<_ManageGroupScreen>();
    manageGroupScreenState?.getGroupList();

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
