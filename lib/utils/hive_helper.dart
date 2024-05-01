// Define methods for CRUD operations on each entity

import 'package:hive/hive.dart';
import 'package:password_app/model/home_model/home_model.dart';
import 'package:password_app/model/password_model/password_model.dart';

class HiveHelper {
  /// Read method for getting all dates
  static Future<List<HomeModel>> getAllDates() async {
    final box = await Hive.openBox<HomeModel>('dates');
    return box.values.toList();
  }

  /// Read method for getting all games for a specific date
  static Future<List<PasswordModel>> getAllGames(String date) async {
    final box = await Hive.openBox<HomeModel>('dates');
    final dateIndex =
        box.values.toList().indexWhere((item) => item.date == date);
    if (dateIndex != -1) {
      final dateBox = Hive.box<HomeModel>('dates');
      final dateObj = dateBox.getAt(dateIndex);
      if (dateObj != null) {
        return dateObj.password;
      }
    }
    return [];
  }

  // /// Read method for getting all teams for a specific game
  // static Future<List<TeamModel>> getAllTeams(
  //     String date, String gameName) async {
  //   final box = await Hive.openBox<DateModel>('dates');
  //   final dateIndex =
  //       box.values.toList().indexWhere((item) => item.date == date);
  //   if (dateIndex != -1) {
  //     final dateBox = Hive.box<DateModel>('dates');
  //     final dateObj = dateBox.getAt(dateIndex);
  //     if (dateObj != null) {
  //       final gameIndex =
  //           dateObj.games.indexWhere((g) => g.gameName == gameName);
  //       if (gameIndex != -1) {
  //         return dateObj.games[gameIndex].teams;
  //       }
  //     }
  //   }
  //   return [];
  // }
  //
  // /// Read method for getting all teams for a specific game
  // static Future<List<TeamModel>> getAllPLayerName(
  //   String date,
  //   String gameName,
  //   String playerName,
  // ) async {
  //   final box = await Hive.openBox<DateModel>('dates');
  //   final dateIndex =
  //       box.values.toList().indexWhere((item) => item.date == date);
  //   if (dateIndex != -1) {
  //     final dateBox = Hive.box<DateModel>('dates');
  //     final dateObj = dateBox.getAt(dateIndex);
  //     if (dateObj != null) {
  //       final gameIndex =
  //           dateObj.games.indexWhere((g) => g.gameName == gameName);
  //       if (gameIndex != -1) {
  //         return dateObj.games[gameIndex].teams;
  //       }
  //     }
  //   }
  //   return [];
  // }

  // Read method for getting all players for a specific team
  // static Future<List<PlayerModel>> getAllPlayers(
  //     String date, String gameName, String teamName) async {
  //   final box = await Hive.openBox<DateModel>('dates');
  //   final dateIndex =
  //       box.values.toList().indexWhere((item) => item.date == date);
  //   if (dateIndex != -1) {
  //     final dateBox = Hive.box<DateModel>('dates');
  //     final dateObj = dateBox.getAt(dateIndex);
  //     if (dateObj != null) {
  //       final gameIndex =
  //           dateObj.games.indexWhere((g) => g.gameName == gameName);
  //       if (gameIndex != -1) {
  //         final teamIndex = dateObj.games[gameIndex].teams
  //             .indexWhere((t) => t.teamName == teamName);
  //         if (teamIndex != -1) {
  //           return dateObj.games[gameIndex].teams[teamIndex].players;
  //         }
  //       }
  //     }
  //   }
  //   return [];
  // }

  /// create date
  static Future<void> createHome(HomeModel date) async {
    final box = await Hive.openBox<HomeModel>('dates');
    await box.add(date);
  }

  ///delete date
  static Future<void> deleteHome(HomeModel date) async {
    final box = await Hive.openBox<HomeModel>('dates');
    List<HomeModel> list = await box.values.toList();
    int index = list.indexWhere((element) => element.date == date.date);
    if (index != -1) {
      box.deleteAt(index);
    }
  }

  // static Future<void> setLimit(int limit) async {
  //   final box = await Hive.openBox<int>('limit');
  //   await box.put('limit', limit);
  // }
  //
  // static Future<int> getLimit() async {
  //   final box = await Hive.openBox<int>('limit');
  //   return box.get('limit') ?? 1000;
  // }
  //
  // static Future<void> setPrizeFactorInOut(int factor) async {
  //   final box = await Hive.openBox<int>('inOutFactor');
  //   await box.put('inOutFactor', factor);
  // }
  //
  // static Future<int> getPrizeFactorInOut() async {
  //   final box = await Hive.openBox<int>('inOutFactor');
  //   return box.get('inOutFactor') ?? 8;
  // }
  //
  // static Future<void> setPrizeFactorDouble(int factor) async {
  //   final box = await Hive.openBox<int>('doubleFactor');
  //   await box.put('doubleFactor', factor);
  // }
  //
  // static Future<int> getPrizeFactorDouble() async {
  //   final box = await Hive.openBox<int>('doubleFactor');
  //   return box.get('doubleFactor') ?? 80;
  // }

