class StoreReviewModel {
  int? id;
  String? comment;
  int? rating;
  String? customerName;
  String? customerImg;
  String? createdAt;
  String? updatedAt;

  StoreReviewModel(
      {this.id,
        this.comment,
        this.rating,
        this.customerName,
        this.customerImg,
        this.createdAt,
        this.updatedAt});

  StoreReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    String ratingStr = json['rating'];
    rating = int.tryParse(ratingStr) ?? 0;

    customerImg = json['profilepic'];
    customerName = json['customer_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['comment'] = comment;
    data['rating'] = rating;
    data['profilepic'] = customerImg;
    data['customer_name'] = customerName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
