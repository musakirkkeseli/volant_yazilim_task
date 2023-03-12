class PersonDeleteRequestModel {
  int? iD;

  PersonDeleteRequestModel({this.iD});

  PersonDeleteRequestModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ID'] = this.iD;
    return data;
  }
}
