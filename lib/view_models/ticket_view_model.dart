import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intrasense/model/tickets/TicketDetailModel.dart';
import 'package:intrasense/repository/ticket_repository.dart';

import '../model/tickets/TicketListModel.dart';
import '../utils/Utils.dart';

class TicketViewModel extends ChangeNotifier{

  final _myRepo = TicketRepository();
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<List<TicketListModel>?> getTicketListApi(dynamic data,BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    try{
      var response = await _myRepo.getTicketsListApi(data,context);
      List<TicketListModel> list = (response['data'] as List)
          .map((group) => TicketListModel.fromJson(group))
          .toList();
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---" + response.toString());
      }
      return list;
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

  Future<void> addTicketApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    _myRepo.addTicketApi(data,context).then((onValue) {
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

  Future<void> addTicketCommentApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    _myRepo.addTicketCommentApi(data,context).then((onValue) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---$onValue");
      }
      Map<String, dynamic> response = onValue as Map<String, dynamic>;
     // Utils.toastMessage(response['message']);
      if (response['status'] == true) {

      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
      Utils.toastMessage(error.toString());
    });
  }

  Future<TicketDetailModel?>? getTicketDetailApi(dynamic data,BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    try{
      var response = await _myRepo.getTicketsDetailApi(data,context);
      TicketDetailModel ticketDetail = TicketDetailModel.fromJson(response['data']);
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---" + response.toString());
      }
      return ticketDetail;
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

  Future<void> updateTicketStatusApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    _myRepo.updateTicketStatusApi(data,context).then((onValue) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---$onValue");
      }
      Map<String, dynamic> response = onValue as Map<String, dynamic>;
      Utils.toastMessage(response['message']);
      if (response['status'] == true) {
        //Navigator.pop(context, true);
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
      Utils.toastMessage(error.toString());
    });
  }
}