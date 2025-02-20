class ProjectManagersModel {
  String userId;
  String projectManagerFirstName;
  String projectManagerLastName;

  ProjectManagersModel({required this.userId, required this.projectManagerFirstName, required this.projectManagerLastName});

  // Factory method to create a UserModel from JSON
  factory ProjectManagersModel.fromJson(Map<String, dynamic> json) {
    return ProjectManagersModel(
      userId: json['user_id'],
      projectManagerFirstName: json['project_manager_firstname'],
      projectManagerLastName: json['project_manager_lastname'],
    );
  }

  // Method to convert a UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'project_manager_firstname': projectManagerFirstName,
      'project_manager_lastname': projectManagerLastName,
    };
  }
}