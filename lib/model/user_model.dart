class UserModel {
  final String? token;
  final UserData? data;

  UserModel({
    this.data,
    this.token,
  });

  // Factory method to create an instance from a JSON object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
      token: json['token'] as String?,  // Cast safely as String?
    );
  }

  // Method to convert an instance to a JSON object
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

  // Factory method to create an instance from a JSON object
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['user_id'] as String?,
      firstName: json['usr_first_name'] as String?,
      lastName: json['usr_last_name'] as String?,
      teamTrackId: json['usr_team_track_id'] as String?,
      email: json['usr_email'] as String?,
      isLoggedIn: json['is_logged_in'] as bool?,  // Handle as bool?
      roleTrackId: json['usr_role_track_id'] as String?,
      customerTrackId: json['usr_customer_track_id'] as String?,
      userType: json['user_type'] as String?,
      canCreate: json['can_create'] as String?,
      canView: json['can_view'] as String?,
      canApprove: json['can_approve'] as String?,
      canSupport: json['can_support'] as String?,
    );
  }

  // Method to convert an instance to a JSON object
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