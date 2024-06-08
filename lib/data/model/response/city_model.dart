class CityModel {
  int? id;
  String? name;
  int? stateId;
  String? icon;

  // List<ModuleZoneData>? zones;

  CityModel(
      {this.id,
        this.name,
        this.stateId,
        this.icon,
      });

  CityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    stateId = json['state_id'];
  }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['id'] = id;
  //   data['module_name'] = moduleName;
  //   data['module_type'] = moduleType;
  //   data['thumbnail'] = thumbnail;
  //   data['icon'] = icon;
  //
  //   return data;
  // }
// }
// class ModuleZoneData {
//   int? id;
//   String? name;
//   int? status;
//   String? createdAt;
//   String? updatedAt;
//   bool? cashOnDelivery;
//   bool? digitalPayment;
//
//   ModuleZoneData({this.id, this.name, this.status, this.createdAt, this.updatedAt, this.cashOnDelivery, this.digitalPayment});
//
//   ModuleZoneData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     status = json['status'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     cashOnDelivery = json['cash_on_delivery'];
//     digitalPayment = json['digital_payment'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['status'] = status;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['cash_on_delivery'] = cashOnDelivery;
//     data['digital_payment'] = digitalPayment;
//     return data;
//   }
// }
