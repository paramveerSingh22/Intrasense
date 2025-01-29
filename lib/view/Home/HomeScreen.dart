import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intrasense/utils/AppColors.dart';
import 'package:intrasense/utils/Images.dart';
import 'package:intrasense/utils/Utils.dart';
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
import '../Login/LoginScreen.dart';
import '../clientList/ClientListDashboard1.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName = "Param1";
  UserModel? _userData;

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
    MyExpensesList(),
    MyLeavesList("my_leave"),
    MyLeavesList("leave_request"),
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
    'Leave Requests',
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
    return WillPopScope(
        onWillPop: () async {
          return await showExitPopup(context) ?? false;
        },
        child: Scaffold(
          appBar: AppBar(
              title: Text(
                _titles[_selectedIndex],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'PoppinsMedium',
                ),
              ),
              leading: Builder(
                builder: (context) =>
                    IconButton(
                      icon: SizedBox(
                        height: 18,
                        width: 18,
                        child: Image.asset(Images
                            .drawerIcon),
                      ),
                      onPressed: () {
                        Scaffold.of(context)
                            .openDrawer();
                      },
                    ),
              ),
              titleSpacing: 0,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Images.headerBg),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: IconButton(
                    icon: SizedBox(
                      width: 24,
                      height: 24,
                      child: Image.asset(
                        Images.notificationIcon,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {

                    },
                  ),
                ),
              ],
          ),
          drawer: Drawer(
            child: Container(
                decoration: BoxDecoration(color: AppColors.white),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: AssetImage(Images.dummyImage),
                            radius: 30,
                          ),
                          SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Welcome', // Replace with actual user's name
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'PoppinsRegular',
                                ),
                              ),
                              Text(
                                userName ?? "Loading...",
                                // Replace with additional text
                                style: const TextStyle(
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
                              color: AppColors.skyBlueTextColor,
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
                    const DividerColor(),
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
                            iconColor: AppColors.secondaryOrange,
                            collapsedIconColor: AppColors.secondaryOrange,
                            title: const Text('Manage tasks',
                                style: TextStyle(
                                    color: AppColors.skyBlueTextColor,
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
                                            color: AppColors.skyBlueTextColor,
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
                                            color: AppColors.skyBlueTextColor,
                                            fontFamily: 'PoppinsRegular',
                                            fontSize: 15)),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Mytimesheetlist(),
                                        ),
                                      );
                                     // _onItemTapped(2);
                                    },
                                  ))

                              // Add more ListTiles as needed
                            ],
                          )),
                    ),
                    const DividerColor(),
                    ListTile(
                      leading: Image.asset(
                        Images.clients,
                        width: 20,
                        height: 20,
                      ),
                      title: const Text('Clients',
                          style: TextStyle(
                              color: AppColors.skyBlueTextColor,
                              fontFamily: 'PoppinsRegular',
                              fontSize: 15)),
                      onTap: () {
                        _onItemTapped(3);
                      },
                    ),
                    const DividerColor(),
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
                              iconColor: AppColors.secondaryOrange,
                              collapsedIconColor: AppColors.secondaryOrange,
                              title: const Text('Manage Teams',
                                  style: TextStyle(
                                      color: AppColors.skyBlueTextColor,
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
                                              color: AppColors.skyBlueTextColor,
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
                                              color: AppColors.skyBlueTextColor,
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
                                              color: AppColors.skyBlueTextColor,
                                              fontFamily: 'PoppinsRegular',
                                              fontSize: 15)),
                                      onTap: () {
                                        _onItemTapped(6);
                                      },
                                    ))

                                // Add more ListTiles as needed
                              ],
                            ))),
                    const DividerColor(),
                    ListTile(
                      leading: Image.asset(
                        Images.manageProducts,
                        width: 20,
                        height: 20,
                      ),
                      title: const Text('Manage Projects',
                          style: TextStyle(
                              color: AppColors.skyBlueTextColor,
                              fontFamily: 'PoppinsRegular',
                              fontSize: 15)),
                      onTap: () {
                        _onItemTapped(7);
                      },
                    ),
                    const DividerColor(),
                    ListTile(
                      leading: Image.asset(
                        Images.manageDocuments,
                        width: 20,
                        height: 20,
                      ),
                      title: const Text('Manage Documents',
                          style: TextStyle(
                              color: AppColors.skyBlueTextColor,
                              fontFamily: 'PoppinsRegular',
                              fontSize: 15)),
                      onTap: () {
                        _onItemTapped(8);
                      },
                    ),
                    const DividerColor(),
                    ListTile(
                      leading: Image.asset(
                        Images.training,
                        width: 20,
                        height: 20,
                      ),
                      title: const Text('Manage Meetings',
                          style: TextStyle(
                              color: AppColors.skyBlueTextColor,
                              fontFamily: 'PoppinsRegular',
                              fontSize: 15)),
                      onTap: () {
                        _onItemTapped(9);
                      },
                    ),
                    const DividerColor(),
                    ListTile(
                      leading: Image.asset(
                        Images.manageExpense,
                        width: 20,
                        height: 20,
                      ),
                      title: const Text('Manage Expenses',
                          style: TextStyle(
                              color: AppColors.skyBlueTextColor,
                              fontFamily: 'PoppinsRegular',
                              fontSize: 15)),
                      onTap: () {
                       // _onItemTapped(10);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyExpensesList(),
                          ),
                        );
                      },
                    ),
                    const DividerColor(),

                    Container(
                      child: Theme(
                          data: ThemeData(
                            dividerColor: AppColors
                                .white, // Set the default divider color for the theme
                          ),
                          child: ExpansionTile(
                            leading: Image.asset(
                              Images.myLeaves,
                              width: 20,
                              height: 20,
                            ),
                            iconColor: AppColors.secondaryOrange,
                            collapsedIconColor: AppColors.secondaryOrange,
                            title: const Text('Manage Leaves',
                                style: TextStyle(
                                    color: AppColors.skyBlueTextColor,
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
                                    title: const Text('My Leaves',
                                        style: TextStyle(
                                            color: AppColors.skyBlueTextColor,
                                            fontFamily: 'PoppinsRegular',
                                            fontSize: 15)),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MyLeavesList("my_leave"),
                                        ),
                                      );

                                      //_onItemTapped(11);
                                    },
                                  )),

                              if(_userData?.data?.roleTrackId=="2")...{
                                Padding(
                                    padding: const EdgeInsets.only(left: 40.0),
                                    child: ListTile(
                                      leading: const Text('•',
                                          style: TextStyle(
                                              color: AppColors.secondaryOrange,
                                              fontFamily: 'PoppinsRegular',
                                              fontSize: 15)),
                                      title: const Text('Leave Requests',
                                          style: TextStyle(
                                              color: AppColors.skyBlueTextColor,
                                              fontFamily: 'PoppinsRegular',
                                              fontSize: 15)),
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MyLeavesList("leave_request"),
                                          ),
                                        );
                                        //_onItemTapped(12);
                                      },
                                    ))
                              },

                              // Add more ListTiles as needed
                            ],
                          )),
                    ),
                    const DividerColor(),
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
                            iconColor: AppColors.secondaryOrange,
                            collapsedIconColor: AppColors.secondaryOrange,
                            title: const Text('Appraisal',
                                style: TextStyle(
                                    color: AppColors.skyBlueTextColor,
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
                                            color: AppColors.skyBlueTextColor,
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
                                            color: AppColors.skyBlueTextColor,
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
                    const DividerColor(),
                    ListTile(
                      leading: Image.asset(
                        Images.training,
                        width: 20,
                        height: 20,
                      ),
                      title: const Text('Training',
                          style: TextStyle(
                              color: AppColors.skyBlueTextColor,
                              fontFamily: 'PoppinsRegular',
                              fontSize: 15)),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const DividerColor(),
                    ListTile(
                      leading: Image.asset(
                        Images.reports,
                        width: 20,
                        height: 20,
                      ),
                      title: const Text('Reports',
                          style: TextStyle(
                              color: AppColors.skyBlueTextColor,
                              fontFamily: 'PoppinsRegular',
                              fontSize: 15)),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const DividerColor(),
                    ListTile(
                      leading: Image.asset(
                        Images.support,
                        width: 20,
                        height: 20,
                      ),
                      title: const Text('Support',
                          style: TextStyle(
                              color: AppColors.skyBlueTextColor,
                              fontFamily: 'PoppinsRegular',
                              fontSize: 15)),
                      onTap: () {
                        //_onItemTapped(13);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SupportList(),
                          ),
                        );
                      },
                    ),
                    const DividerColor(),
                    ListTile(
                      leading: Image.asset(
                        Images.knowledgeBase,
                        width: 20,
                        height: 20,
                      ),
                      title: const Text('Knowledge Base',
                          style: TextStyle(
                              color: AppColors.skyBlueTextColor,
                              fontFamily: 'PoppinsRegular',
                              fontSize: 15)),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const DividerColor(),
                    ListTile(
                      leading: Image.asset(
                        Images.knowledgeBase,
                        width: 20,
                        height: 20,
                      ),
                      title: const Text('Logout',
                          style: TextStyle(
                              color: AppColors.skyBlueTextColor,
                              fontFamily: 'PoppinsRegular',
                              fontSize: 15)),
                      onTap: () {
                        UserViewModel().remove();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                              (Route<dynamic> route) => false,
                        );
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
        ));
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserName(BuildContext context) async {
    _userData = await getUserData();
    getUserData().then((value) {
      if (kDebugMode) {
        print(value);
      }

      setState(() {
        userName = value.data?.firstName;
      });
    }).onError((error, StackTrace) {
      if (kDebugMode) {
        print(error);
      }
    });
  }

  Future<bool?> showExitPopup(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text("Are you sure?"),
            content: const Text("Do you want to exit the app?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Yes"),
              ),
            ],
          ),
    );
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

class DividerColor extends StatelessWidget {
  const DividerColor({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: AppColors.lightGrey,
      height: 0.5,
    );
  }
}
