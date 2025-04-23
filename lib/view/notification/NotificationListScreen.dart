import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/view/notification/NotificationDetailsScreen.dart';
import 'package:intrasense/view_models/common_view_model.dart';

import '../../data/network/app_url.dart';
import '../../model/client_list_model.dart';
import '../../model/notification/NotificationListModel.dart';
import '../../model/user_model.dart';
import '../../res/component/ButtonOrangeBorder.dart';
import '../../res/component/CheckboxWithLabel.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomSearchTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Constants.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class NotificationListScreen extends StatefulWidget {
  @override
  _NotificationListScreen createState() => _NotificationListScreen();
}

class _NotificationListScreen extends State<NotificationListScreen> {
  TextEditingController searchController = TextEditingController();
  UserModel? _userData;
  bool _isLoading = false;
  List<NotificationListModel> notificationList = [];
  List<NotificationListModel> filteredList = [];

  @override
  void initState() {
    getUserDetails(context);
    searchController.addListener(_filterList);
    super.initState();
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    if (kDebugMode) {
      print(_userData);
    }
    getNotificationList();
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  void getNotificationList() async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_customer_track_id': _userData?.data?.customerTrackId,
        'deviceType': Constants.deviceType,
        'deviceToken': Constants.deviceToken,
        'notification_status': "1",
        'token': _userData?.token,
      };
      final commonViewModel =
          Provider.of<CommonViewModel>(context, listen: false);
      final response =
          await commonViewModel.getNotificationListApi(data, context);
      setState(() {
        if (response != null) {
          notificationList = response.toList();
          filteredList = notificationList;
        }
      });
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load notification list')),
      );
    } finally {
      setLoading(false);
      Utils.hideLoadingDialog(context);
    }
  }

  void _filterList() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = notificationList
          .where((item) =>
              item.senderFirstname.toString().toLowerCase().contains(query) ||
              item.senderLastname.toString().toLowerCase().contains(query))
          .toList();
    });
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
                const Text(
                  "Notifications",
                  style: TextStyle(
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
            bottom: 10.0,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Notification List",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.secondaryOrange,
                                  fontFamily: 'PoppinsMedium'),
                            ))),
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
                              child: Image.asset(Images.searchIconOrange),
                            ),
                          ),
                        ),
                        /*IconButton(
                          icon: SizedBox(
                            height: 45,
                            width: 45,
                            child: Image.asset(Images.filterIcon),
                          ),
                          onPressed: () {
                            openFilterDialog();
                          },
                        ),*/
                      ],
                    ),
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
                            : Align(
                                alignment: Alignment.topCenter,
                                child: ListView.separated(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  itemCount: filteredList.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const SizedBox(height: 10);
                                  },
                                  itemBuilder: (context, index) {
                                    final item = filteredList[index];
                                    return CustomNotificationListTile(
                                      item: item,
                                      userDetail: _userData,
                                      onListUpdated: () {
                                        getNotificationList();
                                      },
                                    );
                                  },
                                ),
                              )),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class CustomNotificationListTile extends StatelessWidget {
  final NotificationListModel item;
  final userDetail;
  final VoidCallback onListUpdated;

  const CustomNotificationListTile({
    super.key,
    required this.item,
    required this.userDetail,
    required this.onListUpdated,
  });

  void deleteNotificationApi(
      BuildContext context, String notificationId) async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': userDetail?.data?.userId,
        'usr_customer_track_id': userDetail?.data?.customerTrackId,
        'deviceType': Constants.deviceType,
        'deviceToken': Constants.deviceToken,
        'notification_id': item.notificationId,
        'token': userDetail?.token,
      };

      final commonViewModel =
          Provider.of<CommonViewModel>(context, listen: false);
      await commonViewModel.deleteNotificationApi(data, context);
      Utils.hideLoadingDialog(context);
      onListUpdated();
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete this notification')),
      );
      Utils.hideLoadingDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final commonViewModel = Provider.of<CommonViewModel>(context);
    void deleteTeamPopUp(BuildContext context) {
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
                        'Delete Notification',
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
                      'Are you sure!',
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColors.skyBlueTextColor,
                          fontFamily: 'PoppinsRegular'),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "you wan't be able to revert this!",
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
                            deleteNotificationApi(
                                context, item.notificationId.toString());
                          },
                          buttonText: 'YES',
                          loading: commonViewModel.loading,
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

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationDetailScreen(
                    notificationDetail:item
                  ),
                ),
              );
            },
            child: Container(
              child: ListTile(
                contentPadding: const EdgeInsets.only(
                  bottom: 0,
                  top: 0,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DividerColor(),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: item.profilePicture != null
                                ? NetworkImage(AppUrl.imageUrl +
                                    item.profilePicture.toString())
                                : AssetImage(Images.profileIcon)
                                    as ImageProvider,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${item.senderFirstname} ${item.senderLastname}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'PoppinsMedium',
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  item.notificationMessage.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'PoppinsRegular',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  item.datetime.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.hintColor,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'PoppinsRegular',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Spacer pushes the delete icon to the top-right corner
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: SizedBox(
                                height: 20.0,
                                width: 20.0,
                                child: Image.asset(Images.deleteIcon),
                              ),
                              onPressed: () {
                                deleteTeamPopUp(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
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
