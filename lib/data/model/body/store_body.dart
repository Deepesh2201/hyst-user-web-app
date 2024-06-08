
class StoreBody {
  String? translation;
  String? tax;
  String? minDeliveryTime;
  String? maxDeliveryTime;
  String? lat;
  String? lng;
  String? storeName;
  String? storeAddress;
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? password;
  String? zoneId;
  String? moduleId;
  String? deliveryTimeType;
  String? cityId;
  String? areaId;
  String? locationLink;
  String? storeCategory;
  String? storeSubCategory;
  String? description;
  String? category;
  String? gmpLink;
  String? discPer;
  String? discDesc;
  String? userId;
  String? storeId;
  String? website;
  String? active;
  StoreBody(
      { this.translation,
        // this.tax,
        // this.minDeliveryTime,
        // this.maxDeliveryTime,
        // this.lat,
        // this.lng,
        this.storeId,
        this.storeName,
        this.storeAddress,
        this.fName,
        this.lName,
        this.phone,
        this.email,
        this.password,
        this.cityId,
        this.areaId,
        this.locationLink,
        this.storeCategory,
        this.storeSubCategory,
        this.description,
        this.category,
        this.gmpLink,
        this.discPer,
        this.discDesc,
        this.userId,
        this.website,
        this.active,
        // this.zoneId,
        // this.moduleId,
        // this.deliveryTimeType,
      });

  StoreBody.fromJson(Map<String, dynamic> json) {
    translation = json['translation'];
    // tax = json['tax'];
    // minDeliveryTime = json['min_delivery_time'];
    // maxDeliveryTime = json['max_delivery_time'];
    // lat = json['lat'];
    // lng = json['lng'];
    storeId = json['store_id'];
    storeName = json['store_name'];
    storeAddress = json['store_address'];
    cityId = json['city_id'];
    areaId = json['area_id'];
    fName = json['f_name'];
    // lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    website = json['website'];
    password = json['password'];
    description = json['description'];
    category = json['category'];
    gmpLink = json['gmpLink'];
    discPer = json['discPer'];
    discDesc = json['discDesc'];
    userId = json['user_id'];
    active = json['active'];

    // zoneId = json['zone_id'];
    // moduleId = json['module_id'];
    // deliveryTimeType = json['delivery_time_type'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['translations'] = translation!;
    // data['tax'] = tax!;
    // data['minimum_delivery_time'] = minDeliveryTime!;
    // data['maximum_delivery_time'] = maxDeliveryTime!;
    // data['latitude'] = lat!;
    // data['longitude'] = lng!;
    data['store_id'] = storeId ?? '0';
    data['store_name']=storeName!;
    data['store_address']=storeAddress!;
    data['city_id'] = cityId!;
    data['area_id'] = areaId!;
    data['f_name'] = fName!;
    // data['l_name'] = lName!;
    data['phone'] = phone!;
    data['email'] = email!;
    data['website'] = website!;
    data['password'] = password!;
    data['description'] = description!;
    data['category'] = category!;
    data['gmpLink'] = gmpLink!;
    data['discPer'] = discPer!;
    data['discDesc'] = discDesc!;
    data['user_id'] = userId!;
    data['active'] = active!;

    // data['zone_id'] = zoneId!;
    // data['module_id'] = moduleId!;
    // data['delivery_time_type'] = deliveryTimeType!;
    return data;
  }
}
