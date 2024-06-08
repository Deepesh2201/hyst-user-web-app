
class JobBody {
  String? translation;
  String? id;
  String? companyName;
  String? jobTitle;
  String? jobDescription;
  String? designation;
  String? minSalary;
  String? maxSalary;
  String? location;
  String? education;
  String? experience;
  String? contactPerson;
  String? contactNumber;
  String? email;
  String? website;
  String? userId;
  List? jobType;
  List? jobShift;

  JobBody(
      { this.translation,
        this.id,
        this.companyName,
        this.jobTitle,
        this.jobDescription,
        this.designation,
        this.minSalary,
        this.maxSalary,
        this.location,
        this.education,
        this.experience,
        this.contactPerson,
        this.contactNumber,
        this.email,
        this.website,
        this.userId,
        this.jobType,
        this.jobShift,
      });

  JobBody.fromJson(Map<String, dynamic> json) {
    translation = json['translation'];
    id = json['id'];
    companyName = json['companyName'];
    jobTitle = json['jobTitle'];
    jobDescription = json['jobDescription'];
    designation = json['designation'];
    minSalary = json['minSalary'];
    maxSalary = json['maxSalary'];
    location = json['location'];
    education = json['education'];
    experience = json['experience'];
    contactPerson = json['contactPerson'];
    contactNumber = json['contactNumber'];
    email = json['email'];
    website = json['website'];
    jobType = json['jobType'];
    jobShift = json['jobShift'];
    userId = json['userId'];
}

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['translation'] = translation!;
    data['id'] = id!;
    data['companyName'] = companyName!;
    data['jobTitle'] = jobTitle!;
    data['jobDescription'] = jobDescription!;
    data['designation'] = designation!;
    data['minSalary'] = minSalary!;
    data['maxSalary'] = maxSalary!;
    data['location'] = location!;
    data['education'] = education!;
    data['experience'] = experience!;
    data['contactPerson'] = contactPerson!;
    data['contactNumber'] = contactNumber!;
    data['email'] = email!;
    data['website'] = website!;
    data['jobType'] = jobType?.join(',') ?? '';
    data['jobShift'] = jobShift?.join(',') ?? '';
    data['userId'] = userId!;
    return data;
  }
}
