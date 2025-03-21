import 'dart:convert';

class MeetingDetailModel {
  final String? meetingId;  // Store as String since it's coming as a String from API
  final String? meetingTitle;
  final String? meetingDate;
  final String? meetingTime;
  final String? meetingTimeZone;
  final String? meetingRecurring;  // Keep as String for API consistency
  final String? zoomMeeting;  // Keep as String
  final String? zoomLink;
  final String? meetingPriority;  // Keep as String
  final String? createdBy;
  final String? createdOn;
  final String? meetingStatus;  // Keep as String
  final String? firstName;
  final String? lastName;
  final String? userEmail;
  final List<UserDetails> userDetails;
  final List<ClientDetails> clientDetails;
  final List<GroupDetails> groupDetails;

  MeetingDetailModel({
     this.meetingId,
     this.meetingTitle,
     this.meetingDate,
     this.meetingTime,
     this.meetingTimeZone,
     this.meetingRecurring,
     this.zoomMeeting,
     this.zoomLink,
     this.meetingPriority,
     this.createdBy,
     this.createdOn,
     this.meetingStatus,
     this.firstName,
     this.lastName,
     this.userEmail,
    required this.userDetails,
    required this.clientDetails,
    required this.groupDetails,
  });

  factory MeetingDetailModel.fromJson(Map<String, dynamic> json) {
    return MeetingDetailModel(
      meetingId: json['meeting_id'] as String?,  // Parse as String
      meetingTitle: json['meeeing_title'] as String?,
      meetingDate: json['meeeing_date'] as String?,
      meetingTime: json['meeeing_time'] as String?,
      meetingTimeZone: json['meeeing_timeZone'] as String?,
      meetingRecurring: json['meeeing_recurring'] as String?,  // Parse as String
      zoomMeeting: json['zoom_meeting'] as String?,  // Parse as String
      zoomLink: json['zoom_link'] as String?,
      meetingPriority: json['meeeing_priority'] as String?,  // Parse as String
      createdBy: json['createdBy'] as String?,  // Parse as String
      createdOn: json['createdOn'] as String?,
      meetingStatus: json['meeting_status'] as String?,  // Parse as String
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      userEmail: json['user_email'] as String?,
      userDetails: (json['userDetails'] as List)
          .map((user) => UserDetails.fromJson(user))
          .toList(),
      clientDetails: (json['clientDetails'] as List)
          .map((client) => ClientDetails.fromJson(client))
          .toList(),
      groupDetails: (json['groupDetails'] as List)
          .map((group) => GroupDetails.fromJson(group))
          .toList(),
    );
  }
}

class UserDetails {
  final String? userId;
  final String? meetingStatus;
  final String? cancelReason;
  final String? rescheduleDate;
  final String? rescheduleTime;
  final String? rescheduleTimeZone;
  final String? firstName;
  final String? lastName;
  final String? userEmailId;

  UserDetails({
     this.userId,
    this.meetingStatus,
    this.cancelReason,
    this.rescheduleDate,
    this.rescheduleTime,
    this.rescheduleTimeZone,
     this.firstName,
     this.lastName,
     this.userEmailId,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      userId: json['user_id'] as String?,
      meetingStatus: json['meeting_status'] as String?,
      cancelReason: json['cancel_reason'] as String?,
      rescheduleDate: json['reschedule_date'] as String?,
      rescheduleTime: json['reschedule_time'] as String?,
      rescheduleTimeZone: json['reschedule_timeZone'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      userEmailId: json['user_emailid'] as String?,
    );
  }
}

class ClientDetails {
  final String? clientId;
  final String? meetingStatus;
  final String? companyName;
  final String? companyEmailId;


  ClientDetails({
    this.clientId,
    this.meetingStatus,
    this.companyName,
    this.companyEmailId,
  });

  factory ClientDetails.fromJson(Map<String, dynamic> json) {
    return ClientDetails(
      clientId: json['client_id'] as String?,
      meetingStatus: json['meeting_status'] as String?,
      companyName: json['company_name'] as String?,
      companyEmailId: json['company_emailid'] as String?,
    );
  }
}

class GroupDetails {
  final String? groupId;
  final String? groupName;


  GroupDetails({
    this.groupId,
    this.groupName,
  });

  factory GroupDetails.fromJson(Map<String, dynamic> json) {
    return GroupDetails(
      groupId: json['group_id'] as String?,
      groupName: json['group_name'] as String?,

    );
  }
}