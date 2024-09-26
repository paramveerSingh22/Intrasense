class EmployeesListModel {
  String empId;
  String usrCustomerTrackId;
  String usrTeamTrackId;
  String usrRoleTrackId;
  String usrManagerId;
  String usrType;
  String usrEmpID;
  String userFirstName;
  String userLastName;
  String usrEmail;
  String usrMobile;
  String usrDob;
  String usrAddress;
  String usrAddress2;
  String usrCountry;
  String usrState;
  String usrCity;
  String usrZipcode;
  String usrDoj;
  String? usrDoa;  // Nullable as it can be null
  String usrDesignation;
  String userDepartment;
  String usrSkypeId;
  String profilePicture;
  String idProof;
  String status;

  EmployeesListModel({
    required this.empId,
    required this.usrCustomerTrackId,
    required this.usrTeamTrackId,
    required this.usrRoleTrackId,
    required this.usrManagerId,
    required this.usrType,
    required this.usrEmpID,
    required this.userFirstName,
    required this.userLastName,
    required this.usrEmail,
    required this.usrMobile,
    required this.usrDob,
    required this.usrAddress,
    required this.usrAddress2,
    required this.usrCountry,
    required this.usrState,
    required this.usrCity,
    required this.usrZipcode,
    required this.usrDoj,
    this.usrDoa,
    required this.usrDesignation,
    required this.userDepartment,
    required this.usrSkypeId,
    required this.profilePicture,
    required this.idProof,
    required this.status,
  });

  // Empty constructor
  EmployeesListModel.empty()
      : empId = '',
        usrCustomerTrackId = '',
        usrTeamTrackId = '',
        usrRoleTrackId = '',
        usrManagerId = '',
        usrType = '',
        usrEmpID = '',
        userFirstName = '',
        userLastName = '',
        usrEmail = '',
        usrMobile = '',
        usrDob = '',
        usrAddress = '',
        usrAddress2 = '',
        usrCountry = '',
        usrState = '',
        usrCity = '',
        usrZipcode = '',
        usrDoj = '',
        usrDoa = null,
        usrDesignation = '',
        userDepartment = '',
        usrSkypeId = '',
        profilePicture = '',
        idProof = '',
        status = '';

  factory EmployeesListModel.fromJson(Map<String, dynamic> json) {
    return EmployeesListModel(
      empId: json['emp_id'],
      usrCustomerTrackId: json['usr_customer_track_id'],
      usrTeamTrackId: json['usr_team_track_id'],
      usrRoleTrackId: json['usr_role_track_id'],
      usrManagerId: json['usr_manager_id'],
      usrType: json['usr_type'],
      usrEmpID: json['usr_empID'],
      userFirstName: json['user_first_name'],
      userLastName: json['user_last_name'],
      usrEmail: json['usr_email'],
      usrMobile: json['usr_mobile'],
      usrDob: json['usr_dob'],
      usrAddress: json['usr_address'],
      usrAddress2: json['usr_address2'],
      usrCountry: json['usr_country'],
      usrState: json['usr_state'],
      usrCity: json['usr_city'],
      usrZipcode: json['usr_zipcode'],
      usrDoj: json['usr_doj'],
      usrDoa: json['usr_doa'], // Nullable
      usrDesignation: json['usr_designation'],
      userDepartment: json['user_department'],
      usrSkypeId: json['usr_skype_id'],
      profilePicture: json['profile_picture'],
      idProof: json['id_proof'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emp_id': empId,
      'usr_customer_track_id': usrCustomerTrackId,
      'usr_team_track_id': usrTeamTrackId,
      'usr_role_track_id': usrRoleTrackId,
      'usr_manager_id': usrManagerId,
      'usr_type': usrType,
      'usr_empID': usrEmpID,
      'user_first_name': userFirstName,
      'user_last_name': userLastName,
      'usr_email': usrEmail,
      'usr_mobile': usrMobile,
      'usr_dob': usrDob,
      'usr_address': usrAddress,
      'usr_address2': usrAddress2,
      'usr_country': usrCountry,
      'usr_state': usrState,
      'usr_city': usrCity,
      'usr_zipcode': usrZipcode,
      'usr_doj': usrDoj,
      'usr_doa': usrDoa, // Nullable
      'usr_designation': usrDesignation,
      'user_department': userDepartment,
      'usr_skype_id': usrSkypeId,
      'profile_picture': profilePicture,
      'id_proof': idProof,
      'status': status,
    };
  }
}