class TimeSheetActivityModel {
  final String activityId;
  final String activityName;

  TimeSheetActivityModel({
    required this.activityId,
    required this.activityName,
  });

  factory TimeSheetActivityModel.fromJson(Map<String, dynamic> json) {
    return TimeSheetActivityModel(
      activityId: json['activity_id'] as String,
      activityName: json['activity_name'] as String,
    );
  }

  // Method to convert a TimeSheetActivity instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'activity_id': activityId,
      'activity_name': activityName,
    };
  }
}

List<TimeSheetActivityModel> parseTimeSheetActivities(List<dynamic> jsonList) {
  return jsonList.map((json) => TimeSheetActivityModel.fromJson(json)).toList();
}