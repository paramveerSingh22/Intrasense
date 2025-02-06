import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../model/client_list_model.dart';
import '../../model/client_subs_diary_model.dart';
import '../../model/contact_list_model.dart';
import '../../model/user_model.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomSearchTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/UserProvider.dart';
import '../../view_models/client_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';

import 'AddContact.dart';
import 'AddSubsidiary.dart';
import 'EditContact.dart';
import 'EditSubsidiary.dart';

class ClientDetailScreen extends StatefulWidget{
  final dynamic clientId;
  const ClientDetailScreen({Key? key, this.clientId}) : super(key: key);

  @override
 _ClientDetailScreen createState() => _ClientDetailScreen();
}
class _ClientDetailScreen extends State<ClientDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  UserModel? _userData;
  TextEditingController searchController = TextEditingController();

  String headerTitle= "Subsidiary List";

  String? selectClientValue;
  String? selectClientId;
  List<String> clientNamesList = [];

  @override
  void initState() {
    selectClientId= widget.clientId;
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChange);
    getUserDetails(context);

  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChange() {
    if (_tabController.index == 0 && selectClientId!=null) {
      getSubClientsList();
      headerTitle="Subsidiary List";
    } else if (_tabController.index == 1 && selectClientId!=null) {
      headerTitle="Contact List";
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
    getSubClientsList();
  }

  void getSubClientsList() async {
    setLoading(true);
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'company_id': selectClientId,
        'token': _userData?.token,
      };
      final clientViewModel = Provider.of<ClientViewModel>(context, listen: false);
      await clientViewModel.getSubClientListApi(data, context);
       setLoading(false);
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
      final clientViewModel = Provider.of<ClientViewModel>(context, listen: false);
      await clientViewModel.getContactListApi(data, context);
      Utils.hideLoadingDialog(context);
    } catch (error) {
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
                  headerTitle,
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
                            IconButton(
                              icon: SizedBox(
                                height: 45,
                                width: 45,
                                child: Image.asset(Images.filterIcon),
                              ),
                              onPressed: () {
                                //openFilterDialog();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 180.0, // Adjust this as needed based on your layout
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'SUBSIDAIRY'),
                    Tab(text: "VIEW CONTACT"),
                  ],
                  indicatorColor: AppColors.secondaryOrange,
                  labelColor: AppColors.secondaryOrange,
                ),
                DividerColor(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      FragmentSubsiDiary(),
                      FragmentContacts(),
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
          Expanded(
            child: Consumer<ClientViewModel>(
              builder: (context, clientViewModel, child) {
                final subsDiaryList = clientViewModel.subsDiaryList;

                if (subsDiaryList.isEmpty) {
                  return const Center(
                    child: Text(
                      'No data found',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'PoppinsMedium',
                      ),
                    )
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ListView.separated(
                    itemCount: subsDiaryList.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      final item = subsDiaryList[index];
                      return CustomSubsidiaryListTile(
                          item: item);
                    },
                  ),
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
          Expanded(child: Consumer<ClientViewModel>(
            builder: (context, clientViewModel, child) {
              final contactList = clientViewModel.contactList;

              if (contactList.isEmpty) {
                return const Center(
                    child: Text(
                      'No data found',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'PoppinsMedium',
                      ),
                    )
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListView.separated(
                  itemCount: contactList.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    final contact = contactList[index];
                    return CustomContactListTile(
                        item:contact
                    );
                  },
                ),
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

class CustomSubsidiaryListTile extends StatelessWidget {
  final ClientSubsDiaryModel item;

  const CustomSubsidiaryListTile(
      {super.key, required this.item});

  @override
  Widget build(BuildContext context) {
   /* final leaveViewModel = Provider.of<ClientViewModel>(context);

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
                            // onDelete();
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
    }*/

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
                              item.entityName.toString(),
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
                                        /*Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ClientDetailScreen(
                                                      clientId: item.companyId)),
                                        );*/
                                      }),
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
                                      child: Image.asset(Images.editIcon),
                                    ),
                                    onPressed: () async {


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
                                      // deleteLeavePopUp(context);

                                    },
                                  ),
                                ],
                              )),
                        )

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
                              item.entityName.toString(),
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
                                  'Industry',
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
                              item.industryName.toString(),
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
                                'Contact',
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
                              item.entityPhone.toString(),
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
                              item.entityEmail.toString(),
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
                              "${item.city} ${item.state} ${item.country}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
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

/*class CustomSubsidiaryListTile extends StatelessWidget {
  final ClientSubsDiaryModel subClient;

  const CustomSubsidiaryListTile({
    super.key,
    required this.subClient,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration:  BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
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
      final clientListDashboardState = context.findAncestorStateOfType<_ClientDetailScreen>();
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
}*/


class CustomContactListTile extends StatelessWidget {
  final ContactListModel item;

  const CustomContactListTile(
      {super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    /*final leaveViewModel = Provider.of<ClientViewModel>(context);

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
                            // onDelete();
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
    }*/

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
                              item.clientName.toString(),
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
                                       /* Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ClientDetailScreen(
                                                      clientId: item.companyId)),
                                        );*/
                                      }),
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
                                      child: Image.asset(Images.editIcon),
                                    ),
                                    onPressed: () async {


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
                                      // deleteLeavePopUp(context);

                                    },
                                  ),
                                ],
                              )),
                        )

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
                              item.clientName.toString(),
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
                                  'Designation',
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
                              item.contactDesignation.toString(),
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
                                'Contact',
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
                              item.contactMobile.toString(),
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
                              item.contactEmail.toString(),
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


/*class CustomContactListTile extends StatelessWidget {
  final ContactListModel contactItem;

  const CustomContactListTile({
    super.key,
    required this.contactItem,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration:  BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
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
      context.findAncestorStateOfType<_ClientDetailScreen>();
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
}*/

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