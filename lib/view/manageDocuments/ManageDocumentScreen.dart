import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/view/manageDocuments/UploadFileScreen.dart';

import '../../model/projects/ProjectListModel.dart';
import '../../model/user_model.dart';
import '../../res/component/ButtonOrangeBorder.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Constants.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/documents_view_model.dart';
import '../../view_models/projects_view_model.dart';
import '../../view_models/user_view_model.dart';
import '../Home/HomeScreen.dart';
import 'FragmentMyFiles.dart';
import 'package:provider/provider.dart';

import 'FragmentSharedWithMe.dart';

class ManageDocumentScreen extends StatefulWidget {
  @override
  _ManageDocumentScreen createState() => _ManageDocumentScreen();
}

class _ManageDocumentScreen extends State<ManageDocumentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  final TextEditingController folderNameController = TextEditingController();
  List<ProjectListModel> projectList = [];
  List<String> projectTypeNameList = [];
  String? selectProjectValue;
  String? selectProjectId = "";
  UserModel? _userData;

  @override
  void initState() {
    super.initState();
    getUserDetails(context);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChange);
    _tabController.dispose();
    super.dispose();
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    if (kDebugMode) {
      print(_userData);
    }
    getProjectsList();
  }

  void getProjectsList() async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'usr_customer_track_id': _userData?.data?.customerTrackId,
        'token': _userData?.token,
      };
      final projectsViewModel = Provider.of<ProjectsViewModel>(context, listen: false);
      final response = await projectsViewModel.getProjectListApi(data, context);
      setState(() {
        if (response != null) {
          projectList = response.toList();
          projectTypeNameList = projectList.map((item) => item.prName.toString()).toList();

        }
      });
      Utils.hideLoadingDialog(context);
    } catch (error, stackTrace) {
      Utils.hideLoadingDialog(context);
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load project list')),
      );
    } finally {
      setLoading(false);
    }
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

 /* void _onTabChange() {
   *//* if (_tabController.index == 0) {
      //getSubClientsList();
      headerTitle = "MY FILES";
    } else if (_tabController.index == 1) {
      headerTitle = "SHARED WITH ME";
      //getContactList();
    }*//*
    setState(() {});
  }*/

  void _onTabChange() {
    // Only trigger logic when swipe is complete (not while dragging)
    if (_tabController.indexIsChanging) return;

    if (_tabController.index == _tabController.animation?.value.round()) {
      // Tab change is confirmed
      setState(() {
        // Optional: show progress only if needed
        _isLoading = true;

        // Simulate data load delay for demo
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    void createFolderDialog() {
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: true,
        builder: (BuildContext context) {
          final documentViewModel = Provider.of<DocumentsViewModel>(context, listen: false);
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: AppColors.secondaryOrange.withOpacity(0.1),
                  padding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Create New Folder',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.secondaryOrange,
                            fontFamily: 'PoppinsMedium'),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.textColor,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Select Project',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: CustomDropdown(
                    value: selectProjectValue,
                    items: projectTypeNameList,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectProjectValue = newValue;
                        selectProjectId = projectList
                            .firstWhere((item) => item.prName == newValue)
                            .projectId;
                      });
                    },
                    hint: 'Select Project',
                  ),
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Create Folder',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                ),
                const SizedBox(height: 5),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: CustomTextField(
                        controller: folderNameController,
                        hintText: 'Folder Name')),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10.0),
                  child: CustomElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      Utils.showLoadingDialog(context);
                      try {
                        Map data = {
                          'user_id': _userData?.data?.userId,
                          'usr_role_track_id': _userData?.data?.roleTrackId,
                          'customer_id': _userData?.data?.customerTrackId,
                          'folderName': folderNameController.text.toString(),
                          'deviceType':Constants.deviceType,
                          'deviceToken': Constants.deviceToken,
                          'project_id': selectProjectId,
                          'token': _userData?.token,
                        };

                        await documentViewModel.createFolderApi(data, context);
                        Utils.hideLoadingDialog(context);
                      } catch (error, stackTrace) {
                        Utils.hideLoadingDialog(context);
                        if (kDebugMode) {
                          print(error);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to Add folder Api')),
                        );
                      } finally {
                        setLoading(false);
                      }
                    },
                    buttonText: 'CREATE FOLDER',
                    loading: documentViewModel.loading,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }


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
                      FragmentSharedWithMe(),
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
                              createFolderDialog();
                            },
                            buttonText: 'CREATE FOLDER',
                           // loading: eventViewModel.loading,
                          )),
                      Expanded(flex: 1, child: Container()),
                      Expanded(
                          flex: 10,
                          child: CustomElevatedButton(
                            onPressed: () {
                              UploadFileScreen.show(context);
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
