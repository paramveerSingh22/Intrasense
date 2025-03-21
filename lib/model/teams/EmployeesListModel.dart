class EmployeesListModel {
  String? empId;
  String? usrCustomerTrackId;
  String? usrTeamTrackId;
  String? usrRoleTrackId;
  String? usrManagerId;
  String? usrType;
  String? usrEmpID;
  String? userFirstName;
  String? userLastName;
  String? usrEmail;
  String? usrMobile;
  String? usrDob;
  String? usrAddress;
  String? usrAddress2;
  String? usrCountry;
  String? usrState;
  String? usrCity;
  String? usrZipcode;
  String? usrDoj;
  String? usrDoa;  // Nullable as it can be null
  String? usrDesignation;
  String? userDepartment;
  String? usrSkypeId;
  String? profilePicture;
  String? idProof;
  String? status;

  EmployeesListModel({
     this.empId,
     this.usrCustomerTrackId,
     this.usrTeamTrackId,
     this.usrRoleTrackId,
     this.usrManagerId,
     this.usrType,
     this.usrEmpID,
     this.userFirstName,
     this.userLastName,
     this.usrEmail,
     this.usrMobile,
     this.usrDob,
     this.usrAddress,
     this.usrAddress2,
     this.usrCountry,
     this.usrState,
     this.usrCity,
     this.usrZipcode,
     this.usrDoj,
     this.usrDoa,
     this.usrDesignation,
     this.userDepartment,
     this.usrSkypeId,
     this.profilePicture,
     this.idProof,
     this.status,
  });

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
        usrDoa = '',
        usrDesignation = '',
        userDepartment = '',
        usrSkypeId = '',
        profilePicture = '',
        idProof = '',
        status = '';

  factory EmployeesListModel.fromJson(Map<String, dynamic> json) {
    return EmployeesListModel(
      empId: json['emp_id']as String?,
      usrCustomerTrackId: json['usr_customer_track_id']as String?,
      usrTeamTrackId: json['usr_team_track_id']as String?,
      usrRoleTrackId: json['usr_role_track_id']as String?,
      usrManagerId: json['usr_manager_id']as String?,
      usrType: json['usr_type']as String?,
      usrEmpID: json['usr_empID']as String?,
      userFirstName: json['user_first_name']as String?,
      userLastName: json['user_last_name']as String?,
      usrEmail: json['usr_email']as String?,
      usrMobile: json['usr_mobile']as String?,
      usrDob: json['usr_dob']as String?,
      usrAddress: json['usr_address']as String?,
      usrAddress2: json['usr_address2']as String?,
      usrCountry: json['usr_country']as String?,
      usrState: json['usr_state']as String?,
      usrCity: json['usr_city']as String?,
      usrZipcode: json['usr_zipcode']as String?,
      usrDoj: json['usr_doj']as String?,
      usrDoa: json['usr_doa']as String?, // Nullable
      usrDesignation: json['usr_designation']as String?,
      userDepartment: json['user_department']as String?,
      usrSkypeId: json['usr_skype_id']as String?,
      profilePicture: json['profile_picture']as String?,
      idProof: json['id_proof']as String?,
      status: json['status']as String?,
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