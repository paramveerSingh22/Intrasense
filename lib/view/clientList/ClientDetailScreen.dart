import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/utils/Constants.dart';

import '../../model/client_list_model.dart';
import '../../model/client_subs_diary_model.dart';
import '../../model/contact_list_model.dart';
import '../../model/country_list_model.dart';
import '../../model/industry_list_model.dart';
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
import '../../view_models/client_view_model.dart';
import '../../view_models/common_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';

import 'AddContact.dart';
import 'AddSubsidiary.dart';
import 'EditContact.dart';
import 'EditSubsidiary.dart';

class ClientDetailScreen extends StatefulWidget {
  final dynamic clientDetail;

  const ClientDetailScreen({Key? key, this.clientDetail}) : super(key: key);

  @override
  _ClientDetailScreen createState() => _ClientDetailScreen();
}

class _ClientDetailScreen extends State<ClientDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String headerTitle = "Subsidiary List";
  String? selectClientId;


  @override
  void initState() {
    selectClientId = widget.clientDetail.companyId;
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
      headerTitle = "Subsidiary List";
    } else if (_tabController.index == 1) {
      headerTitle = "Contact List";
      //getContactList();
    }
    setState(() {});
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
            top: 100.0,
            // Adjust this as needed based on your layout
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'SUBSIDIARY'),
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
                      FragmentSubsiDiary(clientDetail: widget.clientDetail),
                      FragmentContacts(clientDetail: widget.clientDetail),
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

class FragmentSubsiDiary extends StatefulWidget {
  final dynamic clientDetail;

  FragmentSubsiDiary({
    Key? key,
    this.clientDetail,
  }) : super(key: key);

  @override
  _FragmentSubsiDiary createState() => _FragmentSubsiDiary();

}
class _FragmentSubsiDiary extends State<FragmentSubsiDiary>{
  List<ClientSubsDiaryModel> subsidiaryList = [];
  List<ClientSubsDiaryModel> filteredSubsidiaryList = [];
  TextEditingController searchController = TextEditingController();
  bool _isLoading = false;
  UserModel? _userData;
  String? selectCountryValue;
  List<CountryListModel> countryList = [];
  List<String> countryNamesList = [];

  String? selectedIndustryId;
  String? selectIndustryValue;
  List<IndustryListModel> industryList = [];
  List<String> industryNamesList = [];

  TextEditingController SubsidiaryNameFilterController = TextEditingController();

