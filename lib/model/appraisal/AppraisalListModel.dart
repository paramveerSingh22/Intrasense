import 'dart:convert';

class AppraisalListModel {
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
  final String? usrDesignation;
  final String? appraisedByFirstName;
  final String? appraisedByLastName;
  final String? selfRating;
  final String? manRating;

  AppraisalListModel({
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
     this.usrDesignation,
     this.appraisedByFirstName,
     this.appraisedByLastName,
     this.selfRating,
     this.manRating,
  });

  // Factory constructor to create an Appraisal instance from JSON
  factory AppraisalListModel.fromJson(Map<String, dynamic> json) {
    return AppraisalListModel(
      requestId: json['request_id'] ?? '',
      userId: json['user_id'] ?? '',
      customerId: json['customer_id'] ?? '',
      employeeId: json['employee_id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      department: json['department'] ?? '',
      projectManagerId: json['project_managerid'] ?? '',
      reason: json['reason'] ?? '',
      attendenceRating: json['attendence_rating'] ?? '',
      workEthicsRating: json['workethics_rating'] ?? '',
      qualityOfWorkRating: json['qualityofwork_rating'] ?? '',
      leadershipQualitiesRating: json['leadershipqualities_rating'] ?? '',
      communicationRating: json['communication_rating'] ?? '',
      problemSolvingRating: json['problemsolving_rating'] ?? '',
      knowledgeRating: json['knowledge_rating'] ?? '',
      attendenceComment: json['attendence_comment'] ?? '',
      workEthicsComment: json['workethics_comment'] ?? '',
      qualityOfWorkComment: json['qualityofwork_comment'] ?? '',
      leadershipComment: json['leadership_comment'] ?? '',
      communicationComment: json['communication_comment'] ?? '',
      problemSolvingComment: json['problemsolving_comment'] ?? '',
      knowledgeComment: json['knowledge_comment'],
      status: json['status'] ?? '',
      createdOn: json['created_on'] ?? '',
      usrDesignation: json['usr_designation'] ?? '',
      appraisedByFirstName: json['appraised_by_firstname'],
      appraisedByLastName: json['appraised_by_lastname'],
      selfRating: json['selfrating'] ?? "0.0",
      manRating: json['manrating'],
    );
  }

  // Method to convert Appraisal instance to JSON
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
      'usr_designation': usrDesignation,
      'appraised_by_firstname': appraisedByFirstName,
      'appraised_by_lastname': appraisedByLastName,
      'selfrating': selfRating,
      'manrating': manRating,
    };
  }
}