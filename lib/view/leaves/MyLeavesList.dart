import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/model/leave/LeaveListModel.dart';
import 'package:intrasense/view/leaves/ApplyLeave.dart';
import 'package:intrasense/view/leaves/LeaveDetailScreen.dart';
import 'package:intrasense/view_models/leave_view_model.dart';
import '../../model/leave/LeaveTypeModel.dart';
import '../../model/user_model.dart';
import '../../res/component/ButtonOrangeBorder.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomSearchTextField.dart';
import '../../res/component/CustomTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/UserProvider.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class MyLeavesList extends StatefulWidget {
  final String type;

  MyLeavesList(this.type);

  @override
  _MyLeavesList createState() => _MyLeavesList();
}

class _MyLeavesList extends State<MyLeavesList> {
  UserModel? _userData;
  bool _isLoading = false;
  List<LeaveListModel> leavesList = [];
  List<LeaveListModel> filteredList = [];
  TextEditingController searchController = TextEditingController();

  String? selectLeaveTypeValue;
  String? selectLeaveTypeId;
  List<LeaveTypeModel> leaveTypeList = [];
  List<String> leaveTypeNameList = [];

  String? selectLeaveFrequencyValue;
  List<String> leaveFrequencyList = [
    "Weekly",
    "Monthly",
    "Yearly",
  ];

