class LeaveTypeModel {
  final String leaveTypeId;
  final String customerId;
  final String leaveType;
  final String activeStatus;
  final String createdOn;

  LeaveTypeModel({
    required this.leaveTypeId,
    required this.customerId,
    required this.leaveType,
    required this.activeStatus,
    required this.createdOn,
  });

  // Factory constructor to create an instance from JSON
  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) {
    return LeaveTypeModel(
      leaveTypeId: json['leave_type_id'] ?? '',
      customerId: json['customer_id'] ?? '',
      leaveType: json['leaveType'] ?? '',
      activeStatus: json['activeStatus'] ?? '',
      createdOn: json['createdOn'] ?? '',
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'leave_type_id': leaveTypeId,
      'customer_id': customerId,
      'leaveType': leaveType,
      'activeStatus': activeStatus,
      'createdOn': createdOn,
    };
  }
}