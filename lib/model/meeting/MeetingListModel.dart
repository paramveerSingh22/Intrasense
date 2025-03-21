import 'dart:convert';

class MeetingListModel {
  final String meetingId;
  final String meetingTitle;
  final String meetingDate;
  final String meetingTime;
  final String meetingTimeZone;
  final String meetingRecurring;
  final String zoomMeeting;
  final String zoomLink;
  final String meetingPriority;
  final String userId;
  final String createdOn;
  final String meetingStatus;

  MeetingListModel({
    required this.meetingId,
    required this.meetingTitle,
    required this.meetingDate,
    required this.meetingTime,
    required this.meetingTimeZone,
    required this.meetingRecurring,
    required this.zoomMeeting,
    required this.zoomLink,
    required this.meetingPriority,
    required this.userId,
    required this.createdOn,
    required this.meetingStatus,
  });

  // From JSON map
  factory MeetingListModel.fromJson(Map<String, dynamic> json) {
    return MeetingListModel(
      meetingId: json['meeting_id'].toString(),
      meetingTitle: json['meeeing_title'],
      meetingDate: json['meeeing_date'],
      meetingTime: json['meeeing_time'],
      meetingTimeZone: json['meeeing_timeZone'],
      meetingRecurring: json['meeeing_recurring'],
      zoomMeeting: json['zoom_meeting'],
      zoomLink: json['zoom_link'],
      meetingPriority: json['meeeing_priority'],
      userId: json['user_id'],
      createdOn: json['createdOn'],
      meetingStatus: json['meeting_status'],
    );
  }

  // To JSON map
  Map<String, dynamic> toJson() {
    return {
      'meeting_id': meetingId,
      'meeeing_title': meetingTitle,
      'meeeing_date': meetingDate,
      'meeeing_time': meetingTime,
      'meeeing_timeZone': meetingTimeZone,
      'meeeing_recurring': meetingRecurring,
      'zoom_meeting': zoomMeeting,
      'zoom_link': zoomLink,
      'meeeing_priority': meetingPriority,
      'user_id': userId,
      'createdOn': createdOn,
      'meeting_status': meetingStatus,
    };
  }
}

// Function to parse JSON data to list of Meeting objects
List<MeetingListModel> parseMeetings(String jsonData) {
  final data = json.decode(jsonData) as List;
  return data.map((jsonMeeting) => MeetingListModel.fromJson(jsonMeeting)).toList();
}

// Function to convert list of Meeting objects to JSON
String meetingsToJson(List<MeetingListModel> meetings) {
  final jsonData = meetings.map((meeting) => meeting.toJson()).toList();
  return json.encode(jsonData);
}