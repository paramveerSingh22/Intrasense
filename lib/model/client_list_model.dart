class ClientListModel {
  String companyId;
  String cmpName;
  String clientUniqeid;
  String cmpEmailid;
  String cmpContact;
  String cmpIndustry;
  String cmpAddress1;
  String cmpAddress2;
  String cmpCountry;
  String cmpState;
  String cmpCity;
  String cmpPincode;
  String cmpCreationDate;
  String? cmpLastModified;
  String cmpArchiveStatus;
  String industryName;

  ClientListModel({
    required this.companyId,
    required this.cmpName,
    required this.clientUniqeid,
    required this.cmpEmailid,
    required this.cmpContact,
    required this.cmpIndustry,
    required this.cmpAddress1,
    required this.cmpAddress2,
    required this.cmpCountry,
    required this.cmpState,
    required this.cmpCity,
    required this.cmpPincode,
    required this.cmpCreationDate,
    this.cmpLastModified,
    required this.cmpArchiveStatus,
    required this.industryName,
  });

  ClientListModel.empty()
      : companyId = '',
        cmpName = '',
        clientUniqeid = '',
        cmpEmailid = '',
        cmpContact = '',
        cmpIndustry = '',
        cmpAddress1 = '',
        cmpAddress2 = '',
        cmpCountry = '',
        cmpState = '',
        cmpCity = '',
        cmpPincode = '',
        cmpCreationDate = '',
        cmpLastModified = '',
        cmpArchiveStatus = '',
        industryName = '';


  factory ClientListModel.fromJson(Map<String, dynamic> json) {
    return ClientListModel(
      companyId: json['company_id'],
      cmpName: json['cmp_name'],
      clientUniqeid: json['client_uniqeid'],
      cmpEmailid: json['cmp_emailid'],
      cmpContact: json['cmp_contact'],
      cmpIndustry: json['cmp_industry'],
      cmpAddress1: json['cmp_address1'],
      cmpAddress2: json['cmp_address2'] ?? '',
      cmpCountry: json['cmp_country'],
      cmpState: json['cmp_state'],
      cmpCity: json['cmp_city'],
      cmpPincode: json['cmp_pincode'],
      cmpCreationDate: json['cmp_creation_date'],
      cmpLastModified: json['cmp_last_modified'],
      cmpArchiveStatus: json['cmp_archive_status'],
      industryName: json['industryName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_id': companyId,
      'cmp_name': cmpName,
      'client_uniqeid': clientUniqeid,
      'cmp_emailid': cmpEmailid,
      'cmp_contact': cmpContact,
      'cmp_industry': cmpIndustry,
      'cmp_address1': cmpAddress1,
      'cmp_address2': cmpAddress2,
      'cmp_country': cmpCountry,
      'cmp_state': cmpState,
      'cmp_city': cmpCity,
      'cmp_pincode': cmpPincode,
      'cmp_creation_date': cmpCreationDate,
      'cmp_last_modified': cmpLastModified,
      'cmp_archive_status': cmpArchiveStatus,
      'industryName': industryName,
    };
  }
}