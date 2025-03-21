class TimeZoneModel {
  final String timezone;
  TimeZoneModel({required this.timezone});

  factory TimeZoneModel.fromJson(Map<String, dynamic> json) {
    return TimeZoneModel(
      timezone: json['timezone'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'timezone': timezone,
    };
  }
}