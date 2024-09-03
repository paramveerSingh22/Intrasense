import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intrasense/utils/AppColors.dart';
import 'package:intrasense/utils/Images.dart';
import 'package:intrasense/view/Home/DashboardScreen.dart';
import 'package:intrasense/view/appraisal/AppraisalList.dart';
import 'package:intrasense/view/clientList/ClientListDashboard.dart';
import 'package:intrasense/view/leaves/MyLeavesList.dart';
import 'package:intrasense/view/manageExpenses/MyExpensesList.dart';
import 'package:intrasense/view/manageMeetings/MyMeetingsList.dart';
import 'package:intrasense/view/manageDocuments/MyDocumentsList.dart';
import 'package:intrasense/view/manageProjects/MyProjectListScreen.dart';
import 'package:intrasense/view/manageTeam/ManageGroupsScreen.dart';
import 'package:intrasense/view/manageTeam/ManageRoleScreen.dart';
import 'package:intrasense/view/manageTeam/ManageTeamScreen.dart';
import 'package:intrasense/view/myTask/MyTaskList.dart';
import 'package:intrasense/view/myTimeSheet/MyTimeSheetList.dart';
import 'package:intrasense/view/support/SupportList.dart';

import '../../model/user_model.dart';
import '../../view_models/user_view_model.dart';
import '../clientList/ClientListDashboard1.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName="Param1";

  @override
  void initState() {
    super.initState();
    getUserName(context);
  }


  int _selectedIndex = 0;

  List<Widget> _pages = [
    Dashboardscreen(),
    MyTaskList(),
    Mytimesheetlist(),
    Clientlistdashboard1(),
    ManageTeamScreen(),
    ManageRoleScreen(),
    ManageGroupScreen(),
    MyProjectListScreen(),
    MyDocumentList(),
    MyMeetingslist(),
    MyExpenseList(),
    MyLeavesList(),
    AppraisalList(),
    //self Apprailsel
    //Training
    //Reports
    SupportList(),
    // knowlwdgeBased
  ];

  static const List<String> _titles = <String>[
    'Home',
    'My Tasks List',
    'My TimeSheet',
    'Client List',
    'Manage Team',
    'Manage Role',
    'Manage Groups',
    'My Projects',
    'My Documents',
    'Manage Meetings',
    'Manage Expenses',
    'My Leaves',
    'Appraisal List',
    'Support',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop(); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: TextStyle(color: Colors.white,
            fontSize: 18
          ),

        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Drawer icon color set to white
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Images.headerBg),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
            decoration: BoxDecoration(color: AppColors.white),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage("assets/profile_image.jpg"),
                        // Replace with actual image path
                        radius: 30,
                      ),
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Welcome', // Replace with actual user's name
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'PoppinsRegular',
                            ),
                          ),
                          Text(
                              userName ?? "Loading...", // Replace with additional text
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'PoppinsRegular',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Image.asset(
                    Images.clients,
                    width: 20,
                    height: 20,
                  ),
                  title: const Text('DashBoard',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsRegular',
                          fontSize: 15)),
                  onTap: () {
                    _onItemTapped(0);

                    /* Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  Dashboardscreen()
                      ),
                    );*/

                    // Navigator.pop(context);
                  },
                ),
                Container(
                  child: Theme(
                      data: ThemeData(
                        dividerColor: AppColors
                            .white, // Set the default divider color for the theme
                      ),
                      child: ExpansionTile(
                        leading: Image.asset(
                          Images.myTask,
                          width: 20,
                          height: 20,
                        ),
                        title: const Text('Manage tasks',
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontFamily: 'PoppinsRegular',
                                fontSize: 15)),
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: ListTile(
                                leading: const Text('•',
                                    style: TextStyle(
                                        color: AppColors.secondaryOrange,
                                        fontFamily: 'PoppinsRegular',
                                        fontSize: 15)),
                                title: const Text('My Tasks',
                                    style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontFamily: 'PoppinsRegular',
                                        fontSize: 15)),
                                onTap: () {
                                  _onItemTapped(1);
                                },
                              )),

                          Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: ListTile(
                                leading: const Text('•',
                                    style: TextStyle(
                                        color: AppColors.secondaryOrange,
                                        fontFamily: 'PoppinsRegular',
                                        fontSize: 15)),
                                title: const Text('My Timesheet',
                                    style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontFamily: 'PoppinsRegular',
                                        fontSize: 15)),
                                onTap: () {
                                  _onItemTapped(2);
                                },
                              ))

                          // Add more ListTiles as needed
                        ],
                      )),
                ),
                ListTile(
                  leading: Image.asset(
                    Images.clients,
                    width: 20,
                    height: 20,
                  ),
                  title: const Text('Clients',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsRegular',
                          fontSize: 15)),
                  onTap: () {
                    _onItemTapped(3);
                  },
                ),
                Container(
                    child: Theme(
                        data: ThemeData(
                          dividerColor: AppColors
                              .white, // Set the default divider color for the theme
                        ),
                        child: ExpansionTile(
                          leading: Image.asset(
                            Images.myTask,
                            width: 20,
                            height: 20,
                          ),
                          title: const Text('Manage Teams',
                              style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontFamily: 'PoppinsRegular',
                                  fontSize: 15)),
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 40.0),
                                child: ListTile(
                                  leading: const Text('•',
                                      style: TextStyle(
                                          color: AppColors.secondaryOrange,
                                          fontFamily: 'PoppinsRegular',
                                          fontSize: 15)),
                                  title: const Text('Manage Team',
                                      style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontFamily: 'PoppinsRegular',
                                          fontSize: 15)),
                                  onTap: () {
                                    _onItemTapped(4);
                                  },
                                )),

                            Padding(
                                padding: const EdgeInsets.only(left: 40.0),
                                child: ListTile(
                                  leading: const Text('•',
                                      style: TextStyle(
                                          color: AppColors.secondaryOrange,
                                          fontFamily: 'PoppinsRegular',
                                          fontSize: 15)),
                                  title: const Text('Manage Role',
                                      style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontFamily: 'PoppinsRegular',
                                          fontSize: 15)),
                                  onTap: () {
                                    _onItemTapped(5);
                                  },
                                )),

                            Padding(
                                padding: const EdgeInsets.only(left: 40.0),
                                child: ListTile(
                                  leading: const Text('•',
                                      style: TextStyle(
                                          color: AppColors.secondaryOrange,
                                          fontFamily: 'PoppinsRegular',
                                          fontSize: 15)),
                                  title: const Text('Manage Groups',
                                      style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontFamily: 'PoppinsRegular',
                                          fontSize: 15)),
                                  onTap: () {
                                    _onItemTapped(6);
                                  },
                                ))

                            // Add more ListTiles as needed
                          ],
                        ))),
                ListTile(
                  leading: Image.asset(
                    Images.manageProducts,
                    width: 20,
                    height: 20,
                  ),
                  title: const Text('Manage Projects',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsRegular',
                          fontSize: 15)),
                  onTap: () {
                    _onItemTapped(7);
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    Images.manageDocuments,
                    width: 20,
                    height: 20,
                  ),
                  title: const Text('Manage Documents',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsRegular',
                          fontSize: 15)),
                  onTap: () {
                    _onItemTapped(8);
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    Images.training,
                    width: 20,
                    height: 20,
                  ),
                  title: const Text('Manage Meetings',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsRegular',
                          fontSize: 15)),
                  onTap: () {
                    _onItemTapped(9);
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    Images.manageExpense,
                    width: 20,
                    height: 20,
                  ),
                  title: const Text('Manage Expenses',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsRegular',
                          fontSize: 15)),
                  onTap: () {
                    _onItemTapped(10);
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    Images.myLeaves,
                    width: 20,
                    height: 20,
                  ),
                  title: const Text('My Leaves',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsRegular',
                          fontSize: 15)),
                  onTap: () {
                    _onItemTapped(11);
                  },
                ),
                Container(
                  child: Theme(
                      data: ThemeData(
                        dividerColor: AppColors
                            .white, // Set the default divider color for the theme
                      ),
                      child: ExpansionTile(
                        leading: Image.asset(
                          Images.myTask,
                          width: 20,
                          height: 20,
                        ),
                        title: const Text('Appraisal',
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontFamily: 'PoppinsRegular',
                                fontSize: 15)),
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: ListTile(
                                leading: const Text('•',
                                    style: TextStyle(
                                        color: AppColors.secondaryOrange,
                                        fontFamily: 'PoppinsRegular',
                                        fontSize: 15)),
                                title: const Text('Appraisal List',
                                    style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontFamily: 'PoppinsRegular',
                                        fontSize: 15)),
                                onTap: () {
                                  _onItemTapped(12);
                                },
                              )),

                          Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: ListTile(
                                leading: const Text('•',
                                    style: TextStyle(
                                        color: AppColors.secondaryOrange,
                                        fontFamily: 'PoppinsRegular',
                                        fontSize: 15)),
                                title: const Text('Self Appraisal',
                                    style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontFamily: 'PoppinsRegular',
                                        fontSize: 15)),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ))

                          // Add more ListTiles as needed
                        ],
                      )),
                ),
                ListTile(
                  leading: Image.asset(
                    Images.training,
                    width: 20,
                    height: 20,
                  ),
                  title: const Text('Training',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsRegular',
                          fontSize: 15)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    Images.reports,
                    width: 20,
                    height: 20,
                  ),
                  title: const Text('Reports',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsRegular',
                          fontSize: 15)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    Images.support,
                    width: 20,
                    height: 20,
                  ),
                  title: const Text('Support',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsRegular',
                          fontSize: 15)),
                  onTap: () {
                    _onItemTapped(13);
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    Images.knowledgeBase,
                    width: 20,
                    height: 20,
                  ),
                  title: const Text('Knowledge Base',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsRegular',
                          fontSize: 15)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    Images.knowledgeBase,
                    width: 20,
                    height: 20,
                  ),
                  title: const Text('Logout',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsRegular',
                          fontSize: 15)),
                  onTap: () {
                    UserViewModel().remove();
                    SystemNavigator.pop();
                  },
                )
              ],
            )),
      ),

      body: Container(
        color: AppColors.primaryColor, // Background color set to blue
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),

      //  body: IndexedStack(),
     /* bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
            color: AppColors.primaryColor,
            fontFamily: 'PoppinsRegular',
            fontSize: 13),
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              Images.myTask,
              width: 25,
              height: 25,
            ),
            label: 'My Tasks',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              Images.myTimesheet,
              width: 25,
              height: 25,
            ),
            label: 'My Time Sheet',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              Images.myProjects,
              width: 25,
              height: 25,
            ),
            label: 'My Projects',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              Images.myLeaves,
              width: 25,
              height: 25,
            ),
            label: 'My Leaves',
          )
        ],
      ),*/
    );
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();
  /*Future<String?> getUserName() async {
    try {
      UserModel value = await getUserData();
      if (kDebugMode){
        print("ffffffff Username: test logs are prints or not");
        print("ffffffff UserId: "+value.data!.userId!);
        print("ffffffff token: "+value.token!);
      }

      setState(() {
        print("ffffffff if case is working ");
        print("ffffffff then name is--- "+value.data!.firstName!);
        userName = value.data!.firstName ?? "No User Data";

      });
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return "No User Data"; // or handle the error as per your requirement
    }
    return "Param";
  }*/


  void getUserName(BuildContext context) async {
    getUserData().then((value) {
      if (kDebugMode){
        print("ffffffff Username: test logs are prints or not");
        print("ffffffff UserId: "+value.data!.userId!);
        print("ffffffff token: "+value.token!);
        print("ffffffff userName: "+value.data!.firstName!);
      }

      setState(() {
        userName= value.data?.firstName;
      });


    }).onError((error, StackTrace) {
      if (kDebugMode) {
        print(error);
      }
    });
  }






}

class PlaceholderWidget extends StatelessWidget {
  final String text;

  PlaceholderWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text),
    );
  }
}



