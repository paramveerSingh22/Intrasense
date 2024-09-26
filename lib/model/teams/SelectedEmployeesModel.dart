class SelectedEmployeesModel{
  String groupId;
  String userId;
  String firstName;
  String lastName;
  String usrDesignation;
  String usrEmail;
  String usrMobile;
  String usrCountry;
  String groupName;
  String comments;

  SelectedEmployeesModel({
    required this.groupId,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.usrDesignation,
    required this.usrEmail,
    required this.usrMobile,
    required this.usrCountry,
    required this.groupName,
    required this.comments,
  });

  // Factory constructor to create GroupData from JSON
  factory SelectedEmployeesModel.fromJson(Map<String, dynamic> json) {
    return SelectedEmployeesModel(
      groupId: json['group_id'],
      userId: json['user_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      usrDesignation: json['usr_designation'],
      usrEmail: json['usr_email'],
      usrMobile: json['usr_mobile'],
      usrCountry: json['usr_country'],
      groupName: json['group_name'],
      comments: json['comments'] ?? '',  // Handle null or empty comments
    );
  }

  // Method to convert GroupData back to JSON
  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'usr_designation': usrDesignation,
      'usr_email': usrEmail,
      'usr_mobile': usrMobile,
      'usr_country': usrCountry,
      'group_name': groupName,
      'comments': comments,
    };
  }
}