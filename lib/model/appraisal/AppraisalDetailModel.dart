class AppraisalDetailModel {
  final String? requestId;
  final String? userId;
  final String? customerId;
  final String? employeeId;
  final String? firstName;
  final String? lastName;
  final String? department;
  final String? projectManagerId;
  final String? reason;
  final String? attendanceRating;
  final String? workEthicsRating;
  final String? qualityOfWorkRating;
  final String? leadershipQualitiesRating;
  final String? communicationRating;
  final String? problemSolvingRating;
  final String? knowledgeRating;
  final String? attendanceComment;
  final String? workEthicsComment;
  final String? qualityOfWorkComment;
  final String? leadershipComment;
  final String? communicationComment;
  final String? problemSolvingComment;
  final String? knowledgeComment;
  final String? status;
  final DateTime? createdOn;
  final String? selfRating;
  final List<ManagerRating>? managerRating;

  AppraisalDetailModel({
    this.requestId,
    this.userId,
    this.customerId,
    this.employeeId,
    this.firstName,
    this.lastName,
    this.department,
    this.projectManagerId,
    this.reason,
    this.attendanceRating,
    this.workEthicsRating,
    this.qualityOfWorkRating,
    this.leadershipQualitiesRating,
    this.communicationRating,
    this.problemSolvingRating,
    this.knowledgeRating,
    this.attendanceComment,
    this.workEthicsComment,
    this.qualityOfWorkComment,
    this.leadershipComment,
    this.communicationComment,
    this.problemSolvingComment,
    this.knowledgeComment,
    this.status,
    this.createdOn,
    this.selfRating,
    this.managerRating,
  });

  factory AppraisalDetailModel.fromJson(Map<String, dynamic> json) {
    double? _parseDouble(String? value) {
      if (value == null || value.isEmpty) return null;
      return double.tryParse(value);
    }

    return AppraisalDetailModel(
      requestId: json['request_id'] ??"",
      userId: json['user_id']??"",
      customerId: json['customer_id']??"",
      employeeId: json['employee_id']??"",
      firstName: json['first_name']??"",
      lastName: json['last_name']??"",
      department: json['department']??"",
      projectManagerId: json['project_managerid']??"",
      reason: json['reason']??"",
      attendanceRating: json['attendence_rating']??"0",
      workEthicsRating: json['workethics_rating']??"0",
      qualityOfWorkRating: json['qualityofwork_rating']??"0",
      leadershipQualitiesRating: json['leadershipqualities_rating']??"0",
      communicationRating: json['communication_rating']??"0",
      problemSolvingRating: json['problemsolving_rating']??"0",
      knowledgeRating: json['knowledge_rating']??"0",
      attendanceComment: json['attendence_comment']??"",
      workEthicsComment: json['workethics_comment']??"",
      qualityOfWorkComment: json['qualityofwork_comment']??"",
      leadershipComment: json['leadership_comment']??"",
      communicationComment: json['communication_comment']??"",
      problemSolvingComment: json['problemsolving_comment']??"",
      knowledgeComment: json['knowledge_comment']??"",
      status: json['status']??"",
      createdOn: json['created_on'] != null
          ? DateTime.tryParse(json['created_on'])
          : null,
      selfRating: json['selfrating']??"0",
      managerRating: json['managerRating'] != null
          ? (json['managerRating'] as List)
          .map((e) => ManagerRating.fromJson(e))
          .toList()
          : [],
    );
  }
}

class ManagerRating {
  String? appraisalId;
  String? requestId;
  String? userId;
  String? attendenceRating;
  String? workethicsRating;
  String? qualityOfWorkRating;
  String? leadershipQualitiesRating;
  String? communicationRating;
  String? problemSolvingRating;
  String? attendenceComment;
  String? workethicsComment;
  String? qualityOfWorkComment;
  String? leadershipComment;
  String? communicationComment;
  String? problemSolvingComment;
  String? reason;
  String? createdOn;
  String? pmFirstName;
  String? pmLastName;
  String? userDepartment;
  String? manRating;

  ManagerRating({
     this.appraisalId,
     this.requestId,
     this.userId,
     this.attendenceRating,
     this.workethicsRating,
     this.qualityOfWorkRating,
     this.leadershipQualitiesRating,
     this.communicationRating,
     this.problemSolvingRating,
     this.attendenceComment,
     this.workethicsComment,
     this.qualityOfWorkComment,
     this.leadershipComment,
     this.communicationComment,
     this.problemSolvingComment,
     this.reason,
     this.createdOn,
     this.pmFirstName,
     this.pmLastName,
     this.userDepartment,
     this.manRating,
  });

  factory ManagerRating.fromJson(Map<String, dynamic> json) {
    return ManagerRating(
      appraisalId: json['appraisal_id'],
      requestId: json['request_id'],
      userId: json['user_id'],
      attendenceRating: json['attendence_rating'],
      workethicsRating: json['workethics_rating'],
      qualityOfWorkRating: json['qualityofwork_rating'],
      leadershipQualitiesRating: json['leadershipqualities_rating'],
      communicationRating: json['communication_rating'],
      problemSolvingRating: json['problemsolving_rating'],
      attendenceComment: json['attendence_comment'],
      workethicsComment: json['workethics_comment'],
      qualityOfWorkComment: json['qualityofwork_comment'],
      leadershipComment: json['leadership_comment'],
      communicationComment: json['communication_comment'],
      problemSolvingComment: json['problemsolving_comment'],
      reason: json['reason'],
      createdOn: json['created_on'],
      pmFirstName: json['pm_firstname'],
      pmLastName: json['pm_lastname'],
      userDepartment: json['user_department'],
      manRating: json['manrating'],
    );
  }
}