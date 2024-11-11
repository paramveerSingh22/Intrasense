class LeaveListModel {
  final String leaveId;
  final String levType;
  final String levPurpose;
  final String levStartDate;
  final String levEndDate;
  final String levStartTime;
  final String levEndTime;
  final String userId;
  final String? levAppliedComment;
  final String levStatus;
  final String? levApprovedBy;
  final String? levApprovedOn;
  final String levCreatedDate;
  final String userFirstName;
  final String userLastName;

  LeaveListModel({
    required this.leaveId,
    required this.levType,
    required this.levPurpose,
    required this.levStartDate,
    required this.levEndDate,
    required this.levStartTime,
    required this.levEndTime,
    required this.userId,
    this.levAppliedComment,
    required this.levStatus,
    this.levApprovedBy,
    this.levApprovedOn,
    required this.levCreatedDate,
    required this.userFirstName,
    required this.userLastName,
  });

  // JSON to Model conversion
  factory LeaveListModel.fromJson(Map<String, dynamic> json) {
    return LeaveListModel(
      leaveId: json['leave_id'],
      levType: json['lev_type'],
      levPurpose: json['lev_purpose'],
      levStartDate: json['lev_start_date'],
      levEndDate: json['lev_end_date'],
      levStartTime: json['lev_start_time'],
      levEndTime: json['lev_end_time'],
      userId: json['user_id'],
      levAppliedComment: json['lev_applied_comment'],
      levStatus: json['lev_status'],
      levApprovedBy: json['lev_approved_by'],
      levApprovedOn: json['lev_approved_on'],
      levCreatedDate: json['lev_created_date'],
      userFirstName: json['user_first_name'],
      userLastName: json['user_last_name'],
    );
  }

  // Model to JSON conversion (optional)
  Map<String, dynamic> toJson() {
    return {
      'leave_id': leaveId,
      'lev_type': levType,
      'lev_purpose': levPurpose,
      'lev_start_date': levStartDate,
      'lev_end_date': levEndDate,
      'lev_start_time': levStartTime,
      'lev_end_time': levEndTime,
      'user_id': userId,
      'lev_applied_comment': levAppliedComment,
      'lev_status': levStatus,
      'lev_approved_by': levApprovedBy,
      'lev_approved_on': levApprovedOn,
      'lev_created_date': levCreatedDate,
      'user_first_name': userFirstName,
      'user_last_name': userLastName,
    };
  }
}