import 'dart:convert';

class PostsModel {
  int? totalSize;
  String? limit;
  int? offset;
  List<Posts>? posts;

  PostsModel({this.totalSize, this.limit, this.offset, this.posts});

  PostsModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'].toString();
    offset = (json['offset'] != null && json['offset'].toString().trim().isNotEmpty) ? int.parse(json['offset'].toString()) : null;
    if (json['stores'] != null) {
      posts = [];
      json['stores'].forEach((v) {
        posts!.add(Posts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (posts != null) {
      data['stores'] = posts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Posts {
  int? id;
  int? user_id;
  String? title;
  String? address;
  String? rent_per_month;
  String? deposit;
  int? bedrooms;
  int? bathrooms;
  int? floors;
  String? description;
  String? possession_date;
  String? mobile;
  String? email;
  String? image1;
  String? image2;
  String? image3;
  String? image4;
  String? amenities;
  int? status;
  int? isActive;
  int? postType;
  String? createdAt;
  String? statusName;
  String? createdDate;

  Posts(
      {this.id,
        this.user_id,
        this.title,
        this.address,
        this.rent_per_month,
        this.deposit,
        this.bedrooms,
        this.bathrooms,
        this.floors,
        this.description,
        this.possession_date,
        this.mobile,
        this.email,
        this.image1,
        this.image2,
        this.image3,
        this.image4,
        this.amenities,
        this.status,
        this.isActive,
        this.postType,
        this.createdAt,
        this.statusName,
        this.createdDate,
      });


  Posts.fromJson(Map<String, dynamic> json) {
    print('testing before parsing');
    print(json); // Add this line before parsing
    print('after parsing');
    id = json['id'];
    user_id = json['user_id'];
    title = json['title'];
    address = json['address'];
    rent_per_month = json['rent_per_month'];
    deposit = json['deposit'];
    bedrooms = json['bedrooms'];
    bathrooms = json['bathrooms'] ?? '';
    floors = json['floors'];
    description = json['description'];
    possession_date = json['possession_date'];
    mobile = json['mobile'];
    email = json['email'];
    image1 = json['image1'];
    image2 = json['image2'];
    image3 = json['image3'];
    image4 = json['image4'];
    status = json['status'];
    amenities = json['amenities'];
    isActive = json['is_active'];
    postType = json['post_type'];
    // if (json['amenities'] != null) {
    //   amenities = <Schedules>[];
    //   json['schedules'].forEach((v) {
    //     schedules!.add(Schedules.fromJson(v));
    //   });
    // }
    createdAt = json['created_at'];
    statusName = json['statusName'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['user_id'] = user_id;
    data['title'] = title;
    data['address'] = title;
    data['rent_per_month'] = rent_per_month;
    data['deposit'] = deposit;
    data['bedrooms']=bedrooms;
    data['bathrooms']=bathrooms;
    data['floors']=floors;
    data['description']=description;
    data['possession_date']=possession_date;
    data['mobile'] = mobile;
    data['email'] = email;
    data['image1']=image1;
    data['image2']=image2;
    data['image3']=image3;
    data['image4']=image4;
    data['amenities']=amenities;
    data['status']=status;
    data['post_type']=postType;
    data['image4']=image4;
    data['created_at'] = createdAt;
    return data;
  }
}

class Discount {
  int? id;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  double? minPurchase;
  double? maxDiscount;
  double? discount;
  String? discountType;
  int? storeId;
  String? createdAt;
  String? updatedAt;




  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['min_purchase'] = minPurchase;
    data['max_discount'] = maxDiscount;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['store_id'] = storeId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Schedules {
  int? id;
  int? storeId;
  int? day;
  String? openingTime;
  String? closingTime;

  Schedules(
      {this.id,
        this.storeId,
        this.day,
        this.openingTime,
        this.closingTime});

  Schedules.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    day = json['day'];
    openingTime = json['opening_time'].substring(0, 5);
    closingTime = json['closing_time'].substring(0, 5);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['store_id'] = storeId;
    data['day'] = day;
    data['opening_time'] = openingTime;
    data['closing_time'] = closingTime;
    return data;
  }
}

class Refund {
  int? id;
  int? orderId;
  List<String>? image;
  String? customerReason;
  String? customerNote;
  String? adminNote;

  Refund(
      {this.id,
        this.orderId,
        this.image,
        this.customerReason,
        this.customerNote,
        this.adminNote,
      });

  Refund.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    if(json['image'] != null){
      image = [];
      jsonDecode(json['image']).forEach((v) => image!.add(v));
    }
    customerReason = json['customer_reason'];
    customerNote = json['customer_note'];
    adminNote = json['admin_note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['image'] = image;
    data['customer_reason'] = customerReason;
    data['customer_note'] = customerNote;
    data['admin_note'] = adminNote;
    return data;
  }
}