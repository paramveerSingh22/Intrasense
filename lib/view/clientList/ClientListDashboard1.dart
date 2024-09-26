import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/model/client_subs_diary_model.dart';
import 'package:intrasense/model/contact_list_model.dart';
import 'package:intrasense/utils/Utils.dart';
import 'package:intrasense/view/clientList/AddClients.dart';
import 'package:intrasense/view/clientList/AddContact.dart';
import 'package:intrasense/view/clientList/AddSubsidiary.dart';
import 'package:intrasense/view/clientList/EditClients.dart';
import 'package:intrasense/view/clientList/EditContact.dart';
import 'package:intrasense/view/clientList/EditSubsidiary.dart';
import 'package:intrasense/view_models/client_view_model.dart';
import '../../model/client_list_model.dart';
import '../../model/user_model.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../utils/AppColors.dart';
import 'package:provider/provider.dart';

import '../../utils/Images.dart';
import '../../view_models/UserProvider.dart';
import '../../view_models/user_view_model.dart';

class Clientlistdashboard1 extends StatefulWidget {
  @override
  _Clientlistdashboard1 createState() => _Clientlistdashboard1();
}

class _Clientlistdashboard1 extends State<Clientlistdashboard1>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  UserModel? _userData;

  String? selectClientValue;
  String? selectClientId;
  List<ClientListModel> clientList = [];
  List<String> clientNamesList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChange);
    getUserDetails(context);
    Future.delayed(const Duration(seconds: 2)).then((val) {
      getClientList();
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChange() {
    if (_tabController.index == 0) {
      getClientList();
    } else if (_tabController.index == 1 && selectClientId!=null) {
      getSubClientsList();
    } else if (_tabController.index == 2 && selectClientId!=null) {
      getContactList();
    }
    setState(() {});
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    if (kDebugMode) {
      print(_userData);
    }
  }

  void getClientList() async {
    setLoading(true);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'customer_id': _userData?.data?.customerTrackId,
        'token': _userData?.token,
      };
      final clientViewModel =
          Provider.of<ClientViewModel>(context, listen: false);
      await clientViewModel.getClientListApi(data, context);
      clientList= clientViewModel.clientList;
      clientNamesList= clientList.map((item) => item.cmpName).toList();
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load client list')),
      );
    } finally {
      setLoading(false);
    }
  }

  void getSubClientsList() async {
    // setLoading(true);
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'company_id': selectClientId,
        'token': _userData?.token,
      };
      final clientViewModel =
          Provider.of<ClientViewModel>(context, listen: false);
      await clientViewModel.getSubClientListApi(data, context);
      // setLoading(false);
      Utils.hideLoadingDialog(context);
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load contact list')),
      );
      // setLoading(false);
      Utils.hideLoadingDialog(context);
    }
  }

  void getContactList() async {
    //setLoading(true);
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'client_id': selectClientId,
        'token': _userData?.token,
      };
      final clientViewModel =
          Provider.of<ClientViewModel>(context, listen: false);
      await clientViewModel.getContactListApi(data, context);
      //setLoading(false);
      Utils.hideLoadingDialog(context);
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load contact list')),
      );
      // setLoading(false);
      Utils.hideLoadingDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Client'),
                  Tab(text: 'SubsiDiary'),
                  Tab(text: "Contacts"),
                ],
                indicatorColor: AppColors.secondaryOrange,
                labelColor: AppColors.secondaryOrange,
              ),

              if (_tabController.index != 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0).copyWith(top: 10.0),
                child: CustomDropdown(
                  value: selectClientValue,
                  items: clientNamesList,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectClientValue = newValue;
                      selectClientId = clientList
                          .firstWhere((item) => item.cmpName == newValue)
                          .companyId;
                       if (_tabController.index == 1) {
                      getSubClientsList();
                      } else if (_tabController.index == 2) {
                      getContactList();
                      }
                    });
                  },
                  hint: 'Select Client',
                ),
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    FragmentClientList(),
                    FragmentSubsiDiary(),
                    FragmentContacts(),
                  ],
                ),
              ),
            ],
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

