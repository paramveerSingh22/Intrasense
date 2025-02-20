class AddQuotationModel {
  final String pdfLink;

  // Constructor
  AddQuotationModel({required this.pdfLink});

  // Factory method to create an instance from a map
  factory AddQuotationModel.fromJson(Map<String, dynamic> json) {
    return AddQuotationModel(
      pdfLink: json['pdf_link'] ?? '',
    );
  }

  // Method to convert the instance to a map
  Map<String, dynamic> toJson() {
    return {
      'pdf_link': pdfLink,
    };
  }
}