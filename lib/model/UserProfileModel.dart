class UserProfileModel {
  String? userId;
  String? usrRoleTrackId;
  String? usrManagerId;
  String? usrEmpID;
  String? firstName;
  String? lastName;
  String? userEmail;
  String? userMobile;
  String? userDob;
  String? usrAddress;
  String? usrAddress2;
  String? usrCountry;
  String? usrState;
  String? usrCity;
  String? usrZipcode;
  String? joining;
  String? aniversary;
  String? usrDesignation;
  String? userDepartment;
  String? usrSkypeId;
  String? usrPhoto;
  String? usrArchiveStatus;
  String? usrIdproof;
  String? organisation;
  String? managerFirstName;
  String? managerLastName;



  UserProfileModel({
    this.userId,
    this.usrRoleTrackId,
    this.usrManagerId,
    this.usrEmpID,
    this.firstName,
    this.lastName,
    this.userEmail,
    this.userMobile,
    this.userDob,
    this.usrAddress,
    this.usrAddress2,
    this.usrCountry,
    this.usrState,
    this.usrCity,
    this.usrZipcode,
    this.joining,
    this.aniversary,
    this.usrDesignation,
    this.userDepartment,
    this.usrSkypeId,
    this.usrPhoto,
    this.usrArchiveStatus,
    this.usrIdproof,
    this.organisation,
    this.managerFirstName,
    this.managerLastName,

  });

  UserProfileModel.empty()
      : userId = '',
        usrRoleTrackId = '',
        usrManagerId = '',
        usrEmpID = '',
        firstName = '',
        lastName = '',
        userEmail = '',
        userMobile = '',
        userDob = '',
        usrAddress = '',
        usrAddress2 = '',
        usrCountry = '',
        usrState = '',
        usrCity = '',
        usrZipcode = '',
        joining = '',
        aniversary = '',
        usrDesignation = '',
        userDepartment = '',
        usrSkypeId = '',
        usrPhoto = '',
        usrArchiveStatus = '',
        usrIdproof = '',
        organisation = '',
        managerFirstName = '',
        managerLastName = ''
        ;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      userId: json['user_id']as String?,
      usrRoleTrackId: json['usr_role_track_id']as String?,
      usrManagerId: json['usr_manager_id']as String?,
      usrEmpID: json['usr_empID']as String?,
      firstName: json['first_name']as String?,
      lastName: json['last_name']as String?,
      userEmail: json['usr_email']as String?,
      userMobile: json['usr_mobile']as String?,
      userDob: json['usr_dob']as String?,
      usrAddress: json['usr_address']as String?,
      usrAddress2: json['usr_address2']as String?,
      usrCountry: json['usr_country']as String?,
      usrState: json['usr_state']as String?,
      usrCity: json['usr_city']as String?,
      usrZipcode: json['usr_zipcode']as String?,
      joining: json['joining']as String?,
      aniversary: json['aniversary']as String?,
      usrDesignation: json['usr_designation']as String?,
      userDepartment: json['user_department']as String?,
      usrSkypeId: json['usr_skype_id']as String?,
      usrPhoto: json['usr_photo']as String?,
      usrArchiveStatus: json['usr_archive_status']as String?,
      usrIdproof: json['usr_idproof']as String?,
      organisation: json['organisation']as String?,
      managerFirstName: json['manager_first_name']as String?,
      managerLastName: json['manager_last_name']as String?,


    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'usr_role_track_id': usrRoleTrackId,
      'usr_manager_id': usrManagerId,
      'usr_empID': usrEmpID,
      'first_name': firstName,
      'last_name': lastName,
      'usr_email': userEmail,
      'usr_mobile': userMobile,
      'usr_dob': userDob,
      'usr_address': usrAddress,
      'usr_address2': usrAddress2,
      'usr_country': usrCountry,
      'usr_state': usrState,
      'usr_city': usrCity,
      'usr_zipcode': usrZipcode,
      'joining': joining,
      'aniversary': aniversary,
      'usr_designation': usrDesignation,
      'user_department': userDepartment,
      'usr_skype_id': usrSkypeId,
      'usr_photo': usrPhoto,
      'usr_archive_status': usrArchiveStatus,
      'usr_idproof': usrIdproof,
      'organisation': organisation,
      'manager_first_name': managerFirstName,
      'manager_last_name': managerLastName,
    };
  }
}