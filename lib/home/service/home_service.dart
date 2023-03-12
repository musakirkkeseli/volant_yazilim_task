import 'dart:io';

import 'package:dio/dio.dart';
import 'package:volant_yazilim_task/home/model/PersonDeleteRequestModel.dart';
import 'package:volant_yazilim_task/home/model/PersonInsertRequestModel.dart';
import 'package:volant_yazilim_task/home/model/PersonInsertResponseModel.dart';
import 'package:volant_yazilim_task/home/model/PersonelGetAllResponseModel.dart';
import 'package:volant_yazilim_task/home/model/ProfessionGetAllResponseModel.dart';
import 'package:volant_yazilim_task/home/service/IHomeService.dart';

class HomeService extends IHomeService {
  HomeService(Dio dio) : super(dio);

  @override
  Future<ProfessionGetAllResponseModel?> postAllProfession() async {
    final response = await dio.post(
      professionGetAllPath,
    );

    if (response.statusCode == HttpStatus.ok) {
      return ProfessionGetAllResponseModel.fromJson(response.data);
    } else {
      return null;
    }
  }

  @override
  Future<PersonelGetAllResponseModel?> postAllPersonel() async {
    final response = await dio.post(
      personelGetAllPath,
    );

    if (response.statusCode == HttpStatus.ok) {
      return PersonelGetAllResponseModel.fromJson(response.data);
    } else {
      return null;
    }
  }

  @override
  Future postDeletePersonel(
      PersonDeleteRequestModel personDeleteRequestModel) async {
    await dio.post(personelDeletePath, data: personDeleteRequestModel.toJson());
  }

  @override
  Future<PersonInsertResponseModel?> postInsertPersonel(
      PersonInsertRequestModel personInsertRequestModel) async {
    final response = await dio.post(personelInsertPath,
        data: personInsertRequestModel.toJson());

    if (response.statusCode == HttpStatus.ok) {
      return PersonInsertResponseModel.fromJson(response.data);
    } else {
      return null;
    }
  }
}
