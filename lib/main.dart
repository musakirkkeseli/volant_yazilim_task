import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volant_yazilim_task/constants/const_color.dart';
import 'package:volant_yazilim_task/constants/const_variables.dart';
import 'package:volant_yazilim_task/home/bloc/home_bloc.dart';
import 'package:volant_yazilim_task/home/service/home_service.dart';
import 'package:volant_yazilim_task/home/view/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Volant Yazılım Task',
      theme: ThemeData(
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: AppColor().mainColor, iconSize: 40),
          appBarTheme: AppBarTheme(
              backgroundColor: AppColor().whiteColor,
              iconTheme: IconThemeData(color: AppColor().blackColor),
              titleTextStyle:
                  TextStyle(color: AppColor().blackColor, fontSize: 20)),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: AppColor().mainColor,
            ),
          ),
          scaffoldBackgroundColor: AppColor().whiteColor),
      home: const HomePageBlocView(),
    );
  }
}

class HomePageBlocView extends StatelessWidget {
  const HomePageBlocView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
        create: (context) => HomeBloc(
              HomeService(Dio(BaseOptions(baseUrl: baseUrl))),
            )..add(const PersonelPostFetched()),
        child: const HomePage());
  }
}
