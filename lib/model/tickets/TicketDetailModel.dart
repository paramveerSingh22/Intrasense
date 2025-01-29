class TicketDetailModel{
  String ticketId;
  String userId;
  String usrRoleTrackId;
  String? sentTo;
  String firstName;
  String lastName;
  String organisation;
  String designation;
  String employeeId;
  String emailId;
  String contactNo;
  String issueType;
  String ticketDescription;
  String createdOn;
  String status;
  List<Comment> comments;

  TicketDetailModel({
    required this.ticketId,
    required this.userId,
    required this.usrRoleTrackId,
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
    required this.comments,
  });

  // Factory method to create TicketModel from JSON
  factory TicketDetailModel.fromJson(Map<String, dynamic> json) {
    var list = json['comments'] as List;
    List<Comment> commentsList = list.map((i) => Comment.fromJson(i)).toList();

    return TicketDetailModel(
      ticketId: json['ticket_id'],
      userId: json['user_id'],
      usrRoleTrackId: json['usr_role_track_id'],
      sentTo: json['sent_to'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      organisation: json['organisation'],
      designation: json['designation'],
      employeeId: json['employee_id'],
      emailId: json['email_id'],
      contactNo: json['contact_no'],
      issueType: json['issue_type'],
      ticketDescription: json['ticket_description'],
      createdOn: json['createdOn'],
      status: json['status'],
      comments: commentsList,
    );
  }

  // Convert TicketModel to JSON
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
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
}

class Comment {
  String id;
  String ticketId;
  String senderId;
  String receiverId;
  String comments;
  String createdOn;
  String senderName;
  String senderProfilePicture;
  String? receiverName;
  String? receiverProfilePicture;

  Comment({
    required this.id,
    required this.ticketId,
    required this.senderId,
    required this.receiverId,
    required this.comments,
    required this.createdOn,
    required this.senderName,
    required this.senderProfilePicture,
    this.receiverName,
    this.receiverProfilePicture,
  });

  // Factory method to create Comment from JSON
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      ticketId: json['ticket_id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      comments: json['comments'],
      createdOn: json['createdOn'],
      senderName: json['sender_name'],
      senderProfilePicture: json['sender_profile_picture'],
      receiverName: json['receiver_name'],
      receiverProfilePicture: json['receiver_profile_picture'],
    );
  }

  // Convert Comment to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticket_id': ticketId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'comments': comments,
      'createdOn': createdOn,
      'sender_name': senderName,
      'sender_profile_picture': senderProfilePicture,
      'receiver_name': receiverName,
      'receiver_profile_picture': receiverProfilePicture,
    };
  }

}