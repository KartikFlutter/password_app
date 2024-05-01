import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_app/model/password_model/password_model.dart';
import 'package:password_app/utils/hive_helper.dart';

class PasswordController extends GetxController {
  final titleEditingController = TextEditingController();
  final gameListScreenPasswordController = TextEditingController();
  RxList<PasswordModel> gameList = <PasswordModel>[].obs;

  // GameModel? selectedGame;
  RxBool addTime = false.obs;

  // RxBool deleteGame = ;

  Future<void> addNewGame(
      {required String date, required PasswordModel password}) async {
    await HiveHelper.createPassword(date, password);
    getGames(date);
  }

  Future<void> deleteNewGame(
      {String? date, required PasswordModel game}) async {
    await HiveHelper.deletePassword(date ?? "", game);
    getGames(date ?? "");
  }

  Future<void> getGames(String date) async {
    gameList.value = await HiveHelper.getAllGames(date);
    gameList.refresh();
  }

  /// Game List  Screen password
  void gameListScreenPassword(
      BuildContext context, PasswordModel gameModel, String date) async {
    final dateTime = DateTime.now();
    final min = dateTime.minute;
    if ("Indian$min" == gameListScreenPasswordController.text.trim()) {
      print("inside");
      // Get.offAll(() => const DateListScreen());
      await deleteNewGame(date: date, game: gameModel);
      Get.back();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid password")),
      );
    }
  }
}
