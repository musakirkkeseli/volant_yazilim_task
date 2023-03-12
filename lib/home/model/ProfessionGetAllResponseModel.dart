class ProfessionGetAllResponseModel {
  List<String>? result;

  ProfessionGetAllResponseModel({this.result});

  ProfessionGetAllResponseModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Result'] = this.result;
    return data;
  }
}
