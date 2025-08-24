import 'package:hive/hive.dart';

part 'walk_session_model.g.dart';

@HiveType(typeId: 1)
class WalkSession {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  double distanceMeters;

  WalkSession({required this.date, required this.distanceMeters});
}
