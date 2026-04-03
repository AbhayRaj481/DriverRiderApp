part of '../screen_lib.dart';

class RiderMapScreen extends StatefulWidget {
  const RiderMapScreen({super.key});

  @override
  State<RiderMapScreen> createState() => _RiderMapScreenState();
}

class _RiderMapScreenState extends State<RiderMapScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final LocationTracker _tracker = LocationTracker();
  StreamSubscription<Position>? _locationSubscription;
  LatLng? _currentPosition;
  LatLng? _pickupPosition;
  LatLng? _destinationPosition;
  String? _pickupAddress;
  String? _destinationAddress;
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  bool _showRoute = false;

  // Demo locations (mock for testing)
  static const LatLng _demoPickup = LatLng(37.7749, -122.4194); // SF
  static const LatLng _demoDest = LatLng(34.0522, -118.2437); // LA

  @override
  void initState() {
    super.initState();
    _initLocation();
    _pickupController.addListener(_onPickupChanged);
    _destinationController.addListener(_onDestinationChanged);
  }

  Future<void> _initLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Prompt user
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    _locationSubscription = _tracker.positionStream.listen((Position position) {
      _currentPosition = LatLng(position.latitude, position.longitude);
      if (_mapController != null && _currentPosition != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(_currentPosition!),
        );
      }
      setState(() {});
      if (_showRoute &&
          _pickupPosition != null &&
          _destinationPosition != null) {
        _updateRoute();
      }
    }, onError: (error) => debugPrint('Location error: $error'));
  }

  void _onPickupChanged() {
    if (_pickupController.text.toLowerCase().contains('pickup') ||
        _pickupController.text.isEmpty) {
      _setPickup(_demoPickup);
    }
    // In real: forward geocode text -> LatLng
  }

  void _onDestinationChanged() {
    if (_destinationController.text.toLowerCase().contains('dest') ||
        _destinationController.text.isEmpty) {
      _setDestination(_demoDest);
    }
  }

  Future<void> _setPickup(LatLng pos) async {
    _pickupPosition = pos;
    _pickupAddress = 'Demo Pickup: San Francisco, CA';
    await _addMarker('pickup', pos, 'Pickup', BitmapDescriptor.hueGreen);
    _pickupController.text = _pickupAddress ?? 'Pickup Location';
    setState(() {});
  }

  Future<void> _setDestination(LatLng pos) async {
    _destinationPosition = pos;
    _destinationAddress = 'Demo Destination: Los Angeles, CA';
    await _addMarker(
      'destination',
      pos,
      'Destination',
      BitmapDescriptor.hueRed,
    );
    _destinationController.text = _destinationAddress ?? 'Destination';
    setState(() {
      _showRoute = true;
    });
    if (_currentPosition != null) {
      _updateRoute();
    }
  }

  Future<void> _addMarker(
    String id,
    LatLng pos,
    String title,
    double hueValue,
  ) async {
    final BitmapDescriptor icon = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueBlue,
    ); // Simple hue approx
    _markers.removeWhere((m) => m.markerId.value == id);
    _markers.add(
      Marker(
        markerId: MarkerId(id),
        position: pos,
        infoWindow: InfoWindow(title: title),
        icon: icon,
      ),
    );
    setState(() {});
  }

  void _updateRoute() {
    _polylines.clear();
    if (_currentPosition == null ||
        _pickupPosition == null ||
        _destinationPosition == null)
      return;

    List<LatLng> points;
    // Route current -> pickup -> dest
    points = _generateRoutePoints(_currentPosition!, _pickupPosition!);
    points.addAll(
      _generateRoutePoints(_pickupPosition!, _destinationPosition!),
    );

    _polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: points,
        color: Colors.blue,
        width: 5,
      ),
    );
    setState(() {});
  }

  List<LatLng> _generateRoutePoints(LatLng start, LatLng end) {
    final List<LatLng> points = [];
    const int numPoints = 10;
    final double latDiff = end.latitude - start.latitude;
    final double lngDiff = end.longitude - start.longitude;
    for (int i = 0; i <= numPoints; i++) {
      final double t = i / numPoints;
      final double curve = math.sin(t * math.pi) * 0.005;
      final double lat =
          start.latitude + latDiff * t + curve * math.cos(t * math.pi * 2);
      final double lng =
          start.longitude + lngDiff * t + curve * math.sin(t * math.pi * 2);
      points.add(LatLng(lat, lng));
    }
    return points;
  }

  void _onMapTap(LatLng pos) async {
    if (_pickupPosition == null) {
      await _setPickup(pos);
    } else if (_destinationPosition == null) {
      await _setDestination(pos);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rider Map')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.7749, -122.4194),
              zoom: 12,
            ),
            onMapCreated: (controller) => _mapController = controller,
            markers: {
              ..._markers,
              if (_currentPosition != null)
                Marker(
                  markerId: const MarkerId('current'),
                  position: _currentPosition!,
                  infoWindow: const InfoWindow(title: 'Current Location'),
                  icon: BitmapDescriptor.defaultMarker,
                ),
            },
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onTap: _onMapTap,
          ),
          // Search Bar
          Positioned(
            top: 80,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _pickupController,
                    decoration: const InputDecoration(
                      labelText: 'Pickup Location',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _destinationController,
                    decoration: const InputDecoration(
                      labelText: 'Destination',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Constant Bottom Sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: DraggableScrollableSheet(
                initialChildSize: 0.3,
                minChildSize: 0.2,
                maxChildSize: 0.5,
                builder: (context, scrollController) => Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(blurRadius: 10, color: Colors.black26),
                    ],
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      const Center(
                        child: Icon(Icons.drag_handle, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Trip Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildLocationRow(
                        'Pickup',
                        _pickupAddress ?? _pickupController.text,
                      ),
                      const Divider(),
                      _buildLocationRow(
                        'Destination',
                        _destinationAddress ?? _destinationController.text,
                      ),
                      if (_showRoute) ...[
                        const Divider(),
                        const Text(
                          'Route ready!',
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow(String title, String address) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            color: title == 'Pickup' ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text('$title: $address')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _pickupController.dispose();
    _destinationController.dispose();
    super.dispose();
  }
}
