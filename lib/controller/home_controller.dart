import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:password_app/model/home_model/home_model.dart';
import 'package:password_app/utils/hive_helper.dart';

class HomeController extends GetxController {
  final amountLimitController = TextEditingController();
  final inOutPrizeET = TextEditingController();
  final doublePrizeET = TextEditingController();

  final dateController = TextEditingController();

  RxList<HomeModel> dateList = <HomeModel>[].obs;
  RxBool addDate = false.obs;
  RxBool deleteDate = false.obs;

  @override
  void onInit() {
    getAllDate();
    super.onInit();
  }

  void addDateList() {
    dateList.add(HomeModel(date: dateController.text, password: []));
    Get.back();
    addDate.value = false;
  }

  DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  //
  // /// Automatically delete date
  // void deleteDateAfterFiveDays() async {
  //   print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
  //   for (int i = 0; i < dateList.length; i++) {
  //     // print("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
  //     // print(DateTime.now().difference(dateFormat.parse(dateList[i].date)).inDays);
  //     final difference =
  //         DateTime.now().difference(dateFormat.parse(dateList[i].date)).inDays;
  //     if (difference > 5) {
  //       await HiveHelper.deleteHome(
  //           HomeModel(date: dateList[i].date, password: []));
  //     }
  //   }
  // }

  /// Get All Date
  Future<void> getAllDate() async {
    dateList.value = await HiveHelper.getAllDates();
    // deleteDateAfterFiveDays();
  }
}
