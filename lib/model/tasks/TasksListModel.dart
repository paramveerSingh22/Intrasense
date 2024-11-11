class TaskDetail {
  String? id;
  String? clientId;
  String? projectId;
  String? taskUniqueId;
  String? taskTitle;
  String? taskTypeId;
  String? communicationReceivedFrom;
  String? communicationSendTo;
  String? emailSubject;
  String? communicationDate;
  String? communicationHourMin;
  String? taskStartDate;
  String? taskEndDate;
  String? taskHours;
  String? taskPriority;
  String? taskAlertRequire;
  String? taskComments;
  String? createdOn;
  String? createdBy;
  String? closedBy;
  String? taskStatus;
  String? createdByFirstName;
  String? createdByLastName;
  String? closedByFirstName;
  String? closedByLastName;
  String? taskSentFromFirstName;
  String? taskSentFromLastName;
  String? taskSentToFirstName;
  String? taskSentToLastName;
  String? projectName;
  String? projectShortName;
  String? companyName;

  TaskDetail({
    this.id,
    this.clientId,
    this.projectId,
    this.taskUniqueId,
    this.taskTitle,
    this.taskTypeId,
    this.communicationReceivedFrom,
    this.communicationSendTo,
    this.emailSubject,
    this.communicationDate,
    this.communicationHourMin,
    this.taskStartDate,
    this.taskEndDate,
    this.taskHours,
    this.taskPriority,
    this.taskAlertRequire,
    this.taskComments,
    this.createdOn,
    this.createdBy,
    this.closedBy,
    this.taskStatus,
    this.createdByFirstName,
    this.createdByLastName,
    this.closedByFirstName,
    this.closedByLastName,
    this.taskSentFromFirstName,
    this.taskSentFromLastName,
    this.taskSentToFirstName,
    this.taskSentToLastName,
    this.projectName,
    this.projectShortName,
    this.companyName,
  });

  factory TaskDetail.fromJson(Map<String, dynamic> json) {
    return TaskDetail(
      id: json['id'],
      clientId: json['client_id'],
      projectId: json['project_id'],
      taskUniqueId: json['task_uniqueid'],
      taskTitle: json['task_title'],
      taskTypeId: json['task_type_id'],
      communicationReceivedFrom: json['communication_received_from'],
      communicationSendTo: json['communication_send_to'],
      emailSubject: json['email_subject'],
      communicationDate: json['communication_date'],
      communicationHourMin: json['communication_hourmin'],
      taskStartDate: json['task_start_date'],
      taskEndDate: json['task_end_date'],
      taskHours: json['task_hours'],
      taskPriority: json['task_priority'],
      taskAlertRequire: json['task_alert_require'],
      taskComments: json['task_comments'],
      createdOn: json['createdOn'],
      createdBy: json['createdBy'],
      closedBy: json['closedBy'],
      taskStatus: json['task_status'],
      createdByFirstName: json['createdby_first_name'],
      createdByLastName: json['createdby_last_name'],
      closedByFirstName: json['closedby_first_name'],
      closedByLastName: json['closedby_last_name'],
      taskSentFromFirstName: json['tasksentfrom_first_name'],
      taskSentFromLastName: json['tasksentfrom_last_name'],
      taskSentToFirstName: json['tasksentto_first_name'],
      taskSentToLastName: json['tasksento_last_name'],
      projectName: json['project_name'],
      projectShortName: json['project_shortname'],
      companyName: json['company_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'project_id': projectId,
      'task_uniqueid': taskUniqueId,
      'task_title': taskTitle,
      'task_type_id': taskTypeId,
      'communication_received_from': communicationReceivedFrom,
      'communication_send_to': communicationSendTo,
      'email_subject': emailSubject,
      'communication_date': communicationDate,
      'communication_hourmin': communicationHourMin,
      'task_start_date': taskStartDate,
      'task_end_date': taskEndDate,
      'task_hours': taskHours,
      'task_priority': taskPriority,
      'task_alert_require': taskAlertRequire,
      'task_comments': taskComments,
      'createdOn': createdOn,
      'createdBy': createdBy,
      'closedBy': closedBy,
      'task_status': taskStatus,
      'createdby_first_name': createdByFirstName,
      'createdby_last_name': createdByLastName,
      'closedby_first_name': closedByFirstName,
      'closedby_last_name': closedByLastName,
      'tasksentfrom_first_name': taskSentFromFirstName,
      'tasksentfrom_last_name': taskSentFromLastName,
      'tasksentto_first_name': taskSentToFirstName,
      'tasksento_last_name': taskSentToLastName,
      'project_name': projectName,
      'project_shortname': projectShortName,
      'company_name': companyName,
    };
  }
}

// Model for data
class TaskListModel {
  String? taskId;
  List<TaskDetail>? taskDetail;
  TaskListModel({this.taskId, this.taskDetail});

  factory TaskListModel.fromJson(Map<String, dynamic> json) {
    return TaskListModel(
      taskId: json['task_id'],
      taskDetail: (json['taskDetail'] as List)
          ?.map((item) => TaskDetail.fromJson(item))
          ?.toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task_id': taskId,
      'taskDetail': taskDetail?.map((item) => item.toJson())?.toList(),
    };
  }
}