class GroupListModel {
  String? groupId;
  String? groupName;
  String? comments;
  String? userId;
  String? addedOn;
  String? addedByName;

  GroupListModel({
    this.groupId,
    this.groupName,
    this.comments,
    this.userId,
    this.addedOn,
    this.addedByName,
  });

  // Factory method to create GroupModel from JSON
  factory GroupListModel.fromJson(Map<String, dynamic> json) {
    return GroupListModel(
      groupId: json['group_id'],
      groupName: json['group_name'],
      comments: json['comments'],
      userId: json['user_id'],
      addedOn: json['addedOn'],
      addedByName: json['addedbyName'],
    );
  }

  // Method to convert GroupModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
      'group_name': groupName,
      'comments': comments,
      'user_id': userId,
      'addedOn': addedOn,
      'addedbyName': addedByName,
    };
  }

  // Factory method to parse list of groups from JSON
  static List<GroupListModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => GroupListModel.fromJson(json)).toList();
  }
}