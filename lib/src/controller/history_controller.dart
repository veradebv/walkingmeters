import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/walk_session_model.dart';

class HistoryController extends ChangeNotifier {
  late Box<WalkSession> _box;

  HistoryController() {
    _box = Hive.box<WalkSession>('historyBox');
  }

  List<WalkSession> get sessions => _box.values.toList();

  void addSession(double distanceMeters) {
    _box.add(WalkSession(date: DateTime.now(), distanceMeters: distanceMeters));
    notifyListeners();
  }
}
