import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intrasense/model/events/EventDetailsModel.dart';
import 'package:intrasense/model/events/EventListModel.dart';
import 'package:intrasense/repository/event_repository.dart';

import '../utils/Utils.dart';

class EventViewModel with ChangeNotifier{

  final _myRepo = EventRepository();
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<List<EventListModel>?> getEventListApi(dynamic data,BuildContext context) async {
    setLoading(true);
    try{
      print("Api params---" + data.toString());
      var response = await _myRepo.getEventListApi(data,context);
      List<EventListModel> projectList = (response['data'] as List)
          .map((group) => EventListModel.fromJson(group))
          .toList();
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---" + response.toString());
      }
      return projectList;
    }
    catch (error) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Error--" + error.toString());
      }
      Utils.toastMessage(error.toString());
      return null;
    }
  }



  Future<void> addEventApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    _myRepo.addEventApi(data,context).then((onValue) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---$onValue");
      }
      Map<String, dynamic> response = onValue as Map<String, dynamic>;
      Utils.toastMessage(response['message']);
      if (response['status'] == true) {
        Navigator.pop(context, true);
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
      Utils.toastMessage(error.toString());
    });
  }

  Future<void> eventRevertApi(dynamic data, BuildContext context, String eventStatus) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    _myRepo.eventRevertApi(data,context).then((onValue) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---$onValue");
      }
      Map<String, dynamic> response = onValue as Map<String, dynamic>;

      Utils.toastMessage(response['message']);

      if (response['status'] == true) {
        Navigator.pop(context, true);
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
      Utils.toastMessage(error.toString());
    });
  }

  Future<EventDetailsModel?> getEventDetailApi(dynamic data,BuildContext context) async {
    setLoading(true);
    try{
      print("Api params---" + data.toString());
      var response = await _myRepo.getEventDetailApi(data,context);
      EventDetailsModel eventDetail = EventDetailsModel.fromJson(response['data']);

      setLoading(false);
      if (kDebugMode) {
        print("Api Response---" + response.toString());
      }
      return eventDetail;
    }
    catch (error) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Error--" + error.toString());
      }
      Utils.toastMessage(error.toString());
      return null;
    }
  }

}