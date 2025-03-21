class SelectedClientsModel{
  String? groupId;
  String? companyId;
  String? companyName;
  String? companyEmailId;
  String? companyContact;
  String? groupName;

  SelectedClientsModel({
     this.groupId,
     this.companyId,
     this.companyName,
     this.companyEmailId,
     this.companyContact,
     this.groupName,
  });

  // Factory constructor to create ClientData from JSON
  factory SelectedClientsModel.fromJson(Map<String, dynamic> json) {
    return SelectedClientsModel(
      groupId: json['group_id']?? '',
      companyId: json['company_id']?? '',
      companyName: json['company_name']?? '',
      companyEmailId: json['company_emailid']?? '',
      companyContact: json['company_contact']?? '',
      groupName: json['group_name']?? '',
    );
  }

  // Method to convert ClientData back to JSON
  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
      'company_id': companyId,
      'company_name': companyName,
      'company_emailid': companyEmailId,
      'company_contact': companyContact,
      'group_name': groupName,
    };
  }
}