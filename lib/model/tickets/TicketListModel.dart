class TicketListModel {
  final String ticketId;
  final String userId;
  final String? usrRoleTrackId; // Nullable
  final String? sentTo; // Nullable
  final String firstName;
  final String lastName;
  final String organisation;
  final String designation;
  final String employeeId;
  final String emailId;
  final String contactNo;
  final String issueType;
  final String ticketDescription;
  final String createdOn;
  final String status;

  TicketListModel({
    required this.ticketId,
    required this.userId,
    this.usrRoleTrackId,
    this.sentTo,
    required this.firstName,
    required this.lastName,
    required this.organisation,
    required this.designation,
    required this.employeeId,
    required this.emailId,
    required this.contactNo,
    required this.issueType,
    required this.ticketDescription,
    required this.createdOn,
    required this.status,
  });

  // From JSON
  factory TicketListModel.fromJson(Map<String, dynamic> json) {
    return TicketListModel(
      ticketId: json['ticket_id'] ?? '',
      userId: json['user_id'] ?? '',
      usrRoleTrackId: json['usr_role_track_id'] != 'null' ? json['usr_role_track_id'] : null,
      sentTo: json['sent_to'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      organisation: json['organisation'] ?? '',
      designation: json['designation'] ?? '',
      employeeId: json['employee_id'] ?? '',
      emailId: json['email_id'] ?? '',
      contactNo: json['contact_no'] ?? '',
      issueType: json['issue_type'] ?? '',
      ticketDescription: json['ticket_description'] ?? '',
      createdOn: json['createdOn'] ?? '',
      status: json['status'] ?? '',
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'ticket_id': ticketId,
      'user_id': userId,
      'usr_role_track_id': usrRoleTrackId,
      'sent_to': sentTo,
      'first_name': firstName,
      'last_name': lastName,
      'organisation': organisation,
      'designation': designation,
      'employee_id': employeeId,
      'email_id': emailId,
      'contact_no': contactNo,
      'issue_type': issueType,
      'ticket_description': ticketDescription,
      'createdOn': createdOn,
      'status': status,
    };
  }
}