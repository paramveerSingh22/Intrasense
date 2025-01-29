import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/model/tickets/TicketListModel.dart';
import 'package:intrasense/res/component/ButtonOrangeBorder.dart';
import 'package:intrasense/view/WebViewScreen.dart';
import 'package:intrasense/view/support/TicketDetailScreen.dart';
import 'package:intrasense/view_models/ticket_view_model.dart';
import '../../model/user_model.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/user_view_model.dart';
import 'RaiseTcketScreen.dart';
import 'package:provider/provider.dart';

class SupportList extends StatefulWidget {
  @override
  _SupportList createState() => _SupportList();
}

class _SupportList extends State<SupportList> {
  UserModel? _userData;
  bool _isLoading = false;
  List<TicketListModel> ticketList = [];

  @override
  void initState() {
    getUserDetails(context);
    super.initState();
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    if (kDebugMode) {
      print(_userData);
    }
    getTicketList();
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  Future<void> getTicketList() async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'usr_customer_track_id': _userData?.data?.customerTrackId,
        'token': _userData?.token,
      };
      final ticketViewModel =
          Provider.of<TicketViewModel>(context, listen: false);
      final response = await ticketViewModel.getTicketListApi(data, context);
      setState(() {
        if (response != null) {
          ticketList = response.toList().reversed.toList();
        }
      });

      Utils.hideLoadingDialog(context);
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
                const Text(
                  "Support",
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
            bottom: 70.0,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: const Column(
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'All Tickets',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.secondaryOrange,
                                          fontFamily: 'PoppinsMedium'),
                                    ))),
                          ],
                        )),
                    SizedBox(height: 20),
                    Expanded(
                      child: ticketList.isEmpty
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
                                itemCount: ticketList.length,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(height: 10);
                                },
                                itemBuilder: (context, index) {
                                  final item = ticketList[index];
                                  final userData = _userData;
                                  return CustomSupportListTile(item: item, userData: userData,refreshTicketList: getTicketList);
                                },
                              ),
                            ),
                    ),
                  ],
                )),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 10.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                children: [
                  Expanded(
                      flex: 10,
                      child: ButtonOrangeBorder(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebViewScreen(),
                            ),
                          );
                          if (result == true) {
                            getTicketList();
                          }
                        },
                        buttonText: 'FAQs',
                      )),
                  Expanded(flex: 1, child: Container()),
                  Expanded(
                      flex: 10,
                      child: CustomElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RaiseTicketScreen(),
                            ),
                          );
                          if (result == true) {
                            getTicketList();
                          }
                        },
                        buttonText: 'RAISE A TICKET',
                        //loading: clientViewModel.loading,
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomSupportListTile extends StatelessWidget {
  final TicketListModel item;
  final UserModel? userData;
  final Function? refreshTicketList;

  const CustomSupportListTile({super.key, required this.item, required this.userData,this.refreshTicketList,});

  String getStatusText(String status) {
    switch (status) {
      case "1":
        return 'OPEN';
      case "2":
        return 'INPROGRESS';
      case "3":
        return 'CLOSED';
      default:
        return 'INPROGRESS';
    }
  }

  Future<void> updateTicketStatusApi(String status, BuildContext context) async {

    Utils.showLoadingDialog(context);
    Map data = {
      'user_id': userData?.data?.userId.toString(),
      'ticket_id': item.ticketId.toString(),
      'ticket_status':status,
      'token': userData?.token.toString(),
    };
    final ticketViewModel = Provider.of<TicketViewModel>(context, listen: false);
    await ticketViewModel.updateTicketStatusApi(data,context);
    Utils.hideLoadingDialog(context);
    refreshTicketList!();

  }

  @override
  Widget build(BuildContext context) {



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
                )),
            child: ListTile(
              contentPadding: const EdgeInsets.only(
                  bottom: 20, top: 0, left: 20, right: 10),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Text(
                            'Ticket No: ${item.ticketId}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.primaryColor,
                              fontFamily: 'PoppinsRegular',
                            ),
                          )),
                      Expanded(
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
                                            TicketDetailScreen(
                                                ticketDetail: item)),
                                  );
                                },
                              ),

                              if(userData?.data?.roleTrackId=="5")...{
                                Expanded(
                                    child: GestureDetector(
                                      onTapDown: (TapDownDetails details) {
                                        showMenu(
                                          context: context,
                                          position: RelativeRect.fromLTRB(
                                            details.globalPosition.dx,
                                            details.globalPosition.dy,
                                            details.globalPosition.dx,
                                            details.globalPosition.dy + 20,
                                          ),
                                          items: [
                                            const PopupMenuItem(
                                              value: 1,
                                              child: Text('InProgress'),
                                            ),
                                            const PopupMenuItem(
                                              value: 2,
                                              child: Text('Closed'),
                                            ),
                                          ],
                                        ).then((value) {
                                          if (value != null) {
                                            if (value == 1) {
                                              updateTicketStatusApi("2", context);
                                            } else if (value == 2) {
                                              updateTicketStatusApi("3",context);
                                            }
                                          }
                                        });
                                      },
                                      child: Image.asset(
                                        Images.threeDotsRed,
                                        width: 15.0,
                                        height: 15.0,
                                      ),
                                    ))
                              }

                            ],
                          )),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: const Text(
                            'Name',
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
                            "${item.firstName} ${item.lastName}",
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
                  const DividerColor(),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              child: const Text(
                                'Organization',
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
                            item.organisation,
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
                  const DividerColor(),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            child: const Text(
                              'Designation',
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
                            item.designation,
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
                  const DividerColor(),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            child: const Text(
                              'Issue Type',
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
                            item.issueType,
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
                  const DividerColor(),
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
                            getStatusText(item.status),
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.primaryColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w500,
                            ),
                          ))
                    ],
                  ),
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
