
class PostBody {
  String? translation;
  String? postId;
  String? title;
  String? address;
  String? rent;
  String? deposit;
  String? bedrooms;
  String? bathrooms;
  String? floors;
  String? description;
  String? possession;
  List? amenities;
  String? userId;
  String? mobile;
  String? email;

  PostBody(
      { this.translation,
        this.postId,
        this.title,
        this.address,
        this.rent,
        this.deposit,
        this.bedrooms,
        this.bathrooms,
        this.floors,
        this.description,
        this.possession,
        this.amenities,
        this.userId,
        this.mobile,
        this.email,
      });

  PostBody.fromJson(Map<String, dynamic> json) {
    translation = json['translation'];
    postId = json['postId'];
    title = json['title'];
    address = json['address'];
    rent = json['rent'];
    deposit = json['deposit'];
    bedrooms = json['bedrooms'];
    bathrooms = json['bathrooms'];
    floors = json['floors'];
    description = json['description'];
    possession = json['possession'];
    amenities = json['amenities'];
    userId = json['userId'];
    mobile = json['mobile'];
    email = json['email'];
}

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['translation'] = translation!;
    data['postId'] = postId ?? '0';
    data['title'] = title!;
    data['address'] = address!;
    data['rent'] = rent!;
    data['deposit'] = deposit!;
    data['bedrooms'] = bedrooms!;
    data['bathrooms'] = bathrooms!;
    data['floors'] = floors!;
    data['description'] = description!;
    data['possession'] = possession!;
    // Use the null-aware operator to safely join the amenities list
    data['amenities'] = amenities?.join(',') ?? '';
    data['userId'] = userId!;
    data['mobile'] = mobile!;
    data['email'] = email!;
    return data;
  }
}
