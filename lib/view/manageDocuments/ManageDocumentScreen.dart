import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../res/component/ButtonOrangeBorder.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../Home/HomeScreen.dart';
import 'FragmentMyFiles.dart';
import 'package:provider/provider.dart';

class ManageDocumentScreen extends StatefulWidget {
  @override
  _ManageDocumentScreen createState() => _ManageDocumentScreen();
}

class _ManageDocumentScreen extends State<ManageDocumentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
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
   /* if (_tabController.index == 0) {
      //getSubClientsList();
      headerTitle = "MY FILES";
    } else if (_tabController.index == 1) {
      headerTitle = "SHARED WITH ME";
      //getContactList();
    }*/
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
                        'Manage Documents',
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
            top: 100.0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'MY FILES'),
                    Tab(text: "SHARED WITH ME"),
                  ],
                  indicatorColor: AppColors.secondaryOrange,
                  labelColor: AppColors.secondaryOrange,
                ),
                const DividerColor(),
                const SizedBox(height: 20.0),

                /// Expanded area for TabBarView (scrollable content)
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      FragmentMyFiles(),
                      FragmentMyFiles(),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 10,
                          child: ButtonOrangeBorder(
                            onPressed: () {

                            },
                            buttonText: 'CREATE FOLDER',
                           // loading: eventViewModel.loading,
                          )),
                      Expanded(flex: 1, child: Container()),
                      Expanded(
                          flex: 10,
                          child: CustomElevatedButton(
                            onPressed: () {
                              //Navigator.pop(context);
                            },
                            buttonText: 'UPLOAD FILE',
                          ))
                    ],
                  ),
                ),
              /*  Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      eee
                      ElevatedButton(onPressed: () {}, child: Text("Button 1")),
                      ElevatedButton(onPressed: () {}, child: Text("Button 2")),
                    ],
                  ),
                ),*/
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