  @override
  void initState() {
    searchController.addListener(_filterList);
    super.initState();
    getUserDetails(context);
    fetchCountries();
    fetchIndustries();
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  void fetchCountries() async {
    final commonViewModel =
    Provider.of<CommonViewModel>(context, listen: false);
    await commonViewModel.countryListApi(context);
    setState(() {
      countryList = commonViewModel.countryList;
      countryNamesList =
          countryList.map((country) => country.countryName).toList();
    });
  }

  void fetchIndustries() async {
    final commonViewModel =
    Provider.of<CommonViewModel>(context, listen: false);
    await commonViewModel.industryListApi(context);
    setState(() {
      industryList = commonViewModel.industryList;
      industryNamesList =
          industryList.map((industry) => industry.type.toString()).toList();
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

  void _filterList() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredSubsidiaryList = subsidiaryList
          .where((item) =>
      item.industryName.toString().toLowerCase().contains(query) ||
          item.entityName.toString().toLowerCase().contains(query) ||
          item.entityPhone.toString().toLowerCase().contains(query) ||
          item.entityEmail.toString().toLowerCase().contains(query) ||
          item.city.toString().toLowerCase().contains(query) ||
          item.state.toString().toLowerCase().contains(query) ||
          item.country.toString().toLowerCase().contains(query))
          .toList();
    });
  }

  void getSubClientsList(
      [String? subsidiaryName, String? industry, String? location]) async {
    setLoading(true);
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'company_id': widget.clientDetail.companyId,
        'subsidiaryName': subsidiaryName ?? "",
        'industry_id': industry ?? "",
        'locationName': location ?? "",
        'token': _userData?.token,
      };
      final clientViewModel =
      Provider.of<ClientViewModel>(context, listen: false);
      final response = await clientViewModel.getSubClientListApi(data, context);
      setState(() {
        if (response != null) {
          subsidiaryList = response.toList();
          filteredSubsidiaryList = subsidiaryList;
        }
      });

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

  void openFilterDialog() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final clientViewModel = Provider.of<ClientViewModel>(context);
        return SingleChildScrollView(
          // Make the content scrollable
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            // Add bottom padding to ensure content doesn't get cut off
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
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Subsidiary Name',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: CustomTextField(
                    controller: SubsidiaryNameFilterController,
                    hintText: 'Subsidiary Name',
                  ),
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Select Industry',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: CustomDropdown(
                    value: selectIndustryValue,
                    items: industryNamesList,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectIndustryValue = newValue;
                        selectedIndustryId = industryList
                            .firstWhere((industry) => industry.type == newValue)
                            .id;
                      });
                    },
                    hint: 'Select Industry',
                  ),
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Select Location',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: CustomDropdown(
                    value: selectCountryValue,
                    items: countryNamesList,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectCountryValue = newValue;
                      });
                    },
                    hint: 'Select Location',
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 10,
                          child: ButtonOrangeBorder(
                            onPressed: () {
                              SubsidiaryNameFilterController.text = "";
                              if (selectIndustryValue != null) {
                                selectIndustryValue = null;
                                selectedIndustryId = null;
                              }
                              if (selectCountryValue != null) {
                                selectCountryValue = null;
                              }
                              Navigator.pop(context);
                              getSubClientsList();
                            },
                            buttonText: 'Clear',
                          )),
                      const SizedBox(width: 10),
                      Expanded(
                          flex: 10,
                          child: CustomElevatedButton(
                            onPressed: () async {
                              var subsidiaryName = "";
                              var industry = "";
                              var location = "";

                              if (SubsidiaryNameFilterController
                                  .text.isNotEmpty) {
                                subsidiaryName = SubsidiaryNameFilterController
                                    .text
                                    .toString();
                              }
                              if (selectIndustryValue != null) {
                                industry = selectedIndustryId.toString();
                              }
                              if (selectCountryValue != null) {
                                location = selectCountryValue.toString();
                              }
                              Navigator.pop(context);
                              getSubClientsList(
                                  subsidiaryName, industry, location);
                            },
                            buttonText: 'SEARCH',
                            //loading: clientViewModel.loading,
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
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

      final clientViewModel = Provider.of<ClientViewModel>(context, listen: false);
      await clientViewModel.deleteSubClientApi(data, context);
      getSubClientsList();
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0,right:20.0,top: 10.0),
            child: Row(
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
                    openFilterDialog();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<ClientViewModel>(
              builder: (context, clientViewModel, child) {
                if (filteredSubsidiaryList.isEmpty) {
                  return const Center(
                      child: Text(
                    'No data found',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'PoppinsMedium',
                    ),
                  ));
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ListView.separated(
                    itemCount: filteredSubsidiaryList.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      final item = filteredSubsidiaryList[index];
                      return CustomSubsidiaryListTile(
                          item: item,
                          clientDetail: widget.clientDetail,
                          userData: _userData,
                          onDelete: () {
                            deleteSubsDiaryApi(
                                context, item.entityId.toString());
                          },
                      onUpdate:(){
                            getSubClientsList();
                      });
                    },
                  ),
                );
              },
            ),
          ),
          if (_userData?.data?.roleTrackId.toString() ==
              Constants.roleProjectManager) ...{
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Addsubsidiary(
                      clientDetail:widget.clientDetail
                    )),
                  );
                  if (result == true) {
                    getSubClientsList();
                  }
                },
                buttonText: 'Add Subsidiary',
              ),
            ),
            const SizedBox(height: 20),
          }
        ],
      ),
    );
  }

}

class CustomSubsidiaryListTile extends StatelessWidget {
  final ClientSubsDiaryModel item;
  final ClientListModel clientDetail;
  final UserModel? userData;
  final Function onDelete;
  final Function onUpdate;

  const CustomSubsidiaryListTile(
      {super.key,
        required this.item,
        required this.clientDetail,
        required this.userData,
        required this.onDelete,
        required this.onUpdate,
      });

