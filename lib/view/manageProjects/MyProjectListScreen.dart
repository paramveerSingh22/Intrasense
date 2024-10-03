import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/model/projects/ProjectListModel.dart';
import 'package:intrasense/model/projects/ProjectTypesModel.dart';
import 'package:intrasense/view/manageProjects/AddProjectScreen.dart';
import 'package:intrasense/view_models/projects_view_model.dart';

import '../../model/user_model.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class MyProjectListScreen extends StatefulWidget {
  @override
  _MyProjectListScreen createState() => _MyProjectListScreen();
}

class _MyProjectListScreen extends State<MyProjectListScreen> {
  UserModel? _userData;
  bool _isLoading = false;
  List<ProjectListModel> projectList = [];

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
    getProjectsList();
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  Future<void> getProjectsList() async {
    setLoading(true);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'usr_customer_track_id': _userData?.data?.customerTrackId,
        'token': _userData?.token,
      };
      final projectViewModel =
          Provider.of<ProjectsViewModel>(context, listen: false);
      final response = await projectViewModel.getProjectListApi(data, context);
      if (response != null) {
        setState(() {
          projectList = response;
          setLoading(false);
        });
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching employee list: $error');
      }
    } finally {
      setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 30.0,
            // Adjust this value as needed
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          children: [
                            TextField(
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
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                    width: 1.0,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.fromLTRB(
                                    12.0, 5.0, 50.0, 5.0),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                    padding: EdgeInsets.only(left: 0.0),
                                    child: Text(
                                      'My Project List ',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.secondaryOrange,
                                          fontFamily: 'PoppinsMedium'),
                                    ))),
                            /*Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.white,
                                  underline: Container(
                                    height: 2,
                                    color: Colors.white,
                                  ),
                                  items: <String>[
                                    'Option 1',
                                    'Option 2',
                                    'Option 3',
                                    'Option 4'
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {},
                                  hint: const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text('Select an option'),
                                  ),
                                  isExpanded: true,
                                ),
                              ),
                            )*/
                          ],
                        )),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Container(
                          color: AppColors.lightBlue,
                          child: ListView.separated(
                            itemCount: projectList.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(height: 10);
                            },
                            itemBuilder: (context, index) {
                              return CustomProjectListTile(
                                  item: projectList[index]);
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
                              builder: (context) => AddProjectScreen(),
                            ),
                          );
                        },
                        buttonText: 'Add New Project',
                      ),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class CustomProjectListTile extends StatelessWidget {
  final ProjectListModel item;
  const CustomProjectListTile({super.key, required this.item});

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
                      flex: 10,
                      child: Row(
                        children: [
                          Text(
                            "${item.prShortName} - ",
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.secondaryOrange,
                              fontFamily: 'PoppinsRegular',
                            ),
                          ),
                          Text(
                            item.prName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                            ),
                          )
                        ],
                      )),
                  Expanded(
                      flex: 1,
                      child: Image.asset(
                        Images.threeDotsRed,
                        width: 12.0,
                        height: 20.0, // Update with your asset path
                      ))
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text(
                      'Client',
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
                        item.clientName,
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
                          'Project Manager',
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
                        item.projectManagerName,
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
                          'Project Type',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsRegular',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )),
                  const Expanded(
                      flex: 1,
                      child: Text(
                        '-',
                        style: TextStyle(
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
                  const Expanded(
                      flex: 1,
                      child: Text(
                        'Start Date',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular',
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Text(
                        item.prStartDate,
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
                          'Delievry Date',
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
                        item.prClosedDate.toString(),
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
                          'Hours',
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
                        item.prBudgetedHours,
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
                          'Status',
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
                        item.status,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular',
                          fontWeight: FontWeight.w500,
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
