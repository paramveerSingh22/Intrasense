class ProjectManagersModel {
  String userId;
  String userName;

  ProjectManagersModel({required this.userId, required this.userName});

  // Factory method to create a UserModel from JSON
  factory ProjectManagersModel.fromJson(Map<String, dynamic> json) {
    return ProjectManagersModel(
      userId: json['user_id'],
      userName: json['usr_name'],
    );
  }

  // Method to convert a UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'usr_name': userName,
    };
  }
}