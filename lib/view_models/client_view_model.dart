import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intrasense/model/client_subs_diary_model.dart';
import 'package:intrasense/repository/client_repository.dart';

import '../model/client_list_model.dart';
import '../model/contact_list_model.dart';
import '../utils/Utils.dart';

class ClientViewModel with ChangeNotifier{
  final _myRepo = ClientRepository();
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> addClientsApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    _myRepo.addClientsApi(data,context).then((onValue) {
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

  List<ClientListModel> _clientList = [];
  List<ClientListModel> get clientList => _clientList;
  Future<List<ClientListModel>?> getClientListApi(dynamic data,BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }

    try{
      var response = await _myRepo.getClientListApi(data,context);
      List<ClientListModel> list = (response['data'] as List)
          .map((group) => ClientListModel.fromJson(group))
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

  Future<void> deleteClientApi(dynamic data, BuildContext context) async {
    if (kDebugMode) {
      print("Api params---$data");
    }
    await  _myRepo.deleteClientApi(data,context).then((onValue) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---$onValue");
      }
      Map<String, dynamic> response = onValue as Map<String, dynamic>;
      Utils.toastMessage(response['message']);

    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
      Utils.toastMessage(error.toString());
    });
  }


  Future<void> addSubClientApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    _myRepo.addSubClientApi(data,context).then((onValue) {
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
        print("Api Error---$error");
      }
      Utils.toastMessage(error.toString());
    });
  }

  List<ClientSubsDiaryModel> _subsDiaryList = [];
  List<ClientSubsDiaryModel> get subsDiaryList => _subsDiaryList;
  Future<List<ClientSubsDiaryModel>?> getSubClientListApi(dynamic data,BuildContext context) async {
    setLoading(true);
    try{
      var response = await _myRepo.getSubClientListApi(data,context);
      List<ClientSubsDiaryModel> subsidiaryList = (response['data'] as List)
          .map((employee) => ClientSubsDiaryModel.fromJson(employee))
          .toList();
      _subsDiaryList = subsidiaryList;

      notifyListeners();

      setLoading(false);
      if (kDebugMode) {
        print("Api Response---" + response.toString());
      }
      return subsidiaryList;
    }
    catch (error) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Error--" + error.toString());
      }
      Utils.toastMessage(error.toString());
      return null;
    }

    /*_myRepo.getSubClientListApi(data,context).then((onValue) {
      if (kDebugMode) {
        print("Api Params---$data");
        print("Api Response---$onValue");
      }
      List<dynamic> dataList = onValue['data'] as List<dynamic>;
      List<ClientSubsDiaryModel> subsDiaryList = dataList
          .map((json) => ClientSubsDiaryModel.fromJson(json as Map<String, dynamic>))
          .toList();
      _subsDiaryList = subsDiaryList;
      notifyListeners();
      setLoading(false);

    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Error---$error");
      }
      Utils.toastMessage(error.toString());
    });*/
  }



  Future<void> deleteSubClientApi(dynamic data, BuildContext context) async {
    if (kDebugMode) {
      print("Api params---$data");
    }
    await  _myRepo.deleteSubClientApi(data,context).then((onValue) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---$onValue");
      }
      Map<String, dynamic> response = onValue as Map<String, dynamic>;
      Utils.toastMessage(response['message']);

    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
      Utils.toastMessage(error.toString());
    });
  }

  Future<void> addContactApi(dynamic data, BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      print("Api params---$data");
    }
    _myRepo.addContactApi(data,context).then((onValue) {
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
        print("Api Error---$error");
      }
      Utils.toastMessage(error.toString());
    });
  }

  List<ContactListModel> _contactList = [];
  List<ContactListModel> get contactList => _contactList;
  Future<List<ContactListModel>?> getContactListApi(dynamic data,BuildContext context) async {
    setLoading(true);
    try{
      var response = await _myRepo.getContactListApi(data,context);
      List<ContactListModel> contactList = (response['data'] as List)
          .map((employee) => ContactListModel.fromJson(employee))
          .toList();
      _contactList = contactList;

      notifyListeners();

      setLoading(false);
      if (kDebugMode) {
        print("Api Response---" + response.toString());
      }
      return contactList;
    }
    catch (error) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Error--" + error.toString());
      }
      Utils.toastMessage(error.toString());
      return null;
    }


    /*_myRepo.getContactListApi(data).then((onValue) {
      if (kDebugMode) {
        print("Api Response--"+onValue.toString());
      }
      List<dynamic> dataList = onValue['data'] as List<dynamic>;

      List<ContactListModel> contactList = dataList
          .map((json) => ContactListModel.fromJson(json as Map<String, dynamic>))
          .toList();
      _contactList = contactList;

      notifyListeners();
      setLoading(false);

    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Error--"+error.toString());
      }
      Utils.toastMessage(error.toString());
    });*/
  }

  Future<void> deleteClientContactApi(dynamic data, BuildContext context) async {
    if (kDebugMode) {
      print("Api params---$data");
    }
    await  _myRepo.deleteClientContactApi(data,context).then((onValue) {
      setLoading(false);
      if (kDebugMode) {
        print("Api Response---$onValue");
      }
      Map<String, dynamic> response = onValue as Map<String, dynamic>;
      Utils.toastMessage(response['message']);

    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
      Utils.toastMessage(error.toString());
    });
  }
}