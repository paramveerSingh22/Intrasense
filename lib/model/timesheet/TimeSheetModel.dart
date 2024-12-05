class TimeSheetModel {
  final String tmid;
  final String projectTrackId;
  final String? moduleTrackId;
  final String taskTrackId;
  final String userTrackId;
  final String activityTrackId;
  final String timespent;
  final String worktype;
  final String workDescription;
  final String timesheetDate;
  final String timeRange;
  final String timeInsertDatetime;
  final String? timeUpdateDatetime;
  final String tmArchiveStatus;
  final String timesheetFlag;
  final String projectName;
  final String projectShortname;
  final String taskName;
  final String activityName;

  TimeSheetModel({
  required this.tmid,
  required this.projectTrackId,
  this.moduleTrackId,
  required this.taskTrackId,
  required this.userTrackId,
  required this.activityTrackId,
  required this.timespent,
  required this.worktype,
  required this.workDescription,
  required this.timesheetDate,
  required this.timeRange,
  required this.timeInsertDatetime,
  this.timeUpdateDatetime,
  required this.tmArchiveStatus,
  required this.timesheetFlag,
  required this.projectName,
  required this.projectShortname,
  required this.taskName,
  required this.activityName,
  });


  factory TimeSheetModel.fromJson(Map<String, dynamic> json) {
    return TimeSheetModel(
      tmid: json['tmid'],
      projectTrackId: json['project_track_id'],
      moduleTrackId: json['module_track_id'],
      taskTrackId: json['task_track_id'],
      userTrackId: json['user_track_id'],
      activityTrackId: json['activity_track_id'],
      timespent: json['timespent'],
      worktype: json['worktype'],
      workDescription: json['work_description'],
      timesheetDate: json['timesheet_date'],
      timeRange: json['time_range'],
      timeInsertDatetime: json['time_insert_datetime'],
      timeUpdateDatetime: json['time_update_datetime'],
      tmArchiveStatus: json['tm_archive_status'],
      timesheetFlag: json['timesheet_flag'],
      projectName: json['project_name'],
      projectShortname: json['project_shortname'],
      taskName: json['task_name'],
      activityName: json['activity_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tmid': tmid,
      'project_track_id': projectTrackId,
      'module_track_id': moduleTrackId,
      'task_track_id': taskTrackId,
      'user_track_id': userTrackId,
      'activity_track_id': activityTrackId,
      'timespent': timespent,
      'worktype': worktype,
      'work_description': workDescription,
      'timesheet_date': timesheetDate,
      'time_range': timeRange,
      'time_insert_datetime': timeInsertDatetime,
      'time_update_datetime': timeUpdateDatetime,
      'tm_archive_status': tmArchiveStatus,
      'timesheet_flag': timesheetFlag,
      'project_name': projectName,
      'project_shortname': projectShortname,
      'task_name': taskName,
      'activity_name': activityName,
    };
  }
}

