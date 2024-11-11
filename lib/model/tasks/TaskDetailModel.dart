class TaskDetailModel {
  final String id;
  final String clientId;
  final String clientName;
  final String projectId;
  final String projectName;
  final String taskUniqueId;
  final String taskTitle;
  final String taskTypeId;
  final String categoryName;
  final String communicationReceivedFrom;
  final String contactName;
  final String userName;
  final String communicationSendTo;
  final String emailSubject;
  final String communicationDate;
  final String communicationHourMin;
  final String taskStartDate;
  final String taskEndDate;
  final String taskHours;
  final String taskPriority;
  final String taskAlertRequire;
  final String eventAttendees;
  final String taskComments;
  final String createdOn;
  final String createdBy;
  final String? closedBy; // Nullable field
  final String taskStatus;
  final List<UserInfo> userInfo;

  TaskDetailModel({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.projectId,
    required this.projectName,
    required this.taskUniqueId,
    required this.taskTitle,
    required this.taskTypeId,
    required this.categoryName,
    required this.communicationReceivedFrom,
    required this.contactName,
    required this.userName,
    required this.communicationSendTo,
    required this.emailSubject,
    required this.communicationDate,
    required this.communicationHourMin,
    required this.taskStartDate,
    required this.taskEndDate,
    required this.taskHours,
    required this.taskPriority,
    required this.taskAlertRequire,
    required this.eventAttendees,
    required this.taskComments,
    required this.createdOn,
    required this.createdBy,
    this.closedBy,
    required this.taskStatus,
    required this.userInfo,
  });

  factory TaskDetailModel.fromJson(Map<String, dynamic> json) {
    var userInfoFromJson = json['userinfo'] as List;
    List<UserInfo> userInfoList = userInfoFromJson.map((i) => UserInfo.fromJson(i)).toList();

    return TaskDetailModel(
      id: json['id'],
      clientId: json['client_id'],
      clientName: json['client_name'],
      projectId: json['project_id'],
      projectName: json['project_name'],
      taskUniqueId: json['task_uniqueid'],
      taskTitle: json['task_title'],
      taskTypeId: json['task_type_id'],
      categoryName: json['category_name'],
      communicationReceivedFrom: json['communication_received_from'],
      contactName: json['contactName'],
      userName: json['userName'],
      communicationSendTo: json['communication_send_to'],
      emailSubject: json['email_subject'],
      communicationDate: json['communication_date'],
      communicationHourMin: json['communication_hourmin'],
      taskStartDate: json['task_start_date'],
      taskEndDate: json['task_end_date'],
      taskHours: json['task_hours'],
      taskPriority: json['task_priority'],
      taskAlertRequire: json['task_alert_require'],
      eventAttendees: json['event_attendies'],
      taskComments: json['task_comments'],
      createdOn: json['createdOn'],
      createdBy: json['createdBy'],
      closedBy: json['closedBy'],
      taskStatus: json['task_status'],
      userInfo: userInfoList,
    );
  }
}

class UserInfo {
  final String usersId;
  final String firstName;
  final String lastName;

  UserInfo({
    required this.usersId,
    required this.firstName,
    required this.lastName,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      usersId: json['users_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }
}