class ProjectTypesModel {
  String moduleCategoryId;
  String moduleCatParentId;
  String moduleCatTitle;
  String moduleCatShortTitle;
  String moduleCatStatus;
  DateTime moduleCatCreateDate;
  DateTime moduleCatUpdateDate;
  List<CategoryType> categoryType;

  ProjectTypesModel({
    required this.moduleCategoryId,
    required this.moduleCatParentId,
    required this.moduleCatTitle,
    required this.moduleCatShortTitle,
    required this.moduleCatStatus,
    required this.moduleCatCreateDate,
    required this.moduleCatUpdateDate,
    required this.categoryType,
  });

  factory ProjectTypesModel.fromJson(Map<String, dynamic> json) {
    var categoryList = json['categoryType'] as List;
    List<CategoryType> categoryTypeList = categoryList.map((i) => CategoryType.fromJson(i)).toList();

    return ProjectTypesModel(
      moduleCategoryId: json['module_category_id'],
      moduleCatParentId: json['module_cat_parent_id'],
      moduleCatTitle: json['module_cat_title'],
      moduleCatShortTitle: json['module_cat_shorttitle'],
      moduleCatStatus: json['module_cat_status'],
      moduleCatCreateDate: DateTime.parse(json['module_cat_createdate']),
      moduleCatUpdateDate: DateTime.parse(json['module_cat_updatedate']),
      categoryType: categoryTypeList,
    );
  }
}

// Model for Category Type
class CategoryType {
  String moduleCategoryId;
  String moduleCatParentId;
  String moduleCatTitle;
  String moduleCatShortTitle;
  String moduleCatStatus;
  DateTime moduleCatCreateDate;
  DateTime moduleCatUpdateDate;

  CategoryType({
    required this.moduleCategoryId,
    required this.moduleCatParentId,
    required this.moduleCatTitle,
    required this.moduleCatShortTitle,
    required this.moduleCatStatus,
    required this.moduleCatCreateDate,
    required this.moduleCatUpdateDate,
  });

  factory CategoryType.fromJson(Map<String, dynamic> json) {
    return CategoryType(
      moduleCategoryId: json['module_category_id'],
      moduleCatParentId: json['module_cat_parent_id'],
      moduleCatTitle: json['module_cat_title'],
      moduleCatShortTitle: json['module_cat_shorttitle'],
      moduleCatStatus: json['module_cat_status'],
      moduleCatCreateDate: DateTime.parse(json['module_cat_createdate']),
      moduleCatUpdateDate: DateTime.parse(json['module_cat_updatedate']),
    );
  }
}