import 'dart:convert';

class ProjectDetailModel {
  String projectId;
  String customerId;
  String prCurrencyTrackId;
  String clientId;
  String subClientId;
  String managerId;
  String prName;
  String prShortName;
  String prPoNumber;
  String prBudgetCategory;
  String prBudgetedHours;
  String prBudgetedAmount;
  String prContactNumber;
  String prComments;
  String prQuotation;
  String prStartDate;
  String prEndDate;
  String userId;
  DateTime prCreationDate;
  String status;
  String prArchive;
  String projectManagerName;
  String clientName;
  List<ActivityType> activityType;
  String subClientName;

  ProjectDetailModel({
    required this.projectId,
    required this.customerId,
    required this.prCurrencyTrackId,
    required this.clientId,
    required this.subClientId,
    required this.managerId,
    required this.prName,
    required this.prShortName,
    required this.prPoNumber,
    required this.prBudgetCategory,
    required this.prBudgetedHours,
    required this.prBudgetedAmount,
    required this.prContactNumber,
    required this.prComments,
    required this.prQuotation,
    required this.prStartDate,
    required this.prEndDate,
    required this.userId,
    required this.prCreationDate,
    required this.status,
    required this.prArchive,
    required this.projectManagerName,
    required this.clientName,
    required this.activityType,
    required this.subClientName,
  });

  // Factory method to create ProjectDetailModel from JSON
  factory ProjectDetailModel.fromJson(Map<String, dynamic> json) {
    var activityList = json['activity_type'] as List;
    List<ActivityType> activityTypeList = activityList.map((e) => ActivityType.fromJson(e)).toList();

    return ProjectDetailModel(
      projectId: json['project_id'],
      customerId: json['customer_id'],
      prCurrencyTrackId: json['pr_currency_track_id'],
      clientId: json['client_id'],
      subClientId: json['sub_clientid'],
      managerId: json['manager_id'],
      prName: json['pr_name'],
      prShortName: json['pr_short_name'],
      prPoNumber: json['pr_po_number'],
      prBudgetCategory: json['pr_budget_category'],
      prBudgetedHours: json['pr_budgeted_hours'],
      prBudgetedAmount: json['pr_budgeted_amount'],
      prContactNumber: json['pr_contact_number'],
      prComments: json['pr_comments'],
      prQuotation: json['pr_quotation'],
      prStartDate: json['pr_start_date'],
      prEndDate: json['pr_end_date'],
      userId: json['user_id'],
      prCreationDate: DateTime.parse(json['pr_creation_date']),
      status: json['status'],
      prArchive: json['pr_archive'],
      projectManagerName: json['projectmanager_name'],
      clientName: json['clientname'],
      activityType: activityTypeList,
      subClientName: json['subclient_name'],
    );
  }

  // Helper function to handle the JSON list for ProjectDetailModel
  static List<ProjectDetailModel> listFromJson(List<dynamic> json) {
    return json.map((e) => ProjectDetailModel.fromJson(e)).toList();
  }
}

class ActivityType {
  String activityId;
  String projectId;
  String activityHours;
  String activityAmount;
  String createdByUserId;
  String categoryName;

  ActivityType({
    required this.activityId,
    required this.projectId,
    required this.activityHours,
    required this.activityAmount,
    required this.createdByUserId,
    required this.categoryName,
  });

  // Factory method to create ActivityType from JSON
  factory ActivityType.fromJson(Map<String, dynamic> json) {
    return ActivityType(
      activityId: json['activity_id'],
      projectId: json['project_id'],
      activityHours: json['activity_hours'],
      activityAmount: json['activity_amount'],
      createdByUserId: json['createdby_userid'],
      categoryName: json['category_name'],
    );
  }
}