class FragmentClientList extends StatelessWidget {
  FragmentClientList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Consumer<ClientViewModel>(
              builder: (context, clientViewModel, child) {
                final clientList = clientViewModel
                    .clientList; // Assuming you have a List<ClientModel> or similar

                return ListView.separated(
                  itemCount: clientList.length,
                  // Dynamically set item count based on fetched data
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    final client = clientList[index];
                    return CustomClientListTile(
                      client: client
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddClients(),
                  ),
                );
              },
              buttonText: 'Add Client',
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class FragmentSubsiDiary extends StatelessWidget {
  String? selectClientValue;
  String? selectClientId;
  List<ClientListModel> clientList = [];
  List<String> clientNamesList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Consumer<ClientViewModel>(
              builder: (context, clientViewModel, child) {
                final subsDiaryList = clientViewModel.subsDiaryList;

                return ListView.separated(
                  itemCount: subsDiaryList.length,
                  // Dynamically set item count based on fetched data
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    final item = subsDiaryList[index];
                    return CustomSubsidiaryListTile(
                        subClient: item);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Addsubsidiary(),
                  ),
                );
              },
              buttonText: 'Add Subsidiary',
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class FragmentContacts extends StatelessWidget {
  const FragmentContacts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(child: Consumer<ClientViewModel>(
            builder: (context, clientViewModel, child) {
              final contactList = clientViewModel
                  .contactList; // Assuming you have a List<ClientModel> or similar
              return ListView.separated(
                itemCount: contactList.length,
                // Dynamically set item count based on fetched data
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 10);
                },
                itemBuilder: (context, index) {
                  final contact = contactList[index];
                  return CustomContactListTile(
                  contactItem:contact
                  );
                },
              );
            },
          )),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Addcontact(),
                  ),
                );
              },
              buttonText: 'Add Contact',
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class CustomClientListTile extends StatelessWidget {
  final ClientListModel client;

  const CustomClientListTile({
    super.key,
    required this.client
  });

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
                      flex: 4,
                      child: Container(
                          child: Text(
                        client.cmpName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsRegular',
                        ),
                      ))),
                  Expanded(
                      flex: 1,
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
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem(
                                value: 2,
                                child: Text('Delete'),
                              ),
                            ],
                          ).then((value) {
                            if (value != null) {
                              if (value == 1) {
                                 Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Editclients(
                                                client: client
                                            )
                                    )
                                );
                              } else if (value == 2) {
                                Utils.showConfirmationDialog(
                                  context,
                                  message:
                                      "Are you sure you want to delete this client?",
                                  onConfirm: () {
                                    deleteClientApi(context, client.companyId);
                                  },
                                );
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
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text(
                      'Short Name',
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
                      client.cmpName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontFamily: 'PoppinsRegular',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'No of Projects',
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
                      "1",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontFamily: 'PoppinsRegular',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
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
                      'Industry',
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
                      client.industryName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontFamily: 'PoppinsRegular',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
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
                      'Client Contact',
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
                      client.cmpContact,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontFamily: 'PoppinsRegular',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
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
                      'Client Email',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontFamily: 'PoppinsRegular',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      client.cmpEmailid,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontFamily: 'PoppinsRegular',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
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
                      'Location',
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
                      "${client.cmpCity}, ${client.cmpState}, ${client.cmpCountry}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontFamily: 'PoppinsRegular',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deleteClientApi(BuildContext context, String clientId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUserData();
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': userProvider.user?.data?.userId,
        'usr_role_track_id': userProvider.user?.data?.roleTrackId,
        'client_id': clientId,
        'token': userProvider.user?.token,
      };

      final clientViewModel =
          Provider.of<ClientViewModel>(context, listen: false);
      await clientViewModel.deleteClientApi(data, context);
      final clientListDashboardState =
          context.findAncestorStateOfType<_Clientlistdashboard1>();
      clientListDashboardState?.getClientList();
      Utils.hideLoadingDialog(context);
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete this client')),
      );
      Utils.hideLoadingDialog(context);
    }
  }
}

class CustomSubsidiaryListTile extends StatelessWidget {
/*  final String shortName;
  final String noOfProjects;
  final String industry;
  final String clientContact;
  final String clientEmail;
  final String location;
  final String entityId;*/
  final ClientSubsDiaryModel subClient;

