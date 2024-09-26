class IndustryListModel {
  final String? id;
  final String? type;

  IndustryListModel({this.id, this.type});

  factory IndustryListModel.fromJson(Map<String, dynamic> json) {
    return IndustryListModel(
      id: json['id'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
    };
  }
}