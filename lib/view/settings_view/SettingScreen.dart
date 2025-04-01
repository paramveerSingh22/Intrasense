import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/view/settings_view/FragmentEditProfile.dart';
import 'package:intrasense/view/settings_view/PreferencesScreen.dart';
import 'package:intrasense/view/settings_view/SecurityScreen.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../Home/HomeScreen.dart';

class SettingScreen extends StatefulWidget{
  @override
  _SettingScreen createState() => _SettingScreen();

}

class _SettingScreen extends State<SettingScreen> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  String headerTitle = "Profile";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChange() {
    if (_tabController.index == 0) {
      //getSubClientsList();
      headerTitle = "Edit Profile";
    } else if (_tabController.index == 1) {
      headerTitle = "Change Password";
      //getContactList();
    }
    else if (_tabController.index == 2) {
      headerTitle = "Preferences";
      //getContactList();
    }
    setState(() {});
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
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 50, left: 30),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'PoppinsRegular',
                        ),
                      ),
                    ],
                  ),
                ),
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
                ),
                Positioned(
                  top: 20,
                  left: 30,
                  child: Text(
                    headerTitle,
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryOrange,
                        fontFamily: 'PoppinsMedium'),
                  ),
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
            top: 140.0,
            // Adjust this as needed based on your layout
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'PROFILE'),
                    Tab(text: "SECURITY"),
                    Tab(text: "PREFERENCES"),
                  ],
                  indicatorColor: AppColors.secondaryOrange,
                  labelColor: AppColors.secondaryOrange,
                ),
                const DividerColor(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      FragmentEditProfile(),
                      SecurityScreen(),
                      PreferencesScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}