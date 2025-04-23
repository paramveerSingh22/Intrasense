import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../Home/HomeScreen.dart';
import 'FragmentManagerRatingAppraisal.dart';
import 'FragmentSelfRatingAppraisal.dart';

class AppraisalDetailScreen extends StatefulWidget{
  final AppraisalId;

  const AppraisalDetailScreen({
    Key? key,
    required this.AppraisalId,
  }): super(key: key);

  @override
  _AppraisalDetailScreen createState()=> _AppraisalDetailScreen();
}

class _AppraisalDetailScreen extends State<AppraisalDetailScreen> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  String headerTitle = "SELF-RATING";
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
      headerTitle = "SELF-RATING";
    } else if (_tabController.index == 1) {
      headerTitle = "MANAGER-RATING";
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
                        'Appraisal View',
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
                    Tab(text: 'SELF-RATING'),
                    Tab(text: "MANAGER-RATING"),
                  ],
                  indicatorColor: AppColors.secondaryOrange,
                  labelColor: AppColors.secondaryOrange,
                ),
                const DividerColor(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      FragmentSelfRatingAppraisal(AppraisalId:widget.AppraisalId),
                      FragmentManagerRatingAppraisal(AppraisalId:widget.AppraisalId),
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