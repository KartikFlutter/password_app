import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_app/home_screen.dart';
import 'package:password_app/utils/hive_helper.dart';

import '../model/home_model/home_model.dart';

class AuthController extends GetxController {
  final passwordController = TextEditingController();

  // final gameListScreenPasswordController = TextEditingController();
  // final teamListScreenPasswordController = TextEditingController();
  final dateListScreenPasswordController = TextEditingController();
  final amountLimitController = TextEditingController();
  final dateController = TextEditingController();

  // final declareResultController = TextEditingController();
  // final addTeamNameController = TextEditingController();
  // final addPlayerNumberController = TextEditingController();
  // final addPlayerAmountController = TextEditingController();

  /// password
  RxBool passwordVisible = true.obs;

  void togglePassword() {
    passwordVisible.value = !passwordVisible.value;
  }

  /// login Screen password
  void login(BuildContext context) {
    final dateTime = DateTime.now();
    // final day = DateFormat("EEEE").format(dateTime);
    final min = dateTime.minute;
    if ("Kartik$min" == passwordController.text.trim()) {
      Get.offAll(() => const HomeScreen());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid password")),
      );
    }
  }

  // /// Game List  Screen password
  // void gameListScreenPassword(BuildContext context, GameModel gameModel) async {
  //   final dateTime = DateTime.now();
  //   final min = dateTime.minute;
  //   if ("Indian$min" == gameListScreenPasswordController.text.trim()) {
  //     // Get.offAll(() => const DateListScreen());
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Please enter a valid password")),
  //     );
  //   }
  // }

  // /// Team List  Screen password
  // void teamListScreenPassword(BuildContext context) {
  //   final dateTime = DateTime.now();
  //   final min = dateTime.minute;
  //   if ("Indian$min" == teamListScreenPasswordController.text.trim()) {
  //     Get.offAll(() => const DateListScreen());
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Please enter a valid password")),
  //     );
  //   }
  // }
  /// date List  Screen password
  // void dateListScreenPassword(BuildContext context, DateModel dateModel) async {
  //   final dateTime = DateTime.now();
  //   final min = dateTime.minute;
  //   // final day = DateFormat("EEEE").format(dateTime);
  //   if ("Indian$min" == dateListScreenPasswordController.text.trim()) {
  //     // Get.offAll(() async =>
  //     await HiveHelper.deleteDate(DateModel(date: dateModel.date, games: []));
  //     Get.back();
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Please enter a valid password")),
  //     );
  //   }
  // }

  void dateListScreenPassword(BuildContext context, HomeModel homeModel) async {
    final dateTime = DateTime.now();
    // final dateTimeMonth = DateTime.now().month;
    final min = dateTime.minute;
    // final day = DateFormat("EEEE").format(dateTime);
    if ("Kartik$min" == dateListScreenPasswordController.text.trim()) {
      // Get.offAll(() async =>
      await HiveHelper.deleteHome(
          HomeModel(date: homeModel.date, password: []));
      Get.back();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid password")),
      );
    }
  }
}
