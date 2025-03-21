class MeetingGroupListModel {
  final String groupId;
  final String groupName;

  // Constructor to initialize the properties
  MeetingGroupListModel({
    required this.groupId,
    required this.groupName,
  });

  // Factory constructor to create a GroupModel from a JSON map
  factory MeetingGroupListModel.fromJson(Map<String, dynamic> json) {
    return MeetingGroupListModel(
      groupId: json['group_id'] as String,
      groupName: json['group_name'] as String,
    );
  }

  // Method to convert a GroupModel to a map (useful for encoding to JSON)
  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
      'group_name': groupName,
    };
  }
}