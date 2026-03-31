part of '../core_lib.dart';

class LocationTracker {
  static LocationTracker? _instance;
  factory LocationTracker() => _instance ??= LocationTracker._internal();
  LocationTracker._internal();

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  StreamSubscription<Position>? _positionSubscription;
  bool _isTracking = false;

  /// Initialize location permissions and services.
  Future<bool> init() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return false;
      }
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    return true;
  }

  /// Start streaming position from device and save to Firebase Realtime DB.
  /// driverId defaults to current Firebase user UID.
  Future<void> startTracking({String? driverId}) async {
    if (_isTracking) return;

    bool initialized = await init();
    if (!initialized) {
      throw Exception('Location services or permissions not available');
    }

    driverId ??= FirebaseAuth.instance.currentUser?.uid;
    if (driverId == null) {
      throw Exception('No driver ID provided and no authenticated user');
    }

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0, // meters
      ),
    ).listen(
      (Position position) async {
        if (kDebugMode) {
          print(">>>_ $position");
        }
        _dbRef.child('drivers/$driverId/location').set({
          'latitude': position.latitude,
          'longitude': position.longitude,
          'altitude': position.altitude ,
          'heading': position.heading ,
          'speed': position.speed ,
          'accuracy': position.accuracy,
          'timestamp': ServerValue.timestamp,
        });
      },
      onError: (error) {
        if (kDebugMode) {
          print('Location error: $error');
        }
      },
    );

    _isTracking = true;
  }

  /// Stop tracking.
  Future<void> stopTracking() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    _isTracking = false;
  }

  /// Is currently tracking?
  bool get isTracking => _isTracking;

  /// Public position stream.
  Stream<Position> get positionStream => Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );

  /// Cleanup.
  void dispose() {
    stopTracking();
  }
}
