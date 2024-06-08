import 'dart:convert';

class JobsModel {
  int? totalSize;
  String? limit;
  int? offset;
  List<Jobs>? jobs;

  JobsModel({this.totalSize, this.limit, this.offset, this.jobs});

  JobsModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'].toString();
    offset = (json['offset'] != null && json['offset'].toString().trim().isNotEmpty) ? int.parse(json['offset'].toString()) : null;
    if (json['stores'] != null) {
      jobs = [];
      json['stores'].forEach((v) {
        jobs!.add(Jobs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (jobs != null) {
      data['stores'] = jobs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Jobs {
  int? id;
  int? user_id;
  String? company_name;
  String? job_title;
  String? job_description;
  String? designation;
  String? salary_min;
  String? salary_max;
  String? location;
  String? min_education;
  String? experience;
  String? contact_person_name;
  String? contact_no;
  String? contact_email;
  String? website;
  String? job_type;
  String? shift;
  int? status;
  String? created_at;
  String? updated_at;
  String? createdDate;
  String? statusName;

  Jobs({
    this.id,
    this.user_id,
    this.company_name,
    this.job_title,
    this.job_description,
    this.designation,
    this.salary_min,
    this.salary_max,
    this.location,
    this.min_education,
    this.experience,
    this.contact_person_name,
    this.contact_no,
    this.contact_email,
    this.website,
    this.job_type,
    this.shift,
    this.status,
    this.created_at,
    this.updated_at,
    this.createdDate,
    this.statusName,
  });

  Jobs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user_id = json['user_id'];
    company_name = json['company_name'];
    job_title = json['job_title'];
    job_description = json['job_description'];
    designation = json['designation'];
    salary_min = json['salary_min'];
    salary_max = json['salary_max'];
    location = json['location'];
    min_education = json['min_education'];
    experience = json['experience'];
    contact_person_name = json['contact_person_name'];
    contact_no = json['contact_no'];
    contact_email = json['contact_email'];
    website = json['website'];
    job_type = json['job_type'];
    shift = json['shift'];
    status = json['status'];
    created_at = json['created_at'];
    updated_at = json['updated_at'];
    createdDate = json['createdDate'];
    statusName = json['statusName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = user_id;
    data['company_name'] = company_name;
    data['job_title'] = job_title;
    data['job_description'] = job_description;
    data['designation'] = designation;
    data['salary_min'] = salary_min;
    data['salary_max'] = salary_max;
    data['location'] = location;
    data['min_education'] = min_education;
    data['experience'] = experience;
    data['contact_person_name'] = contact_person_name;
    data['contact_no'] = contact_no;
    data['contact_email'] = contact_email;
    data['website'] = website;
    data['job_type'] = job_type;
    data['shift'] = shift;
    data['status'] = status;
    data['created_at'] = created_at;
    data['updated_at'] = updated_at;
    data['createdDate'] = createdDate;
    data['statusName'] = statusName;
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