  /// Create Password
  static Future<void> createPassword(String date, PasswordModel game) async {
    final box = await Hive.openBox<HomeModel>('dates');
    //final dateIndex = box.keys.toList().indexOf(date.toString());
    final dateIndex =
        box.values.toList().indexWhere((item) => item.date == date);
    // log(dateIndex.toString());
    if (dateIndex != -1) {
      final dateBox = Hive.box<HomeModel>('dates');
      final dateObj = dateBox.getAt(dateIndex);
      if (dateObj != null) {
        dateObj.password.add(game);
        await dateBox.putAt(dateIndex, dateObj);
      }
    }
  }

  /// delete Password
  static Future<void> deletePassword(String date, PasswordModel game) async {
    final box = await Hive.openBox<HomeModel>('dates');
    //final dateIndex = box.keys.toList().indexOf(date.toString());
    final dateIndex =
        box.values.toList().indexWhere((item) => item.date == date);
    // log(dateIndex.toString());
    if (dateIndex != -1) {
      final dateBox = Hive.box<HomeModel>('dates');
      final dateObj = dateBox.getAt(dateIndex);
      if (dateObj != null) {
        int gameIndex = dateObj.password
            .indexWhere((element) => element.passwordName == game.passwordName);
        if (gameIndex != -1) {
          dateObj.password.removeAt(gameIndex);
          await dateBox.putAt(dateIndex, dateObj);
        }
      }
    }
  }

  // // Update method for a specific game
  // static Future<void> updateGame(
  //     {required String date,
  //     required String gameName,
  //     required int resultNumber}) async {
  //   final box = await Hive.openBox<DateModel>('dates');
  //   final dateIndex = box.values.toList().indexWhere((d) => d.date == date);
  //   if (dateIndex != -1) {
  //     final dateObj = box.getAt(dateIndex);
  //     if (dateObj != null) {
  //       final gameIndex =
  //           dateObj.games.indexWhere((game) => game.gameName == gameName);
  //       if (gameIndex != -1) {
  //         dateObj.games[gameIndex].resultNumber = resultNumber;
  //         await box.putAt(dateIndex, dateObj);
  //       }
  //     }
  //   }
  // }
  //
  // // Edit method for a specific game
  // static Future<void> editGameInfo({
  //   required String date,
  //   required String gameName,
  //   required String teamName,
  //   // required int resultNumber,
  //   required BidModel bidModel,
  //   required int index,
  //   required String playerName,
  // }) async {
  //   print("dhvkdhvkdfhvdf");
  //
  //   print(index);
  //   print(playerName);
  //
  //   final box = await Hive.openBox<DateModel>('dates');
  //   final dateIndex =
  //       box.values.toList().indexWhere((item) => item.date == date);
  //   if (dateIndex != -1) {
  //     final dateBox = Hive.box<DateModel>('dates');
  //     final dateObj = dateBox.getAt(dateIndex);
  //     if (dateObj != null) {
  //       final gameIndex =
  //           dateObj.games.indexWhere((g) => g.gameName == gameName);
  //       if (gameIndex != -1) {
  //         final teamIndex = dateObj.games[gameIndex].teams
  //             .indexWhere((t) => t.teamName == teamName);
  //         if (teamIndex != -1) {
  //           int indexPlayer = dateObj.games[gameIndex].teams[teamIndex].players
  //               .indexWhere((element) => element.playerName == playerName);
  //           if (indexPlayer != -1) {
  //             dateObj.games[gameIndex].teams[teamIndex].players[indexPlayer]
  //                 .bids[index] = bidModel;
  //           }
  //           await dateBox.putAt(dateIndex, dateObj);
  //         }
  //       }
  //     }
  //   }
  // }

