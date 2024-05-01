import 'package:hive/hive.dart';

part 'password_model.g.dart';

@HiveType(typeId: 1)
class PasswordModel {
  @HiveField(0)
  String passwordName;

  PasswordModel({
    required this.passwordName,
  });
}
