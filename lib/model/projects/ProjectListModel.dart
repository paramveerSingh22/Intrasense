class ProjectListModel{
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
  String prCreationDate;
  String? closedByUserId;
  String? prClosedDate;
  String? updatedByUserId;
  String? prLastModified;
  String status;
  String prArchive;
  String projectManagerName;
  String clientName;

  ProjectListModel({
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
    this.closedByUserId,
    this.prClosedDate,
    this.updatedByUserId,
    this.prLastModified,
    required this.status,
    required this.prArchive,
    required this.projectManagerName,
    required this.clientName,
  });

  factory ProjectListModel.fromJson(Map<String, dynamic> json) {
    return ProjectListModel(
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
      prCreationDate: json['pr_creation_date'],
      closedByUserId: json['closedby_userid'],
      prClosedDate: json['pr_closed_date'],
      updatedByUserId: json['updatedby_userid'],
      prLastModified: json['pr_last_modified'],
      status: json['status'],
      prArchive: json['pr_archive'],
      projectManagerName: json['projectmanager_name'],
      clientName: json['clientname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'project_id': projectId,
      'customer_id': customerId,
      'pr_currency_track_id': prCurrencyTrackId,
      'client_id': clientId,
      'sub_clientid': subClientId,
      'manager_id': managerId,
      'pr_name': prName,
      'pr_short_name': prShortName,
      'pr_po_number': prPoNumber,
      'pr_budget_category': prBudgetCategory,
      'pr_budgeted_hours': prBudgetedHours,
      'pr_budgeted_amount': prBudgetedAmount,
      'pr_contact_number': prContactNumber,
      'pr_comments': prComments,
      'pr_quotation': prQuotation,
      'pr_start_date': prStartDate,
      'pr_end_date': prEndDate,
      'user_id': userId,
      'pr_creation_date': prCreationDate,
      'closedby_userid': closedByUserId,
      'pr_closed_date': prClosedDate,
      'updatedby_userid': updatedByUserId,
      'pr_last_modified': prLastModified,
      'status': status,
      'pr_archive': prArchive,
      'projectmanager_name': projectManagerName,
      'clientname': clientName,
    };
  }
}