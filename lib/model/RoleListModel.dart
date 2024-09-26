class RoleListModel {
  String? roleId;
  String? roleName;
  String? description;
  String? permissions;
  String? addedOn;
  String? updatedOn;
  String? status;
  String? canCreate;
  String? canView;
  String? canApprove;
  String? canSupport;

  RoleListModel({
    this.roleId,
    this.roleName,
    this.description,
    this.permissions,
    this.addedOn,
    this.updatedOn,
    this.status,
    this.canCreate,
    this.canView,
    this.canApprove,
    this.canSupport,
  });

  // Factory method to create an instance from JSON
  factory RoleListModel.fromJson(Map<String, dynamic> json) {
    return RoleListModel(
      roleId: json['role_id'] ?? '', // Providing a fallback empty string if null
      roleName: json['role_name'] ?? '',
      description: json['description'] ?? '',
      permissions: json['permissions'] ?? '',
      addedOn: json['addedOn'] ?? '',
      updatedOn: json['updatedOn'] ?? '',
      status: json['status'] ?? '',
      canCreate: json['can_Create'] ?? '',
      canView: json['can_view'] ?? '',
      canApprove: json['can_approve'] ?? '',
      canSupport: json['can_support'] ?? '',
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'role_id': roleId,
      'role_name': roleName,
      'description': description,
      'permissions': permissions,
      'addedOn': addedOn,
      'updatedOn': updatedOn,
      'status': status,
      'can_Create': canCreate,
      'can_view': canView,
      'can_approve': canApprove,
      'can_support': canSupport,
    };
  }
}