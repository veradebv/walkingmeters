import 'package:hive/hive.dart';

part 'profile_model.g.dart';

@HiveType(typeId: 0)
class Profile {
  @HiveField(0)
  String name;

  @HiveField(1)
  String username;

  @HiveField(2)
  String email;

  @HiveField(3)
  String profilePicture; // store file path or base46

  Profile({
    required this.name,
    required this.username,
    required this.email,
    required this.profilePicture,
  });
}