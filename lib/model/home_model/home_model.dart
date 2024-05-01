import 'package:hive/hive.dart';
import 'package:password_app/model/password_model/password_model.dart';

part 'home_model.g.dart';

@HiveType(typeId: 0)
class HomeModel {
  @HiveField(0)
  String date;

  @HiveField(1)
  List<PasswordModel> password;

  HomeModel({
    required this.date,
    required this.password,
  });
}
