import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intrasense/model/country_list_model.dart';
import 'package:intrasense/model/industry_list_model.dart';
import 'package:intrasense/repository/common_repository.dart';

import '../utils/Utils.dart';

class CommonViewModel with ChangeNotifier{
  final _myRepo = CommonRepository();
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  List<CountryListModel> _countryList = [];
  List<CountryListModel> get countryList => _countryList;
  Future<void> countryListApi(BuildContext context) async {
    setLoading(true);
    try {
      final onValue = await _myRepo.countryListApi();
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
      final onValue = await _myRepo.industryListApi();
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
}