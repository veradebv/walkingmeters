import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationService {
  StreamSubscription<Position>? _sub;
  final _controller = StreamController<Position>.broadcast();

  Stream<Position> get stream => _controller.stream;

  Future<bool> ensurePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  Future<void> start() async {
    final ok = await ensurePermission();
    if (!ok) return;

    final settings = const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 5, // emit every ~5m
    );

    _sub?.cancel();
    _sub = Geolocator.getPositionStream(locationSettings: settings).listen(
      (pos) {
        // Basic quality filter to reduce GPS noise
        if (pos.accuracy <= 30) {
          _controller.add(pos);
        }
      },
      onError: (e) => _controller.addError(e),
      cancelOnError: false,
    );
  }

  Future<void> stop() async {
    await _sub?.cancel();
    _sub = null;
  }

  void dispose() {
    _sub?.cancel();
    _controller.close();
  }
}