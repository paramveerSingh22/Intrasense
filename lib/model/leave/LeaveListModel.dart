class LeaveListModel {
  final String leaveId;
  final String levType;
  final String leaveTypeName;
  final String levPurpose;
  final String levStartDate;
  final String levEndDate;
  final String levStartTime;
  final String levEndTime;
  final String userId;
  final String medicalCertificate;
  final String? levAppliedComment; // Nullable
  final String levStatus;
  final String? levApprovedBy; // Nullable
  final String? levApprovedOn; // Nullable
  final String levCreatedDate;
  final String userFirstName;
  final String userLastName;
  final String usrEmpID;

  LeaveListModel({
    required this.leaveId,
    required this.levType,
    required this.leaveTypeName,
    required this.levPurpose,
    required this.levStartDate,
    required this.levEndDate,
    required this.levStartTime,
    required this.levEndTime,
    required this.userId,
    required this.medicalCertificate,
    this.levAppliedComment, // Nullable
    required this.levStatus,
    this.levApprovedBy, // Nullable
    this.levApprovedOn, // Nullable
    required this.levCreatedDate,
    required this.userFirstName,
    required this.userLastName,
    required this.usrEmpID,
  });

  factory LeaveListModel.fromJson(Map<String, dynamic> json) {
    return LeaveListModel(
      leaveId: json['leave_id'] ?? '',
      levType: json['lev_type'] ?? '',
      leaveTypeName: json['leave_type_name'] ?? '',
      levPurpose: json['lev_purpose'] ?? '',
      levStartDate: json['lev_start_date'] ?? '',
      levEndDate: json['lev_end_date'] ?? '',
      levStartTime: json['lev_start_time'] ?? '',
      levEndTime: json['lev_end_time'] ?? '',
      userId: json['user_id'] ?? '',
      medicalCertificate: json['medicalCertificate'] ?? '',
      levAppliedComment: json['lev_applied_comment'], // Allow null
      levStatus: json['lev_status'] ?? '',
      levApprovedBy: json['lev_approved_by'], // Allow null
      levApprovedOn: json['lev_approved_on'], // Allow null
      levCreatedDate: json['lev_created_date'] ?? '',
      userFirstName: json['user_first_name'] ?? '',
      userLastName: json['user_last_name'] ?? '',
      usrEmpID: json['usr_empID'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leave_id': leaveId,
      'lev_type': levType,
      'leave_type_name': leaveTypeName,
      'lev_purpose': levPurpose,
      'lev_start_date': levStartDate,
      'lev_end_date': levEndDate,
      'lev_start_time': levStartTime,
      'lev_end_time': levEndTime,
      'user_id': userId,
      'medicalCertificate': medicalCertificate,
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