  final TextEditingController _filterFromDateController =
      TextEditingController();
  final TextEditingController _filterToDateController = TextEditingController();

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
              item.userFirstName.toLowerCase().contains(query) ||
              item.userLastName.toLowerCase().contains(query) ||
              item.leaveTypeName.toLowerCase().contains(query))
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
    getLeaveTypeList();
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
      if (widget.type == "my_leave") {
        final response = await leaveViewModel.getLeaveListApi(data, context);
        setState(() {
          if (response != null) {
            leavesList = response.toList().reversed.toList();
            filteredList = leavesList;
          }
        });
      } else {
        final response =
        await leaveViewModel.getLeaveRequestListApi(data, context);
        setState(() {
          if (response != null) {
            leavesList = response.toList().reversed.toList();
            filteredList = leavesList;
          }
        });
      }
      Utils.hideLoadingDialog(context);
    } catch (error) {
      Utils.hideLoadingDialog(context);
      print('Error fetching leaves list: $error');
    }
  }

  Future<void> getLeaveTypeList() async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'customer_id': _userData?.data?.customerTrackId,
        'token': _userData?.token,
      };
      final leaveViewModel =
          Provider.of<LeaveViewModel>(context, listen: false);
      final response = await leaveViewModel.getLeaveTypeListApi(data, context);
      Utils.hideLoadingDialog(context);
      setState(() {
        if (response != null) {
          leaveTypeList = response.toList();
          leaveTypeNameList =
              leaveTypeList.map((item) => item.leaveType).toList();
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
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Images.headerBg),
                fit: BoxFit.cover,
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
                  fit: BoxFit.cover,
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
            top: 36,
            left: 30,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.type == "my_leave" ? "My Leaves" : "Leave Requests",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'PoppinsMedium',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 110.0,
            left: 0.0,
            right: 0.0,
            bottom: 70.0,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.type == "my_leave"
                                      ? "My Leaves"
                                      : "Leave Requests",
                                  style: const TextStyle(
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
                                    openFilterDialog();
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
                                    item: item,
                                    type: widget.type,
                                    onTaskUpdated: () {
                                      getLeaveList();
                                    },
                                    onDelete: () {
                                      deleteLeaveApi(
                                          context, item.leaveId.toString(),item.levStartDate);
                                    });
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
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
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

  void openFilterDialog() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: AppColors.secondaryOrange.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Search by Filter',
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
                    'Select Leave Type',
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
                value: selectLeaveTypeValue,
                items: leaveTypeNameList,
                onChanged: (String? newValue) {
                  setState(() {
                    selectLeaveTypeValue = newValue;
                    selectLeaveTypeId = leaveTypeList
                        .firstWhere((item) => item.leaveType == newValue)
                        .leaveTypeId;
                  });
                },
                hint: 'Select Leave',
              ),
            ),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Select Leave Frequency',
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
                value: selectLeaveFrequencyValue,
                items: leaveFrequencyList,
                onChanged: (String? newValue) {
                  setState(() {
                    selectLeaveFrequencyValue = newValue;
                  });
                },
                hint: 'Select Leave Frequency',
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                children: [
                  const Expanded(
                      flex: 10,
                      child: Text(
                        'From',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular',
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                  Expanded(flex: 1, child: Container()),
                  const Expanded(
                      flex: 10,
                      child: Text(
                        'To',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular',
                          fontWeight: FontWeight.w500,
                        ),
                      ))
                ],
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                children: [
                  Expanded(
                      flex: 10,
                      child: CustomTextField(
                        controller: _filterFromDateController,
                        hintText: 'DD/MM/YYYY',
                        suffixIcon: Image.asset(
                          Images.calenderIcon,
                          height: 24,
                          width: 24,
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now()
                                .add(const Duration(days: -365 * 100)),
                            lastDate: DateTime.now()
                                .add(const Duration(days: 365 * 100)),
                          );

                          if (pickedDate != null) {
                            String formattedDate =
                                "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                            setState(() {
                              _filterFromDateController.text = formattedDate;
                            });
                          }
                        },
                      )),
                  Expanded(flex: 1, child: Container()),
                  Expanded(
                      flex: 10,
                      child: CustomTextField(
                          controller: _filterToDateController,
                          hintText: 'DD/MM/YYYY',
                          suffixIcon: Image.asset(
                            Images.calenderIcon,
                            height: 24,
                            width: 24,
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 365 * 100)),
                            );

                            if (pickedDate != null) {
                              String formattedDate =
                                  "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                              setState(() {
                                _filterToDateController.text = formattedDate;
                              });
                            }
                          }))
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: CustomElevatedButton(
                onPressed: () async {
                  Utils.showLoadingDialog(context);
                  try {
                    Map data = {
                      'user_id': _userData?.data?.userId,
                      'usr_role_track_id': _userData?.data?.roleTrackId,
                      'usr_customer_track_id': _userData?.data?.customerTrackId,
                      'token': _userData?.token,
                      if (_filterFromDateController.text.isNotEmpty) ...{
                        'from_date': _filterFromDateController.text.toString()
                      },
                      if (_filterToDateController.text.isNotEmpty) ...{
                        'to_date': _filterToDateController.text.toString()
                      },
                      if (selectLeaveTypeId != null) ...{
                        'leave_type': selectLeaveTypeId.toString()
                      },
                      if (selectLeaveFrequencyValue != null) ...{
                        'leave_frequency': selectLeaveFrequencyValue.toString()
                      },
                    };
                    final leaveViewModel =
                        Provider.of<LeaveViewModel>(context, listen: false);
                    if (widget.type == "my_leave") {
                      final response =
                          await leaveViewModel.getLeaveListApi(data, context);
                      setState(() {
                        if (response != null) {
                          leavesList = response.toList().reversed.toList();
                          filteredList = leavesList;
                        }
                      });
                    } else {
                      final response = await leaveViewModel
                          .getLeaveRequestListApi(data, context);
                      setState(() {
                        if (response != null) {
                          leavesList = response.toList().reversed.toList();
                          filteredList = leavesList;
                        }
                      });
                    }
                    Utils.hideLoadingDialog(context);
                    Navigator.pop(context);
                  } catch (error) {
                    Utils.hideLoadingDialog(context);
                    print('Error fetching leaves list: $error');
                  }
                },
                buttonText: 'SEARCH',
              ),
            )
          ],
        );
      },
    );
  }

  void deleteLeaveApi(BuildContext context, String leaveId, String levStartDate) async {
    Utils.showLoadingDialog(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUserData();
    try {
      Map data = {
        'user_id': userProvider.user?.data?.userId,
        'usr_role_track_id': userProvider.user?.data?.roleTrackId,
        'usr_customer_track_id': userProvider.user?.data?.customerTrackId,
        'leave_id': leaveId,
        'leave_start_date': levStartDate,
        'token': userProvider.user?.token,
      };
      final leaveViewModel = Provider.of<LeaveViewModel>(context, listen: false);
      await leaveViewModel.deleteLeaveApi(data, context);
      Utils.hideLoadingDialog(context);
      Navigator.pop(context);
      getLeaveList();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to cancel this leave')),
      );
      Utils.hideLoadingDialog(context);
    }
  }
}

