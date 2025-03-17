import 'package:hive/hive.dart';

part 'lift_data.g.dart';
//run to generate :  flutter packages pub run build_runner build

@HiveType(typeId: 0)
class LiftData {
  @HiveField(0)
  final num liftTotal;

  @HiveField(1)
  final String liftType;

  @HiveField(3)
  final DateTime createdAt;

  LiftData(
      {required this.liftTotal,
      required this.liftType,
      required this.createdAt});
}
