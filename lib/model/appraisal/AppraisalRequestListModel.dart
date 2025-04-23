class AppraisalRequestListModel {
  final String? requestId;
  final String? userId;
  final String? customerId;
  final String? employeeId;
  final String? firstName;
  final String? lastName;
  final String? department;
  final String? projectManagerId;
  final String? reason;
  final String? attendenceRating;
  final String? workEthicsRating;
  final String? qualityOfWorkRating;
  final String? leadershipQualitiesRating;
  final String? communicationRating;
  final String? problemSolvingRating;
  final String? knowledgeRating;
  final String? attendenceComment;
  final String? workEthicsComment;
  final String? qualityOfWorkComment;
  final String? leadershipComment;
  final String? communicationComment;
  final String? problemSolvingComment;
  final String? knowledgeComment;
  final String? status;
  final String? createdOn;
  final String? pmFirstName;
  final String? pmLastName;

  AppraisalRequestListModel({
    this.requestId,
    this.userId,
    this.customerId,
    this.employeeId,
    this.firstName,
    this.lastName,
    this.department,
    this.projectManagerId,
    this.reason,
    this.attendenceRating,
    this.workEthicsRating,
    this.qualityOfWorkRating,
    this.leadershipQualitiesRating,
    this.communicationRating,
    this.problemSolvingRating,
    this.knowledgeRating,
    this.attendenceComment,
    this.workEthicsComment,
    this.qualityOfWorkComment,
    this.leadershipComment,
    this.communicationComment,
    this.problemSolvingComment,
    this.knowledgeComment,
    this.status,
    this.createdOn,
    this.pmFirstName,
    this.pmLastName,
  });

  factory AppraisalRequestListModel.fromJson(Map<String, dynamic> json) {
    return AppraisalRequestListModel(
      requestId: json['request_id']?.toString(),
      userId: json['user_id']?.toString(),
      customerId: json['customer_id']?.toString(),
      employeeId: json['employee_id']?.toString(),
      firstName: json['first_name'],
      lastName: json['last_name'],
      department: json['department'],
      projectManagerId: json['project_managerid']?.toString(),
      reason: json['reason'],
      attendenceRating: json['attendence_rating']?.toString(),
      workEthicsRating: json['workethics_rating']?.toString(),
      qualityOfWorkRating: json['qualityofwork_rating']?.toString(),
      leadershipQualitiesRating: json['leadershipqualities_rating']?.toString(),
      communicationRating: json['communication_rating']?.toString(),
      problemSolvingRating: json['problemsolving_rating']?.toString(),
      knowledgeRating: json['knowledge_rating']?.toString(),
      attendenceComment: json['attendence_comment'],
      workEthicsComment: json['workethics_comment'],
      qualityOfWorkComment: json['qualityofwork_comment'],
      leadershipComment: json['leadership_comment'],
      communicationComment: json['communication_comment'],
      problemSolvingComment: json['problemsolving_comment'],
      knowledgeComment: json['knowledge_comment'],
      status: json['status']?.toString(),
      createdOn: json['created_on'],
      pmFirstName: json['pm_firstname'],
      pmLastName: json['pm_lastname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'request_id': requestId,
      'user_id': userId,
      'customer_id': customerId,
      'employee_id': employeeId,
      'first_name': firstName,
      'last_name': lastName,
      'department': department,
      'project_managerid': projectManagerId,
      'reason': reason,
      'attendence_rating': attendenceRating,
      'workethics_rating': workEthicsRating,
      'qualityofwork_rating': qualityOfWorkRating,
      'leadershipqualities_rating': leadershipQualitiesRating,
      'communication_rating': communicationRating,
      'problemsolving_rating': problemSolvingRating,
      'knowledge_rating': knowledgeRating,
      'attendence_comment': attendenceComment,
      'workethics_comment': workEthicsComment,
      'qualityofwork_comment': qualityOfWorkComment,
      'leadership_comment': leadershipComment,
      'communication_comment': communicationComment,
      'problemsolving_comment': problemSolvingComment,
      'knowledge_comment': knowledgeComment,
      'status': status,
      'created_on': createdOn,
      'pm_firstname': pmFirstName,
      'pm_lastname': pmLastName,
    };
  }
}