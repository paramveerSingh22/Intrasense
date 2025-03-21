import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intrasense/model/meeting/MeetingListModel.dart';
import 'package:intrasense/repository/meeting_repository.dart';

import '../model/meeting/MeetingDetailModel.dart';
import '../model/meeting/MeetingGroupListModel.dart';
import '../utils/Utils.dart';

class MeetingViewModel with ChangeNotifier{
  final _myRepo = MeetingRepository();
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<List<MeetingListModel>?> getMeetingListApi(dynamic data,BuildContext context) async {
    setLoading(true);
    try{
      print("Api params---" + data.toString());
      var response = await _myRepo.getMeetingListApi(data,context);
      List<MeetingListModel> projectList = (response['data'] as List)
          .map((group) => MeetingListModel.fromJson(group))
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

  Future<List<MeetingDetailModel>?> getMeetingDetailApi(dynamic data, BuildContext context) async {
    setLoading(true);
    try {
      print("Api params---" + data.toString());
      var response = await _myRepo.getMeetingDetailApi(data, context);
      List<MeetingDetailModel> projectDetailList = (response['data'] as List)
          .map((group) => MeetingDetailModel.fromJson(group))
          .toList();
      setLoading(false);

      if (kDebugMode) {
        print("Api Response---" + response.toString());
      }

      return projectDetailList;
    } catch (error) {
      setLoading(false);

      if (kDebugMode) {
        print("Api Error--" + error.toString());
      }

      Utils.toastMessage(error.toString());
      return null;
    }
  }

  Future<List<MeetingGroupListModel>?> getMeetingGroupListApi(dynamic data, BuildContext context) async {
    setLoading(true);
    try {
      print("Api params---" + data.toString());
      var response = await _myRepo.getMeetingGroupListApi(data, context);
      List<MeetingGroupListModel> groupList = (response['data'] as List)
          .map((group) => MeetingGroupListModel.fromJson(group))
          .toList();
      setLoading(false);

      if (kDebugMode) {
        print("Api Response---" + response.toString());
      }

      return groupList;
    } catch (error) {
      setLoading(false);

      if (kDebugMode) {
        print("Api Error--" + error.toString());
      }

      Utils.toastMessage(error.toString());
      return null;
    }
  }

  Future<void> addMeetingApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    _myRepo.addMeetingApi(data,context).then((onValue) {
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

  Future<void> meetingRevertApi(dynamic data, BuildContext context, String meetingStatus) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    _myRepo.meetingRevertApi(data,context).then((onValue) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---$onValue");
      }
      Map<String, dynamic> response = onValue as Map<String, dynamic>;

      if(meetingStatus=="1"){
        Utils.toastMessage("Meeting accepted");
      }
      else  if(meetingStatus=="2"){
        Utils.toastMessage("Meeting declined");
      }
      else  if(meetingStatus=="3"){
        Utils.toastMessage("Meeting Rescheduled");
      }
      else{
        Utils.toastMessage(response['message']);
      }

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

  Future<void> meetingCancelApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    _myRepo.meetingCancelApi(data,context).then((onValue) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---$onValue");
      }
      Map<String, dynamic> response = onValue as Map<String, dynamic>;

        Utils.toastMessage(response['message']);

      if (response['status'] != null && response['status'] == true) {
        //Navigator.pop(context, true);
      } else {
        print('Error: response or status is null');
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
      //Utils.toastMessage(error.toString());
    });
  }

}