class CustomLeaveListTile extends StatelessWidget {
  final LeaveListModel item;
  final String type;
  final VoidCallback onTaskUpdated;
  final Function onDelete;

  const CustomLeaveListTile(
      {super.key, required this.item, required this.type, required this.onTaskUpdated,required this.onDelete,});

  @override
  Widget build(BuildContext context) {
    final leaveViewModel = Provider.of<LeaveViewModel>(context);
    String getStatusText(String status) {
      switch (status) {
        case "1":
          return 'PENDING';
        case "2":
          return 'APPROVED';
        case "3":
          return 'CANCELED';
        case "4":
          return 'REJECTED';
        default:
          return 'CANCEL';
      }
    }

    String getLeaveType(String type) {
      switch (type) {
        case "1":
          return 'Full Day';
        case "2":
          return 'Half Day';
        case "3":
          return 'Short leave';
        case "4":
          return 'Paternity leave';
        case "5":
          return 'Maternity leave';
        default:
          return 'Full Day';
      }
    }

    void deleteLeavePopUp(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: AppColors.secondaryOrange.withOpacity(0.1),
                padding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, bottom: 12.0, left: 10.0, right: 15.0),
                      // Adjust the padding value as needed
                      child: Text(
                        'Cancel Leave',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryOrange,
                          fontFamily: 'PoppinsMedium',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                Images.deleteIconAlert,
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Cancel Leave!',
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColors.skyBlueTextColor,
                          fontFamily: 'PoppinsRegular'),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Are you sure, you want to Cancel this leave.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.black,
                          fontFamily: 'PoppinsRegular',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Expanded(
                        flex: 10,
                        child: ButtonOrangeBorder(
                          onPressed: () {
                            onDelete();
                          },
                          buttonText: 'YES',
                          loading: leaveViewModel.loading,
                        )),
                    Expanded(flex: 1, child: Container()),
                    Expanded(
                        flex: 10,
                        child: CustomElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          buttonText: 'NO',
                        ))
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          );
        },
      );
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
                              getLeaveType(item.levType),
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
                                        child: Image.asset(Images.eyeIcon),
                                      ),
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LeaveDetailScreen(
                                                      leaveDetail: item)),
                                        );
                                        if (result == true) {
                                          onTaskUpdated();
                                        }
                                      }),
                                ],
                              )),
                        ),
                        if (type == "my_leave" && getStatusText(item.levStatus)=="PENDING") ...{
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
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ApplyLeave(leaveDetail: item)),
                                        );
                                        if (result == true) {
                                          onTaskUpdated();
                                        }
                                      },
                                    ),
                                  ],
                                )),
                          ),

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
                                        child: Image.asset(Images.deleteIcon),
                                      ),
                                      onPressed: () {
                                        deleteLeavePopUp(context);

                                      },
                                    ),
                                  ],
                                )),
                          )

                        },

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
                                fontFamily: 'PoppinsMedium',
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
                                  'Staff ID',
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
                            item.usrEmpID,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium',
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
                                fontFamily: 'PoppinsMedium',
                                fontWeight: FontWeight.w500,
                              ),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const DividerColor(),
                  const SizedBox(height: 10),
                  if (item.levType == "Half Day" ||
                      item.levType == "Short leave") ...{
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
                                  fontFamily: 'PoppinsMedium',
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
                                  fontFamily: 'PoppinsMedium',
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
                                  fontFamily: 'PoppinsMedium',
                                  fontWeight: FontWeight.w500,
                                ),
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const DividerColor(),
                    const SizedBox(height: 10),
                  } else ...{
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
                                  fontFamily: 'PoppinsMedium',
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
                                  fontFamily: 'PoppinsMedium',
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
                                  fontFamily: 'PoppinsMedium',
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
                                fontFamily: 'PoppinsMedium',
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
