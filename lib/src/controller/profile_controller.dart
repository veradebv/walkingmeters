import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:walkingmeters/src/model/profile_model.dart';

class ProfileController extends ChangeNotifier {
  late Box<Profile> _box;

  Profile? _profile;
  Profile? get profile => _profile;

  ProfileController() {
    _box = Hive.box<Profile>('profileBox');
    if (_box.isNotEmpty) {
      _profile = _box.getAt(0);
    }
  }

  void saveProfile(Profile profile) {
    _box.clear(); // only one profile
    _box.add(profile);
    _profile = profile;
    notifyListeners();
  }
}
