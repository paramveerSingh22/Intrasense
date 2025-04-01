class NotificationListModel {
  final String? notificationId;
  final String? notificationType;
  final String? notificationMessage;
  final String? senderId;
  final String? notificationDatetime;
  final String? receiverFirstname;
  final String? receiverLastname;
  final String? senderFirstname;
  final String? senderLastname;
  final String? profilePicture; // Nullable because profile picture could be missing
  final String? datetime;

  NotificationListModel({
     this.notificationId,
     this.notificationType,
     this.notificationMessage,
     this.senderId,
     this.notificationDatetime,
     this.receiverFirstname,
     this.receiverLastname,
     this.senderFirstname,
     this.senderLastname,
     this.profilePicture,  // Profile picture can be null
     this.datetime,
  });

  // Factory method to create a Notification from JSON
  factory NotificationListModel.fromJson(Map<String, dynamic> json) {
    return NotificationListModel(
      notificationId: json['notification_id'] as String?,
      notificationType: json['notification_type'] as String?,
      notificationMessage: json['notification_message'] as String?,
      senderId: json['sender_id'] as String?,
      notificationDatetime: json['notification_datetime'] as String?,
      receiverFirstname: json['receiver_firstname'] as String?,
      receiverLastname: json['receiver_lastname'] as String?,
      senderFirstname: json['sender_firstname'] as String?,
      senderLastname: json['sender_lastname'] as String?,
      profilePicture: json['profile_picture'] as String?,
      datetime: json['datetime'] as String?,
    );
  }

  // Method to convert Notification to JSON
  Map<String, dynamic> toJson() {
    return {
      'notification_id': notificationId,
      'notification_type': notificationType,
      'notification_message': notificationMessage,
      'sender_id': senderId,
      'notification_datetime': notificationDatetime,
      'receiver_firstname': receiverFirstname,
      'receiver_lastname': receiverLastname,
      'sender_firstname': senderFirstname,
      'sender_lastname': senderLastname,
      'profile_picture': profilePicture, // Nullable, can be null
      'datetime': datetime,
    };
  }
}