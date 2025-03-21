class ClientListModel {
  String? companyId;
  String? cmpName;
  String? clientUniqeid;
  String? cmpEmailid;
  String? cmpContact;
  String? cmpIndustry;
  String? cmpAddress1;
  String? cmpAddress2;
  String? cmpCountry;
  String? cmpState;
  String? cmpCity;
  String? cmpPincode;
  String? cmpCreationDate;
  String? cmpLastModified;
  String? cmpArchiveStatus;
  String? industryName;

  ClientListModel({
     this.companyId,
     this.cmpName,
     this.clientUniqeid,
     this.cmpEmailid,
     this.cmpContact,
     this.cmpIndustry,
     this.cmpAddress1,
     this.cmpAddress2,
     this.cmpCountry,
     this.cmpState,
     this.cmpCity,
     this.cmpPincode,
     this.cmpCreationDate,
    this.cmpLastModified,
     this.cmpArchiveStatus,
     this.industryName,
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
      companyId: json['company_id']as String?,
      cmpName: json['cmp_name']as String?,
      clientUniqeid: json['client_uniqeid']as String?,
      cmpEmailid: json['cmp_emailid']as String?,
      cmpContact: json['cmp_contact']as String?,
      cmpIndustry: json['cmp_industry']as String?,
      cmpAddress1: json['cmp_address1']as String?,
      cmpAddress2: json['cmp_address2'] as String?,
      cmpCountry: json['cmp_country']as String?,
      cmpState: json['cmp_state']as String?,
      cmpCity: json['cmp_city']as String?,
      cmpPincode: json['cmp_pincode']as String?,
      cmpCreationDate: json['cmp_creation_date']as String?,
      cmpLastModified: json['cmp_last_modified']as String?,
      cmpArchiveStatus: json['cmp_archive_status']as String?,
      industryName: json['industryName']as String?,
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