class ContactListModel {
  final String? contactId;
  final String? clientId;
  final String? subClientId;
  final String? contactName;
  final String? contactEmail;
  final String? contactDesignation;
  final String? contactMobile;
  final String? contactLandline;
  final String? contactLandlineExt;
  final String? clientName;
  final String? subclientName;
  final String? createdOn;
  final String? status;

  ContactListModel({
    this.contactId,
    this.clientId,
    this.subClientId,
    this.contactName,
    this.contactEmail,
    this.contactDesignation,
    this.contactMobile,
    this.contactLandline,
    this.contactLandlineExt,
    this.clientName,
    this.subclientName,
    this.createdOn,
    this.status,
  });

  factory ContactListModel.fromJson(Map<String, dynamic> json) {
    return ContactListModel(
      contactId: json['contact_id'],
      clientId: json['client_id'],
      subClientId: json['sub_clientId'],
      contactName: json['contactName'],
      contactEmail: json['contactEmail'],
      contactDesignation: json['contactDesignation'],
      contactMobile: json['contactMobile'],
      contactLandline: json['contactLandline'],
      contactLandlineExt: json['contactLandlineExt'],
      clientName: json['client_name'],
      subclientName: json['subclient_name'],
      createdOn: json['createdOn'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contact_id': contactId,
      'client_id': clientId,
      'sub_clientId': subClientId,
      'contactName': contactName,
      'contactEmail': contactEmail,
      'contactDesignation': contactDesignation,
      'contactMobile': contactMobile,
      'contactLandline': contactLandline,
      'contactLandlineExt': contactLandlineExt,
      'client_name': clientName,
      'subclient_name': subclientName,
      'createdOn': createdOn,
      'status': status,
    };
  }
}