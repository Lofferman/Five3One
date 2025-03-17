import 'package:hive/hive.dart';

part 'user_settings.g.dart';

//run to generate :  flutter packages pub run build_runner build
@HiveType(typeId: 1)
class UserSettings {
  @HiveField(0)
  final String rounding;

  @HiveField(1)
  final num precision;

  @HiveField(3)
  final num trainingMaxPercent;

  @HiveField(4)
  final DateTime createdAt;

  UserSettings(
      {required this.rounding,
      required this.precision,
      required this.trainingMaxPercent,
      required this.createdAt});
}