  // ///Create Team
  // static Future<void> createTeam(
  //     {required String date,
  //     required String gameName,
  //     required TeamModel team}) async {
  //   final box = await Hive.openBox<DateModel>('dates');
  //   final dateIndex =
  //       box.values.toList().indexWhere((item) => item.date == date);
  //   log(dateIndex.toString());
  //   if (dateIndex != -1) {
  //     final dateBox = Hive.box<DateModel>('dates');
  //     final dateObj = dateBox.getAt(dateIndex);
  //     if (dateObj != null) {
  //       final gameIndex =
  //           dateObj.games.indexWhere((g) => g.gameName == gameName);
  //       if (gameIndex != -1) {
  //         dateObj.games[gameIndex].teams.add(team);
  //         await dateBox.putAt(dateIndex, dateObj);
  //       }
  //     }
  //   }
  // }
  //
  // /// Delete Team
  // static Future<void> deleteTeam(
  //     {required String date,
  //     required String gameName,
  //     required TeamModel team,
  //     index}) async {
  //   final box = await Hive.openBox<DateModel>('dates');
  //   final dateIndex =
  //       box.values.toList().indexWhere((item) => item.date == date);
  //   log(dateIndex.toString());
  //   if (dateIndex != -1) {
  //     final dateBox = Hive.box<DateModel>('dates');
  //     final dateObj = dateBox.getAt(dateIndex);
  //     if (dateObj != null) {
  //       final gameIndex =
  //           dateObj.games.indexWhere((g) => g.gameName == gameName);
  //       if (gameIndex != -1) {
  //         int teamIndex = dateObj.games[gameIndex].teams
  //             .indexWhere((element) => element.teamName == team.teamName);
  //         if (teamIndex != -1) {
  //           dateObj.games[gameIndex].teams.removeAt(teamIndex);
  //           await dateBox.putAt(dateIndex, dateObj);
  //         }
  //       }
  //     }
  //   }
  // }

  // static Future<void> createPlayer(
  //     String date, String gameName, String teamName, PlayerModel player) async {
  //   final box = await Hive.openBox<DateModel>('dates');
  //   final dateIndex =
  //       box.values.toList().indexWhere((item) => item.date == date);
  //   if (dateIndex != -1) {
  //     final dateBox = Hive.box<DateModel>('dates');
  //     final dateObj = dateBox.getAt(dateIndex);
  //     if (dateObj != null) {
  //       final gameIndex =
  //           dateObj.games.indexWhere((g) => g.gameName == gameName);
  //       if (gameIndex != -1) {
  //         final teamIndex = dateObj.games[gameIndex].teams
  //             .indexWhere((t) => t.teamName == teamName);
  //         if (teamIndex != -1) {
  //           dateObj.games[gameIndex].teams[teamIndex].players.add(player);
  //           await dateBox.putAt(dateIndex, dateObj);
  //         }
  //       }
  //     }
  //   }
  // }
  //
  // /// Limit calculation of each game, this includes the players bidding amount on a
  // /// particular number, the number could be any between 0 and 99.
  // /// This method will return the sum of the bid amount placed on a particular input number
  // static Future<int> getTotalInvestmentOnANumberInAGame(int inputNumber,
  //     {required String gameName, required String dateName}) async {
  //   // Running on a separate thread
  //   // return Isolate.run(() async {
  //   // sum of bidding amount on the input number in all the teams inside a given game
  //   int biddingAmountSum = 0;
  //
  //   // get the team list
  //   List<TeamModel> teamList = await getAllTeams(dateName, gameName);
  //
  //   for (TeamModel team in teamList) {
  //     // Get player list
  //     for (PlayerModel player in team.players) {
  //       for (BidModel bid in player.bids) {
  //         if (bid.bidingNumber == inputNumber) {
  //           biddingAmountSum += bid.bidingAmount;
  //         }
  //       }
  //     }
  //   }
  //   log('total investment for the number $inputNumber is $biddingAmountSum');
  //   return biddingAmountSum;
  // }

  // static Future<int> getTotalInvestmentOnANumberInAGame(int inputNumber,
  //     {required String gameName, required String dateName}) async {
  //   // Running on a separate thread
  //   // return Isolate.run(() async {
  //   // sum of bidding amount on the input number in all the teams inside a given game
  //   int biddingAmountSum = 0;
  //   // get the team list
  //   List<TeamModel> teamList = await getAllTeams(dateName, gameName);
  //
  //   for (TeamModel team in teamList) {
  //     // Get player list
  //     for (PlayerModel player in team.players) {
  //       for (BidModel bid in player.bids) {
  //         if (bid.bidingNumber == inputNumber) {
  //           biddingAmountSum += bid.bidingAmount;
  //         }
  //       }
  //     }
  //   }
  //   log('total investment for the number $inputNumber is $biddingAmountSum');
  //   return biddingAmountSum;
  // }

  // static Future<int> fetchGameResultNumber(
  //     {required String gameName, required String dateName}) async {
  //   // get the team list
  //   List<GameModel> gameList = await getAllGames(dateName);
  //
  //   final game =
  //       gameList.where((element) => element.gameName == gameName).toList();
  //
  //   return game.first.resultNumber;
  // }
}
