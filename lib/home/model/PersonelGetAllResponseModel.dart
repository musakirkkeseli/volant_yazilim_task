import 'package:volant_yazilim_task/home/model/PersonModel.dart';

class PersonelGetAllResponseModel {
  List<Personel>? personels;

  PersonelGetAllResponseModel({this.personels});

  PersonelGetAllResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['Result'] != null) {
      personels = <Personel>[];
      json['Result'].forEach((v) {
        personels!.add(Personel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.personels != null) {
      data['Result'] = this.personels!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
