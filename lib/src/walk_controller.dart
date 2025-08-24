import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'location_service.dart';

enum WalkState { idle, running, paused }

class WalkController extends ChangeNotifier {
  final LocationService _location = LocationService();
  StreamSubscription<Position>? _sub;

  WalkState _state = WalkState.idle;
  WalkState get state => _state;

  double _distanceMeters = 0;
  double get distanceMeters => _distanceMeters;

  Duration _elapsed = Duration.zero;
  Duration get elapsed => _elapsed;

  final List<Position> _track = [];
  List<Position> get track => List.unmodifiable(_track);

  Position? _lastPos;
  Timer? _timer;

  Future<void> start() async {
    if (_state == WalkState.running) return;
    _distanceMeters = 0;
    _elapsed = Duration.zero;
    _track.clear();
    _lastPos = null;

    await _location.start();
    _sub?.cancel();
    _sub = _location.stream.listen(_onPosition);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_state == WalkState.running) {
        _elapsed += const Duration(seconds: 1);
        notifyListeners();
    }
    });

    _state = WalkState.running;
    notifyListeners();
  }

    void pause() {
      if (_state != WalkState.running) return;
      _state = WalkState.paused;
      notifyListeners();
    }

    void resume() {
      if (_state != WalkState.paused) return;
      _state = WalkState.running;
      notifyListeners();
    }

    Future<void> stop() async {
      await _location.stop();
      await _sub?.cancel();
      _sub = null;
      _timer?.cancel();
      _timer = null;
      _state = WalkState.idle;
      notifyListeners();
    }

    void _onPosition(Position pos) {
      if (_state != WalkState.running) return;

      if (_lastPos != null) {
        final d = Geolocator.distanceBetween(
          _lastPos!.latitude,
          _lastPos!.longitude,
          pos.latitude,
          pos.longitude
        );

        final dt = pos.timestamp.difference(_lastPos!.timestamp ?? pos.timestamp) ?? Duration.zero;
        final speedMps = dt.inSeconds > 0 ? d / dt.inSeconds : pos.speed;
        if (d < 100 && speedMps < 4.5) {
          _distanceMeters += d;
          _track.add(pos);
          notifyListeners();
        } else {
          // ignore noisy point
        }
      } else {
        _track.add(pos);
        notifyListeners();
      }
      _lastPos = pos;
    }

    @override
    void dispose() {
      _timer?.cancel();
      _sub?.cancel();
      _location.dispose();
      super.dispose();
    }
}