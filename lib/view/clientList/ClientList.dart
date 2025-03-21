import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/model/client_list_model.dart';
import 'package:intrasense/utils/Constants.dart';
import 'package:intrasense/view/clientList/AddClients.dart';
import 'package:intrasense/view/clientList/ClientDetailScreen.dart';
import 'package:intrasense/view_models/client_view_model.dart';

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
import 'package:provider/provider.dart';

import '../../utils/Utils.dart';
import '../../view_models/UserProvider.dart';
import '../../view_models/common_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'EditClients.dart';

class ClientList extends StatefulWidget{
  _ClientList createState() => _ClientList();
}

class _ClientList extends State<ClientList>{
  UserModel? _userData;
  bool _isLoading = false;
  List<ClientListModel> clientList = [];
  List<ClientListModel> filteredList = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController projectNameController = TextEditingController();

  String? selectCountryValue;
  List<CountryListModel> countryList = [];
  List<String> countryNamesList = [];

  String? selectedIndustryId;
  String? selectIndustryValue;
  List<IndustryListModel> industryList = [];
  List<String> industryNamesList = [];

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
      filteredList = clientList
          .where((item) =>
      item.industryName.toString().toLowerCase().contains(query) ||
          item.cmpName.toString().toLowerCase().contains(query) ||
          item.cmpContact.toString().toLowerCase().contains(query)||
          item.cmpEmailid.toString().toLowerCase().contains(query)||
          item.cmpCity.toString().toLowerCase().contains(query)||
          item.cmpState.toString().toLowerCase().contains(query)||
          item.cmpCountry.toString().toLowerCase().contains(query))
          .toList();
    });
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    if (kDebugMode) {
      print(_userData);
    }
    getClientList();
    fetchCountries();
    fetchIndustries();
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  void getClientList([String? projectName,String? industry,String? location]) async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'customer_id': _userData?.data?.customerTrackId,
        'cmp_name': projectName ?? "",
        'cmp_industry': industry ?? "",
        'cmp_country': location ?? "",
        'token': _userData?.token,
      };
      final clientViewModel = Provider.of<ClientViewModel>(context, listen: false);
      final response = await clientViewModel.getClientListApi(data, context);
      setState(() {
        if (response != null) {
          clientList = response.toList();
          filteredList = clientList;
        }
      });
      Utils.hideLoadingDialog(context);
    } catch (error, stackTrace) {
      Utils.hideLoadingDialog(context);
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

  void fetchCountries() async {
    final commonViewModel = Provider.of<CommonViewModel>(context, listen: false);
    await commonViewModel.countryListApi(context);
    setState(() {
      countryList = commonViewModel.countryList;
      countryNamesList= countryList.map((country) => country.countryName).toList();
    });
  }

  void fetchIndustries() async {
    final commonViewModel = Provider.of<CommonViewModel>(context, listen: false);
    await commonViewModel.industryListApi(context);
    setState(() {
      industryList = commonViewModel.industryList;
      industryNamesList= industryList.map((industry) => industry.type.toString()).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                 "Client List",
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
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                                   "Client List",
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
                                    openFilterDialog();
                                  },
                                ),
                              ],
                            ),
                          ],
                        )),

                    Expanded(
                      child: filteredList.isEmpty ? const Center(
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
                            return CustomClientListTile(
                                item: item,
                                onDelete: () {
                                  deleteClientApi(
                                      context, item.companyId.toString());
                                },
                                onUpdate:(){
                                  getClientList();
                                }
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          if(_userData?.data?.roleTrackId.toString()==Constants.roleProjectManager)...{
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
                      MaterialPageRoute(builder: (context) => AddClients()),
                    );
                    if (result == true) {
                      getClientList();
                    }
                  },
                  buttonText: 'ADD CLIENT',
                ),
              ),
            )
          }

        ],
      ),
    );
  }

  void openFilterDialog() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true, // Important to make the content scrollable when keyboard appears
      builder: (BuildContext context) {
        final clientViewModel = Provider.of<ClientViewModel>(context);
        return SingleChildScrollView( // Make the content scrollable
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0), // Add bottom padding to ensure content doesn't get cut off
            child: Column(
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
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Project Name',
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
                    controller: projectNameController,
                    hintText: 'Project Name',
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
                  padding: const EdgeInsets.symmetric(horizontal:  20.0,vertical: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 10,
                          child: ButtonOrangeBorder(
                            onPressed: ()  {
                              projectNameController.text="";
                              if(selectIndustryValue!=null){
                                selectIndustryValue= null;
                                selectedIndustryId= null;
                              }
                              if(selectCountryValue!=null){
                                selectCountryValue= null;
                              }
                              Navigator.pop(context);
                              getClientList();
                            },
                            buttonText: 'Clear',
                          )),
                      const SizedBox(width: 10),
                      Expanded(
                          flex: 10,
                          child: CustomElevatedButton(
                        onPressed: () async {
                          var projectName = "";
                          var industry = "";
                          var location = "";

                          if (projectNameController.text.isNotEmpty) {
                            projectName = projectNameController.text.toString();
                          }
                          if(selectIndustryValue!=null){
                            industry= selectedIndustryId.toString();
                          }
                          if(selectCountryValue!=null){
                            location= selectCountryValue.toString();
                          }
                          Navigator.pop(context);
                          getClientList(projectName,industry,location);

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

      final clientViewModel = Provider.of<ClientViewModel>(context, listen: false);
      await clientViewModel.deleteClientApi(data, context);
      Utils.hideLoadingDialog(context);

      var projectName = "";
      var industry = "";
      var location = "";

      if (projectNameController.text.isNotEmpty) {
        projectName = projectNameController.text.toString();
      }
      if(selectIndustryValue!=null){
        industry= selectedIndustryId.toString();
      }
      if(selectCountryValue!=null){
        location= selectCountryValue.toString();
      }
      Navigator.pop(context);
      getClientList(projectName,industry,location);

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

class CustomClientListTile extends StatelessWidget {
  final ClientListModel item;
  final Function onDelete;
  final Function onUpdate;

  const CustomClientListTile(
      {super.key, required this.item,
        required this.onDelete,
        required this.onUpdate,
      });

  @override
  Widget build(BuildContext context) {
    final leaveViewModel = Provider.of<ClientViewModel>(context);

    void deleteClientPopUp(BuildContext context) {
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
                        'Delete Client',
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
                      'Delete Client!',
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
                             item.industryName.toString(),
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ClientDetailScreen(
                                                      clientDetail: item)),
                                        );
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
                                        final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Editclients(
                                                        client: item
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
                                        deleteClientPopUp(context);

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
                              item.cmpName.toString(),
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
                              item.cmpContact.toString(),
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
                              item.cmpEmailid.toString(),
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
                              "${item.cmpCity} ${item.cmpState} ${item.cmpCountry}",
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