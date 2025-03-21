import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intrasense/model/country_list_model.dart';
import 'package:intrasense/model/industry_list_model.dart';
import 'package:intrasense/repository/common_repository.dart';

import '../model/TimeZoneModel.dart';
import '../utils/Utils.dart';

class CommonViewModel with ChangeNotifier{
  final _myRepo = CommonRepository();
  bool _loading = false;
  bool get loading => _loading;
  String? imagePath;


  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  List<CountryListModel> _countryList = [];
  List<CountryListModel> get countryList => _countryList;
  Future<void> countryListApi(BuildContext context) async {
    setLoading(true);
    try {
      final onValue = await _myRepo.countryListApi(context);
      if (kDebugMode) {
        print("Api Response--" + onValue.toString());
      }
      List<dynamic> dataList = onValue['data'] as List<dynamic>;
      List<CountryListModel> countryList = dataList
          .map((json) =>
          CountryListModel.fromJson(json as Map<String, dynamic>))
          .toList();
      _countryList = countryList;
      notifyListeners();
    }
    catch (error, stackTrace) {
      if (kDebugMode) {
        print("Api Error--" + error.toString());
      }
      Utils.toastMessage(error.toString());
    } finally {
      setLoading(false);
    }
  }

  List<IndustryListModel> _industryList = [];
  List<IndustryListModel> get industryList => _industryList;
  Future<void> industryListApi(BuildContext context) async {
    setLoading(true);
    try {
      final onValue = await _myRepo.industryListApi(context);
      if (kDebugMode) {
        print("Api Response--" + onValue.toString());
      }
      List<dynamic> dataList = onValue['data'] as List<dynamic>;
      List<IndustryListModel> industryList = dataList
          .map((json) =>
          IndustryListModel.fromJson(json as Map<String, dynamic>))
          .toList();
      _industryList = industryList;
      notifyListeners();
    }
    catch (error, stackTrace) {
      if (kDebugMode) {
        print("Api Error--" + error.toString());
      }
      Utils.toastMessage(error.toString());
    } finally {
      setLoading(false);
    }
  }

  List<String> _timeZoneList = [];
  List<String> get timeZoneList => _timeZoneList;

  Future<void> timeZoneListApi(BuildContext context) async {
    setLoading(true);
    try {
      final onValue = await _myRepo.timeZoneListApi(context);
      if (kDebugMode) {
        print("Api Response--" + onValue.toString());
      }
      List<dynamic> dataList = onValue['data'] as List<dynamic>;
      _timeZoneList = List<String>.from(dataList);
      notifyListeners();
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print("Api Error--" + error.toString());
      }
      Utils.toastMessage(error.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<String?> commonImageUploadApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }

    try {
      var onValue = await _myRepo.commonImageUploadApi(data, context);  // Wait for the API response
      setLoading(false);

      if (kDebugMode) {
        print("Api Response---$onValue");
      }

      Map<String, dynamic> response = onValue as Map<String, dynamic>;
      Utils.toastMessage(response['message']);

      if (response['status'] == true) {
        // Return the image path or any other data you need
        String imagePath = response['data'] ?? ''; // Safely handle null
        return imagePath;  // Return the image path to the caller
      } else {
        return null;  // Return null if status is not true
      }
    } catch (error) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Error---" + error.toString());
      }
      Utils.toastMessage(error.toString());
      return null;  // Return null if an error occurs
    }
  }

}