  const CustomSubsidiaryListTile({
    super.key,
    required this.subClient,
   /* required this.shortName,
    required this.noOfProjects,
    required this.industry,
    required this.clientContact,
    required this.clientEmail,
    required this.location,
    required this.entityId,*/
  });

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
                      flex: 4,
                      child: Container(
                          child: Text(
                            subClient.entityName.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsRegular',
                        ),
                      ))),
                  Expanded(
                      flex: 1,
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
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem(
                                value: 2,
                                child: Text('Delete'),
                              ),
                            ],
                          ).then((value) {
                            if (value != null) {
                              if (value == 1) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditSubsidiary(
                                                subClient:subClient
                                            )
                                    )
                                );
                              } else if (value == 2) {
                                Utils.showConfirmationDialog(
                                  context,
                                  message:
                                      "Are you sure you want to delete this client?",
                                  onConfirm: () {
                                    deleteSubsDiaryApi(context, subClient.entityId.toString());
                                  },
                                );
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
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: const Text(
                        'Short Name',
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
                        subClient.entityName.toString(),
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
                          'No of Projects',
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
                        "1",
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
                          'Industry',
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
                        subClient.industryName.toString(),
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
                          'Client Contract',
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
                        subClient.entityPhone.toString(),
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
                          'Client Email',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsRegular',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )),
                  Expanded(
                      child: Text(
                    subClient.entityEmail.toString(),
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
                          'Location',
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
                        "${subClient.city} ${subClient.state} ${subClient.country}",
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
  void deleteSubsDiaryApi(BuildContext context, String entityId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUserData();
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': userProvider.user?.data?.userId,
        'usr_role_track_id': userProvider.user?.data?.roleTrackId,
        'sub_client_id': entityId,
        'token': userProvider.user?.token,
      };

      final clientViewModel =
      Provider.of<ClientViewModel>(context, listen: false);
      await clientViewModel.deleteSubClientApi(data, context);
      final clientListDashboardState =
      context.findAncestorStateOfType<_Clientlistdashboard1>();
      clientListDashboardState?.getSubClientsList();
      Utils.hideLoadingDialog(context);
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete this Sub client')),
      );
      Utils.hideLoadingDialog(context);
    }
  }
}

class CustomContactListTile extends StatelessWidget {
  final ContactListModel contactItem;
  /*final String contactName;
  final String contactDesignation;
  final String contactEmail;
  final String contactMobile;
  final String contactId;*/

  const CustomContactListTile({
    super.key,
    required this.contactItem,
    /*required this.contactName,
    required this.contactDesignation,
    required this.contactEmail,
    required this.contactMobile,
    required this.contactId,*/
  });

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
                      flex: 4,
                      child: Container(
                          child: Text(
                            contactItem.clientName.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsRegular',
                        ),
                      ))),
                  Expanded(
                      flex: 1,
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
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem(
                                value: 2,
                                child: Text('Delete'),
                              ),
                            ],
                          ).then((value) {
                            if (value != null) {
                              if (value == 1) {
                                 Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditContact(
                                              contactDetails:contactItem
                                            )
                                    )
                                );
                              } else if (value == 2) {
                                Utils.showConfirmationDialog(
                                  context,
                                  message:
                                      "Are you sure you want to delete this Contact?",
                                  onConfirm: () {
                                    deleteContactApi(context, contactItem.contactId);
                                  },
                                );
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
                ],
              ),
              SizedBox(height: 10),
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
                        contactItem.clientName.toString(),
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
                        contactItem.contactDesignation.toString(),
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
                          'Email',
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
                        contactItem.contactEmail.toString(),
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
                  const Expanded(
                      flex: 1,
                      child: Text(
                        'Mobile',
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
                        contactItem.contactMobile.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
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
    );
  }

  void deleteContactApi(BuildContext context, contactId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUserData();
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': userProvider.user?.data?.userId,
        'usr_role_track_id': userProvider.user?.data?.roleTrackId,
        'contact_id': contactId,
        'token': userProvider.user?.token,
      };

      final clientViewModel =
          Provider.of<ClientViewModel>(context, listen: false);
      await clientViewModel.deleteClientContactApi(data, context);
      final clientListDashboardState =
          context.findAncestorStateOfType<_Clientlistdashboard1>();
      clientListDashboardState?.getContactList();
      Utils.hideLoadingDialog(context);
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete this Sub client')),
      );
      Utils.hideLoadingDialog(context);
    }
  }
}

class DividerColor extends StatelessWidget {
  const DividerColor({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: AppColors.grey,
      height: 0.5,
    );
  }
}
