class CountryListModel {
  final String id;
  final String countryCode;
  final String countryName;

  CountryListModel({
    required this.id,
    required this.countryCode,
    required this.countryName,
  });

  factory CountryListModel.fromJson(Map<String, dynamic> json) {
    return CountryListModel(
      id: json['id'] as String,
      countryCode: json['country_code'] as String,
      countryName: json['country_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country_code': countryCode,
      'country_name': countryName,
    };
  }
}