class AllRegisteredStoresModel {
  int? id;
  String? storeName;
  String? storeDescription;
  String? storeImage;
  String? createdDate;
  int? statusId;
  String? statusName;
  bool? isActive;

  AllRegisteredStoresModel(
      {this.id,
        this.storeName,
        this.storeDescription,
        this.storeImage,
        this.createdDate,
        this.statusId,
        this.statusName,
        this.isActive});

  AllRegisteredStoresModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeName = json['storeName'];
    storeDescription = json['storeDescription'];
    storeImage = json['storeImage'];
    createdDate = json['createdDate'];
    statusId = json['statusId'];
    statusName = json['statusName'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['storeName'] = storeName;
    data['storeDescription'] = storeDescription;
    data['storeImage'] = storeImage;
    data['createdDate'] = createdDate;
    data['statusId'] = statusId;
    data['statusName'] = statusName;
    data['isActive'] = isActive;
    return data;
  }
}
