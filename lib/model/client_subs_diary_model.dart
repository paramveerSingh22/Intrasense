class ClientSubsDiaryModel {
  final String? entityId;
  final String? entityCmpTrackId;
  final String? entityName;
  final String? entityAddress;
  final String? entityAddress2;
  final String? country;
  final String? state;
  final String? city;
  final String? postalCode;
  final String? industryType;
  final String? entityPhone;
  final String? entityEmail;
  final String? entityCreationDate;
  final String? entityLastModified;
  final String? entityArchiveStatus;
  final String? industryName;

  ClientSubsDiaryModel({
    this.entityId,
    this.entityCmpTrackId,
    this.entityName,
    this.entityAddress,
    this.entityAddress2,
    this.country,
    this.state,
    this.city,
    this.postalCode,
    this.industryType,
    this.entityPhone,
    this.entityEmail,
    this.entityCreationDate,
    this.entityLastModified,
    this.entityArchiveStatus,
    this.industryName,
  });

  factory ClientSubsDiaryModel.fromJson(Map<String, dynamic> json) {
    return ClientSubsDiaryModel(
      entityId: json['entity_id'],
      entityCmpTrackId: json['entity_cmp_track_id'],
      entityName: json['entity_name'],
      entityAddress: json['entity_address'],
      entityAddress2: json['entity_address2'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      postalCode: json['postal_code'],
      industryType: json['industry_type'],
      entityPhone: json['entity_phone'],
      entityEmail: json['entity_email'],
      entityCreationDate: json['entity_creation_date'],
      entityLastModified: json['entity_last_modified'],
      entityArchiveStatus: json['entity_archive_status'],
      industryName: json['industryName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entity_id': entityId,
      'entity_cmp_track_id': entityCmpTrackId,
      'entity_name': entityName,
      'entity_address': entityAddress,
      'entity_address2': entityAddress2,
      'country': country,
      'state': state,
      'city': city,
      'postal_code': postalCode,
      'industry_type': industryType,
      'entity_phone': entityPhone,
      'entity_email': entityEmail,
      'entity_creation_date': entityCreationDate,
      'entity_last_modified': entityLastModified,
      'entity_archive_status': entityArchiveStatus,
      'industryName': industryName,
    };
  }
}