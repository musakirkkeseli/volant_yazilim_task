import 'package:volant_yazilim_task/home/model/PersonModel.dart';

class PersonInsertResponseModel {
  Personel? result;

  PersonInsertResponseModel({this.result});

  PersonInsertResponseModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'] != null ? Personel.fromJson(json['Result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.result != null) {
      data['Result'] = this.result!.toJson();
    }
    return data;
  }
}
