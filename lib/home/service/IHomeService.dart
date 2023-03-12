import 'package:dio/dio.dart';
import 'package:volant_yazilim_task/home/model/PersonDeleteRequestModel.dart';
import 'package:volant_yazilim_task/home/model/PersonInsertRequestModel.dart';
import 'package:volant_yazilim_task/home/model/PersonInsertResponseModel.dart';
import 'package:volant_yazilim_task/home/model/PersonelGetAllResponseModel.dart';
import 'package:volant_yazilim_task/home/model/ProfessionGetAllResponseModel.dart';

abstract class IHomeService {
  final Dio dio;

  IHomeService(this.dio);

//request URLs are assigned to variable
  final String professionGetAllPath =
      IHomeServicePath.ProfessionGetAll.rawValue;
  final String personelGetAllPath = IHomeServicePath.PersonelGetAll.rawValue;
  final String personelDeletePath = IHomeServicePath.PersonelDelete.rawValue;
  final String personelInsertPath = IHomeServicePath.PersonelInsert.rawValue;

//functions to be used for service operations are defined
  Future<ProfessionGetAllResponseModel?> postAllProfession();
  Future<PersonelGetAllResponseModel?> postAllPersonel();
  Future postDeletePersonel(PersonDeleteRequestModel personDeleteRequestModel);
  Future<PersonInsertResponseModel?> postInsertPersonel(
      PersonInsertRequestModel personInsertRequestModel);
}

enum IHomeServicePath {
  ProfessionGetAll,
  PersonelGetAll,
  PersonelDelete,
  PersonelInsert
}

//Provides management of request urls
extension IHomeServicePathExtension on IHomeServicePath {
  String get rawValue {
    switch (this) {
      case IHomeServicePath.ProfessionGetAll:
        return 'Profession/GetAll';
      case IHomeServicePath.PersonelGetAll:
        return 'Personel/GetAll';
      case IHomeServicePath.PersonelDelete:
        return 'Personel/Delete';
      case IHomeServicePath.PersonelInsert:
        return 'Personel/Insert';
    }
  }
}
