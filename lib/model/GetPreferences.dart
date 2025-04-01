class Getpreferences {
  String? notificationPreferenceId;


  Getpreferences({
    this.notificationPreferenceId,

  });

  Getpreferences.empty()
      : notificationPreferenceId = '';

  factory Getpreferences.fromJson(Map<String, dynamic> json) {
    return Getpreferences(
      notificationPreferenceId: json['notification_preference_id']as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notification_preference_id': notificationPreferenceId,
    };
  }
}