  @override
  Widget build(BuildContext context) {
    final clientViewModel = Provider.of<ClientViewModel>(context);

    void subsidiaryDetailDialog() {
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              // Add bottom padding to ensure content doesn't get cut off
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
                        Text(
                          'SUBSIDIARY DETAIL - ${item.entityName}',
                          style: const TextStyle(
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
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'Client Name',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Expanded(
                            flex: 1,
                            child: Text(
                              ":",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium',
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: Text(
                              clientDetail.cmpName.toString(),
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
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'Subsidiary Name',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Expanded(
                            flex: 1,
                            child: Text(
                              ":",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium',
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 2,
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
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 3,
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
                        const Expanded(
                            flex: 1,
                            child: Text(
                              ":",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium',
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 2,
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
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'Contact',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Expanded(
                            flex: 1,
                            child: Text(
                              ":",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium',
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 2,
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
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Expanded(
                            flex: 1,
                            child: Text(
                              ":",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium',
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 2,
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
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'Address',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Expanded(
                            flex: 1,
                            child: Text(
                              ":",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium',
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: Text(
                              "${item.entityAddress},${item.city},${item.state},${item.country},${item.postalCode}",
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
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 3,
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
                        const Expanded(
                            flex: 1,
                            child: Text(
                              ":",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium',
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: Text(
                              item.country.toString(),
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      );
    }

    void deleteSubsidiaryPopUp(BuildContext context) {
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
                        'Delete Subsidiary',
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
                      'Delete Subsidiary!',
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColors.skyBlueTextColor,
                          fontFamily: 'PoppinsRegular'),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Are you sure, you wan't be able to revert this!",
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
                          loading: clientViewModel.loading,
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
                                        subsidiaryDetailDialog();
                                      }),
                                ],
                              )),
                        ),
                        if (userData?.data?.roleTrackId.toString() ==
                            Constants.roleProjectManager) ...{
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
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditSubsidiary(
                                                        subClient:item,
                                                        clientDetail:clientDetail
                                                    )
                                            )
                                        );
                                        if (result == true) {
                                          onUpdate();
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
                                        deleteSubsidiaryPopUp(context);
                                      },
                                    ),
                                  ],
                                )),
                          )
                        }
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

class FragmentContacts extends StatefulWidget {

  final dynamic clientDetail;

  FragmentContacts({
    Key? key,
    this.clientDetail,
  }) : super(key: key);


  @override
  _FragmentContacts createState() => _FragmentContacts();

}

class _FragmentContacts extends State<FragmentContacts>{

  bool _isLoading = false;
  UserModel? _userData;
  List<ContactListModel> contactList = [];
  List<ContactListModel> filteredContactList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    searchController.addListener(_filterList);
    super.initState();
    getUserDetails(context);
  }

  void _filterList() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredContactList = contactList
          .where((item) =>
      item.contactName.toString().toLowerCase().contains(query) ||
          item.contactDesignation.toString().toLowerCase().contains(query) ||
          item.contactName.toString().toLowerCase().contains(query) ||
          item.contactEmail.toString().toLowerCase().contains(query))
          .toList();
    });
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    if (kDebugMode) {
      print(_userData);
    }
    getContactList();
  }

  void getContactList() async {
    //setLoading(true);
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'client_id': widget.clientDetail.companyId,
        'token': _userData?.token,
      };
      final clientViewModel = Provider.of<ClientViewModel>(context, listen: false);
     final response=  await clientViewModel.getContactListApi(data, context);
      setState(() {
        if (response != null) {
          contactList = response.toList();
          filteredContactList = contactList;
        }
      });

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
      getContactList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0,right:20.0,top: 10.0),
            child: Row(
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
                )
              ],
            ),
          ),

          Expanded(child: Consumer<ClientViewModel>(
            builder: (context, clientViewModel, child) {

              if (filteredContactList.isEmpty) {
                return const Center(
                    child: Text(
                  'No data found',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'PoppinsMedium',
                  ),
                ));
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListView.separated(
                  itemCount: filteredContactList.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    final contact = filteredContactList[index];
                    return CustomContactListTile(
                        item: contact, userData: _userData,
                        clientDetail: widget.clientDetail,
                        onDelete: () {
                          deleteContactApi(
                              context, contact.contactId.toString());
                        },
                        onUpdate:(){
                          getContactList();
                        }
                    );
                  },
                ),
              );
            },
          )),
          if (_userData?.data?.roleTrackId.toString() ==
              Constants.roleProjectManager) ...{
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomElevatedButton(
                onPressed:() async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Addcontact(
                        clientDetail:widget.clientDetail
                    )),
                  );
                  if (result == true) {
                    getContactList();
                  }
                },
                buttonText: 'Add Contact',
              ),
            ),
            const SizedBox(height: 20),
          }
        ],
      ),
    );
  }
}

class CustomContactListTile extends StatelessWidget {
  final ContactListModel item;
  final ClientListModel clientDetail;
  final UserModel? userData;
  final Function onDelete;
  final Function onUpdate;

  const CustomContactListTile(
      {super.key,
        required this.item,
        required this.clientDetail,
        required this.userData,
        required this.onDelete,
        required this.onUpdate,
      });

  @override
  Widget build(BuildContext context) {
    final clientViewModel = Provider.of<ClientViewModel>(context);

    void contactDetailDialog() {
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
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
                        Text(
                          'Contact DETAIL - ${item.contactName}',
                          style: const TextStyle(
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
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'Client Name',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Expanded(
                            flex: 1,
                            child: Text(
                              ":",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium',
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 2,
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
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'Contact Name',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Expanded(
                            flex: 1,
                            child: Text(
                              ":",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium',
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: Text(
                              item.contactName.toString(),
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
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'Designation',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Expanded(
                            flex: 1,
                            child: Text(
                              ":",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium',
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 2,
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
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Expanded(
                            flex: 1,
                            child: Text(
                              ":",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium',
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 2,
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
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'Mobile',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Expanded(
                            flex: 1,
                            child: Text(
                              ":",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium',
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 2,
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      );
    }

    void deleteContactPopUp(BuildContext context) {
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
                        'Delete Contact',
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
                      'Delete Contact!',
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColors.skyBlueTextColor,
                          fontFamily: 'PoppinsRegular'),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Are you sure, you wan't be able to revert this!",
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
                          loading: clientViewModel.loading,
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
                                        contactDetailDialog();
                                      }),
                                ],
                              )),
                        ),
                        if (userData?.data?.roleTrackId.toString() ==
                            Constants.roleProjectManager) ...{
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
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditContact(
                                                        contactDetails:item,
                                                        clientDetail:clientDetail
                                                    )
                                            )
                                        );
                                        if (result == true) {
                                          onUpdate();
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
                                        deleteContactPopUp(context);
                                      },
                                    ),
                                  ],
                                )),
                          )
                        }
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
