class MyFoldersModel {
  final String? id;
  final String? projectId;
  final String? name;
  final String? projectName;
  final String? type;
  final String? userId;
  final String? userFirstname;
  final String? userLastname;
  final String? parentId;
  final String? folderpath;
  final String? createdOn;
  final String? bookmarked;
  final String? isOwner;

  MyFoldersModel({
    this.id,
    this.projectId,
    this.name,
    this.projectName,
    this.type,
    this.userId,
    this.userFirstname,
    this.userLastname,
    this.parentId,
    this.folderpath,
    this.createdOn,
    this.bookmarked,
    this.isOwner,
  });

  factory MyFoldersModel.fromJson(Map<String, dynamic> json) {
    return MyFoldersModel(
      id: json['id'] ??"",
      projectId: json['project_id'] ??"",
      name: json['name'] ??"",
      projectName: json['project_name'] ??"",
      type: json['type'] ??"",
      userId: json['user_id'] ??"",
      userFirstname: json['user_firstname'] ??"",
      userLastname: json['user_lastname'] ??"",
      parentId: json['parentId'] ??"",
      folderpath: json['folderpath'] ??"",
      createdOn: json['createdOn'] ??"",
      bookmarked: json['bookmarked'] ??"",
      isOwner: json['isOwner']??"",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'name': name,
      'project_name': projectName,
      'type': type,
      'user_id': userId,
      'user_firstname': userFirstname,
      'user_lastname': userLastname,
      'parentId': parentId,
      'folderpath': folderpath,
      'createdOn': createdOn,
      'bookmarked': bookmarked,
      'isOwner': isOwner,
    };
  }
}


