import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/model/leave/LeaveListModel.dart';
import 'package:intrasense/view/leaves/ApplyLeave.dart';
import 'package:intrasense/view_models/leave_view_model.dart';
import '../../model/user_model.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomSearchTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class MyLeavesList extends StatefulWidget {
  @override
  _MyLeavesList createState() => _MyLeavesList();
}

class _MyLeavesList extends State<MyLeavesList> {
  UserModel? _userData;
  bool _isLoading = false;
  List<LeaveListModel> leavesList = [];
  List<LeaveListModel> filteredList = [];
  TextEditingController searchController = TextEditingController();


  @override
  void initState() {
    getUserDetails(context);
    searchController.addListener(_filterList);
    super.initState();
  }
  @override
  void dispose() {
    searchController.removeListener(_filterList);
    searchController.dispose();
    super.dispose();
  }

  void _filterList() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = leavesList
          .where((item) =>
          item.levPurpose.toLowerCase().contains(query)||
              item.levType.toLowerCase().contains(query))
          .toList();
    });
  }


  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    if (kDebugMode) {
      print(_userData);
    }
    getLeaveList();
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  Future<void> getLeaveList() async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'usr_customer_track_id': _userData?.data?.customerTrackId,
        'token': _userData?.token,
      };
      final leaveViewModel =
          Provider.of<LeaveViewModel>(context, listen: false);
      final response = await leaveViewModel.getLeaveListApi(data, context);
      Utils.hideLoadingDialog(context);
      setState(() {
        if (response != null) {
          leavesList = response.toList();
          filteredList = leavesList;
        }
      });
    } catch (error) {
      Utils.hideLoadingDialog(context);
      print('Error fetching leaves list: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 20.0,
            left: 0.0,
            right: 0.0,
            bottom: 70.0,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          children: [
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Leave History',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.secondaryOrange,
                                      fontFamily: 'PoppinsMedium'),
                                )),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomSearchTextField(
                                    controller: searchController,
                                    hintText: 'Search',
                                    suffixIcon: SizedBox(
                                      height: 16,
                                      width: 16,
                                      child:
                                          Image.asset(Images.searchIconOrange),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: SizedBox(
                                    height: 45,
                                    width: 45,
                                    child: Image.asset(Images.filterIcon),
                                  ),
                                  onPressed: () {
                                    // Filter action
                                  },
                                ),
                              ],
                            ),
                          ],
                        )),
                    Expanded(
                      child: filteredList.isEmpty
                          ? const Center(
                              child: Text(
                                'No data found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'PoppinsMedium',
                                ),
                              ),
                            )
                          : ListView.separated(
                              itemCount: filteredList.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(height: 10);
                              },
                              itemBuilder: (context, index) {
                                final item = filteredList[index];
                                return CustomLeaveListTile(
                                  item: item
                                );
                              },
                            ),
                    ),
                  ],
                )),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ApplyLeave()),
                  );
                  if (result == true) {
                    getLeaveList();
                  }
                },
                buttonText: 'APPLY LEAVE',
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomLeaveListTile extends StatelessWidget {
  final LeaveListModel item;

  const CustomLeaveListTile({
    super.key,
    required this.item
  });

  @override
  Widget build(BuildContext context) {

    String getStatusText(String status) {
      switch (status) {
        case "1":
          return 'PENDING';
        case "2":
          return 'APProved';
        case "3":
          return 'CANCELED';
        case "4":
          return 'REJECTED';
        default:
          return 'CANCEL';
      }
    }

    DateTime startDate = DateTime.parse(item.levStartDate);
    DateTime endDate = DateTime.parse(item.levEndDate);
    int numberOfDays = endDate.difference(startDate).inDays + 1;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              color: Colors.white,
              border: Border.all(
                color: AppColors.dividerColor,
                width: 1.0,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.only(
                bottom: 10,
                top: 0,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 10,
                            child: Text(
                              'Staff ID-${item.userId}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.skyBlueTextColor,
                                fontFamily: 'PoppinsMedium',
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: SizedBox(
                                      height: 20.0,
                                      width: 20.0,
                                      child: Image.asset(Images.editIcon),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ApplyLeave(leaveDetail: item),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: const Text(
                              'Employee Name',
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
                              "${item.userFirstName} ${item.userLastName}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsRegular',
                                fontWeight: FontWeight.w500,
                              ),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const DividerColor(),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                child: const Text(
                                  'Leave Type',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                    fontFamily: 'PoppinsRegular',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )),
                        ),
                        Expanded(
                            flex: 1,
                            child: Text(
                              item.levType,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsRegular',
                                fontWeight: FontWeight.w500,
                              ),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const DividerColor(),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              child: const Text(
                                'Purpose',
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
                              item.levPurpose,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsRegular',
                                fontWeight: FontWeight.w500,
                              ),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const DividerColor(),
                  const SizedBox(height: 10),
                 if(item.levType=="Half Day"|| item.levType=="Short leave")...{
                   Padding(
                     padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                     child: Row(
                       children: [
                         Expanded(
                             flex: 1,
                             child: Container(
                               child: const Text(
                                 'Date',
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
                               item.levStartDate,
                               style: const TextStyle(
                                 fontSize: 14,
                                 color: AppColors.textColor,
                                 fontFamily: 'PoppinsRegular',
                                 fontWeight: FontWeight.w500,
                               ),
                             ))
                       ],
                     ),
                   ),
                   const SizedBox(height: 10),
                   const DividerColor(),
                   const SizedBox(height: 10),
                   Padding(
                     padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                     child: Row(
                       children: [
                         Expanded(
                             flex: 1,
                             child: Container(
                               child: const Text(
                                 'Start time',
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
                               item.levStartTime,
                               style: const TextStyle(
                                 fontSize: 14,
                                 color: AppColors.textColor,
                                 fontFamily: 'PoppinsRegular',
                                 fontWeight: FontWeight.w500,
                               ),
                             ))
                       ],
                     ),
                   ),
                   const SizedBox(height: 10),
                   const DividerColor(),
                   const SizedBox(height: 10),
                   Padding(
                     padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                     child: Row(
                       children: [
                         Expanded(
                             flex: 1,
                             child: Container(
                               child: const Text(
                                 'End time',
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
                               item.levEndTime,
                               style: const TextStyle(
                                 fontSize: 14,
                                 color: AppColors.textColor,
                                 fontFamily: 'PoppinsRegular',
                                 fontWeight: FontWeight.w500,
                               ),
                             ))
                       ],
                     ),
                   ),
                   const SizedBox(height: 10),
                   const DividerColor(),
                   const SizedBox(height: 10),
                 }
                 else...{
                   Padding(
                     padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                     child: Row(
                       children: [
                         Expanded(
                             flex: 1,
                             child: Container(
                               child: const Text(
                                 'From',
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
                               item.levStartDate,
                               style: const TextStyle(
                                 fontSize: 14,
                                 color: AppColors.textColor,
                                 fontFamily: 'PoppinsRegular',
                                 fontWeight: FontWeight.w500,
                               ),
                             ))
                       ],
                     ),
                   ),
                   const SizedBox(height: 10),
                   const DividerColor(),
                   const SizedBox(height: 10),
                   Padding(
                     padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                     child: Row(
                       children: [
                         Expanded(
                             flex: 1,
                             child: Container(
                               child: const Text(
                                 'To',
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
                               item.levEndDate,
                               style: const TextStyle(
                                 fontSize: 14,
                                 color: AppColors.textColor,
                                 fontFamily: 'PoppinsRegular',
                                 fontWeight: FontWeight.w500,
                               ),
                             ))
                       ],
                     ),
                   ),
                   const SizedBox(height: 10),
                   const DividerColor(),
                   const SizedBox(height: 10),
                   Padding(
                     padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                     child: Row(
                       children: [
                         Expanded(
                             flex: 1,
                             child: Container(
                               child: const Text(
                                 'No. of Days',
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
                               numberOfDays.toString(),
                               style: const TextStyle(
                                 fontSize: 14,
                                 color: AppColors.textColor,
                                 fontFamily: 'PoppinsRegular',
                                 fontWeight: FontWeight.w500,
                               ),
                             ))
                       ],
                     ),
                   ),
                   const SizedBox(height: 10),
                   const DividerColor(),
                   const SizedBox(height: 10),
                 },

                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
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
                              getStatusText(item.levStatus),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.primaryColor,
                                fontFamily: 'PoppinsRegular',
                                fontWeight: FontWeight.w500,
                              ),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: IgnorePointer(
            ignoring: true,
            child: Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.secondaryOrange.withOpacity(0.1),
                  // Making it semi-transparent
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
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
