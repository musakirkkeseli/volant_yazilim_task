import 'package:volant_yazilim_task/home/model/PersonModel.dart';

class PersonInsertRequestModel {
  Personel? personel;

  PersonInsertRequestModel({this.personel});

  PersonInsertRequestModel.fromJson(Map<String, dynamic> json) {
    personel =
        json['Request'] != null ? Personel.fromJson(json['Request']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.personel != null) {
      data['Request'] = this.personel!.toJson();
    }
    return data;
  }
}
