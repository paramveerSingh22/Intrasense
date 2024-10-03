import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/model/RoleListModel.dart';
import 'package:intrasense/view/manageTeam/AddNewRole.dart';
import 'package:intrasense/view/manageTeam/EditRoleScreen.dart';
import 'package:intrasense/view_models/teams_view_model.dart';
import '../../main.dart';
import '../../model/user_model.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/UserProvider.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ManageRoleScreen extends StatefulWidget{
  _ManageRoleScreen createState() => _ManageRoleScreen();

}
class _ManageRoleScreen extends State<ManageRoleScreen> with RouteAware{
  UserModel? _userData;
  bool _isLoading = false;
  List<RoleListModel> roleList = [];

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
    getRoleList();
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  void getRoleList() async {
    setLoading(true);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'token': _userData?.token,
      };
      final teamViewModel = Provider.of<TeamsViewModel>(context, listen: false);
      await teamViewModel.getRoleListApi(data, context);
      setState(() {
        roleList= teamViewModel.roleList;
      });
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load Role list')),
      );
    } finally {
      setLoading(false);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    getRoleList();
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
                    padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.grey),
                        suffixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                        EdgeInsets.fromLTRB(12.0, 5.0, 20.0, 5.0),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        child: ListView.separated(
                          itemCount: roleList.length,
                          separatorBuilder:
                              (BuildContext context, int index) {
                            return const SizedBox(height: 10);
                          },
                          itemBuilder: (context, index) {
                            final item = roleList[index];
                            return CustomRoleListTile(item:item);
                          },
                        )),
                  ),

                  const SizedBox(height: 20),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child:   CustomElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddNewRole(),
                          ),
                        );
                      },
                      buttonText: 'Add New Role',
                    ),
                  )
                ],
              )
          ),
        ],
      ),
    );
  }
}

class CustomRoleListTile extends StatelessWidget {
  final RoleListModel item;

  const CustomRoleListTile({
  super.key,
  required this.item
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration:  BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade300, // Border color
            width: 1.0, // Border width
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
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
                            item.roleName.toString(),
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
                                            EditRoleScreen(
                                                roleDetails:item
                                            )));
                              }

                              if (value == 3) {
                                Utils.showConfirmationDialog(
                                  context,
                                  message:
                                  "Are you sure you want to delete this role?",
                                  onConfirm: () {
                                    deleteRoleApi(context, item.roleId);
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
              const Divider(),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: const Text(
                        'additional Notes',
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
                        item.description.toString(),
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
                          'Added On',
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
            ],
          ),
        ),
      ),
    );
  }
}

void deleteRoleApi(BuildContext context, String? roleId) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  await userProvider.fetchUserData();
  Utils.showLoadingDialog(context);
  try {
    Map data = {
      'user_id': userProvider.user?.data?.userId,
      'usr_role_track_id': userProvider.user?.data?.roleTrackId,
      'role_id': roleId,
      'token': userProvider.user?.token,
    };

    final teamViewModel = Provider.of<TeamsViewModel>(context,listen: false);
    await teamViewModel.deleteRoleApi(data, context);

    final manageRoleScreenState = context.findAncestorStateOfType<_ManageRoleScreen>();
    manageRoleScreenState?.getRoleList();

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
