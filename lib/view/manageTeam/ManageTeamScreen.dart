import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/view/manageTeam/AddNewTeam.dart';
import 'package:intrasense/view/manageTeam/EditTeamScreen.dart';

import '../../model/teams/EmployeesListModel.dart';
import '../../model/user_model.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../view_models/teams_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class ManageTeamScreen extends StatefulWidget {
  @override
  _ManageTeamScreenState createState() => _ManageTeamScreenState();
}

class _ManageTeamScreenState extends State<ManageTeamScreen> {
  UserModel? _userData;
  List<EmployeesListModel> employeesList = [];

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
    getEmployeesList();
  }

  Future<void> getEmployeesList() async {
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'customer_id': _userData?.data?.customerTrackId,
        'token': _userData?.token,
      };
      final teamViewModel = Provider.of<TeamsViewModel>(context, listen: false);
      final response = await teamViewModel.getEmployeesListApi(data, context);
      setState(() {
        if (response != null) {
          employeesList = response;
        }
      });
    } catch (error) {
      print('Error fetching employee list: $error');
    }
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
                      itemCount: employeesList.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                            height:
                                10); // List items ke beech mein 10 dp ka gap
                      },
                      itemBuilder: (context, index) {
                        return CustomTeamListTile(item:employeesList[index]);
                      },
                    )),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: CustomElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddNewTeam(),
                          ),
                        );
                      },
                      buttonText: 'Add New Team',
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}

class CustomTeamListTile extends StatelessWidget {
  final EmployeesListModel item;
  const CustomTeamListTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
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
          contentPadding: const EdgeInsets.only(
              bottom: 20, top: 10, left: 20, right: 20),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 10,
                    child: Text(
                      "${item.userFirstName} ${item.userLastName}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryColor,
                        fontFamily: 'PoppinsRegular',
                      ),
                    ),
                  ),
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
                                      builder: (context) => EditTeamScreen()));
                            }
                          }
                        });
                      },
                      child: Image.asset(
                        Images.threeDotsRed,
                        width: 15.0,
                        height: 15.0,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text(
                      'Email',
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
                      item.usrEmail,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontFamily: 'PoppinsRegular',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text(
                      'Mobile',
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
                      item.usrMobile,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontFamily: 'PoppinsRegular',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text(
                      'Designation',
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
                      item.usrDesignation,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontFamily: 'PoppinsRegular',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text(
                      'Location',
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
                      "${item.usrCity}, ${item.usrCountry}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontFamily: 'PoppinsRegular',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
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


