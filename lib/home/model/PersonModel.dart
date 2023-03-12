class Personel {
  int? iD;
  String? name;
  String? profession;
  int? age;
  int? project;
  int? yearsOfExperience;
  String? email;
  String? phone;

  Personel(
      {this.iD,
      this.name,
      this.profession,
      this.age,
      this.project,
      this.yearsOfExperience,
      this.email,
      this.phone});

  Personel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['name'];
    profession = json['profession'];
    age = json['age'];
    project = json['project'];
    yearsOfExperience = json['yearsOfExperience'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ID'] = this.iD;
    data['name'] = this.name;
    data['profession'] = this.profession;
    data['age'] = this.age;
    data['project'] = this.project;
    data['yearsOfExperience'] = this.yearsOfExperience;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}
