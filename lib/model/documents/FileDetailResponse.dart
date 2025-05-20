class FileDetailResponse {
  final String? type;
  final String? location;
  final String? name;
  final String? parentId;
  final String? createdOn;
  final String? description;
  final String? ownerName;
  final List<SharedUser>? sharedWith;
  final List<HistoryItem>? history;

  FileDetailResponse({
     this.type,
     this.location,
     this.name,
    this.parentId,
     this.createdOn,
    this.description,
     this.ownerName,
     this.sharedWith,
     this.history,
  });

  factory FileDetailResponse.fromJson(Map<String, dynamic> json) {
    return FileDetailResponse(
      type: json['type']??0,
      location: json['location']??"",
      name: json['name']??"",
      parentId: json['parentId']??"",
      createdOn: json['createdOn']??"",
      description: json['description']??"",
      ownerName: json['ownerName']??"",
      sharedWith: (json['sharedWith'] as List<dynamic>)
          .map((e) => SharedUser.fromJson(e))
          .toList(),
      history: (json['history'] as List<dynamic>)
          .map((e) => HistoryItem.fromJson(e))
          .toList(),
    );
  }
}

class SharedUser {
  final String name;
  final String canEdit;
  final String image;

  SharedUser({
    required this.name,
    required this.canEdit,
    required this.image,
  });

  factory SharedUser.fromJson(Map<String, dynamic> json) {
    return SharedUser(
      name: json['name'],
      canEdit: json['canEdit'],
      image: json['image'],
    );
  }
}

class HistoryItem {
  final String? date;
  final String? action;
  final String? type;
  final String? targetUserName;
  final String? targetProfileImage;
  final String? fromName;
  final String? toName;
  final String? canEdit;
  final String? itemType;
  final int? userInd;

  HistoryItem({
     this.date,
     this.action,
     this.type,
    this.targetUserName,
    this.targetProfileImage,
     this.fromName,
     this.toName,
     this.canEdit,
     this.itemType,
     this.userInd,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      date: json['date']??"",
      action: json['action']??"",
      type: json['type']??"",
      targetUserName: json['targetUserName']??"",
      targetProfileImage: json['targetProfileImage']??"",
      fromName: json['fromName']??"",
      toName: json['toName']??"",
      canEdit: json['canEdit']??"",
      itemType: json['itemType']??"",
      userInd: json['userInd']??0,
    );
  }
}