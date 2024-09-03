/*class UserModel {
  Data? data;
  String? token;

  UserModel({this.data, this.token});

  UserModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class Data {
  String? userId;
  String? usrFirstName;
  String? usrLastName;
  String? usrTeamTrackId;
  String? usrEmail;
  bool? isLoggedIn;
  String? usrRoleTrackId;
  String? usrCustomerTrackId;
  String? userType;
  String? canCreate;
  String? canView;
  String? canApprove;
  String? canSupport;

  Data(
      {this.userId,
        this.usrFirstName,
        this.usrLastName,
        this.usrTeamTrackId,
        this.usrEmail,
        this.isLoggedIn,
        this.usrRoleTrackId,
        this.usrCustomerTrackId,
        this.userType,
        this.canCreate,
        this.canView,
        this.canApprove,
        this.canSupport});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    usrFirstName = json['usr_first_name'];
    usrLastName = json['usr_last_name'];
    usrTeamTrackId = json['usr_team_track_id'];
    usrEmail = json['usr_email'];
    isLoggedIn = json['is_logged_in'];
    usrRoleTrackId = json['usr_role_track_id'];
    usrCustomerTrackId = json['usr_customer_track_id'];
    userType = json['user_type'];
    canCreate = json['can_create'];
    canView = json['can_view'];
    canApprove = json['can_approve'];
    canSupport = json['can_support'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['usr_first_name'] = this.usrFirstName;
    data['usr_last_name'] = this.usrLastName;
    data['usr_team_track_id'] = this.usrTeamTrackId;
    data['usr_email'] = this.usrEmail;
    data['is_logged_in'] = this.isLoggedIn;
    data['usr_role_track_id'] = this.usrRoleTrackId;
    data['usr_customer_track_id'] = this.usrCustomerTrackId;
    data['user_type'] = this.userType;
    data['can_create'] = this.canCreate;
    data['can_view'] = this.canView;
    data['can_approve'] = this.canApprove;
    data['can_support'] = this.canSupport;
    return data;
  }
}*/

class UserModel {
  final String? token;
  final UserData? data;

  UserModel({
    this.data,
     this.token,

  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      data: UserData.fromJson(json['data']),
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'token': token,
    };
  }
}

class UserData {
   String? userId;
   String? firstName;
   String? lastName;
   String? teamTrackId;
   String? email;
   bool? isLoggedIn;
   String? roleTrackId;
   String? customerTrackId;
   String? userType;
   String? canCreate;
   String? canView;
   String? canApprove;
   String? canSupport;

  UserData({
     this.userId,
     this.firstName,
     this.lastName,
     this.teamTrackId,
     this.email,
     this.isLoggedIn,
     this.roleTrackId,
     this.customerTrackId,
     this.userType,
     this.canCreate,
     this.canView,
     this.canApprove,
     this.canSupport,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['user_id'],
      firstName: json['usr_first_name'],
      lastName: json['usr_last_name'],
      teamTrackId: json['usr_team_track_id'],
      email: json['usr_email'],
      isLoggedIn: json['is_logged_in'],
      roleTrackId: json['usr_role_track_id'],
      customerTrackId: json['usr_customer_track_id'],
      userType: json['user_type'],
      canCreate: json['can_create'],
      canView: json['can_view'],
      canApprove: json['can_approve'],
      canSupport: json['can_support'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'usr_first_name': firstName,
      'usr_last_name': lastName,
      'usr_team_track_id': teamTrackId,
      'usr_email': email,
      'is_logged_in': isLoggedIn,
      'usr_role_track_id': roleTrackId,
      'usr_customer_track_id': customerTrackId,
      'user_type': userType,
      'can_create': canCreate,
      'can_view': canView,
      'can_approve': canApprove,
      'can_support': canSupport,
    };
  }
}
