part of '../widgets_lib.dart';

class NavigationMap extends StatefulWidget {
  final LatLng pickupLocation;
  final LatLng destination;
  const NavigationMap({
    super.key,
    required this.pickupLocation,
    required this.destination,
  });

  @override
  State<NavigationMap> createState() => _NavigationMapState();
}

class _NavigationMapState extends State<NavigationMap> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = <Marker>{};
  final Set<Polyline> _polylines = <Polyline>{};
  final LocationTracker _tracker = LocationTracker();
  StreamSubscription<Position>? _locationSubscription;
  LatLng? _currentPosition;
  int _currentLeg = 1; // 1: driver -> pickup, 2: pickup -> dest

  @override
  void initState() {
    super.initState();
    _initializeMap();
    _listenLocation();
    _addFixedMarkers();
  }

  void _initializeMap() {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            math.min(
                  widget.pickupLocation.latitude,
                  widget.destination.latitude,
                ) -
                0.01,
            math.min(
                  widget.pickupLocation.longitude,
                  widget.destination.longitude,
                ) -
                0.01,
          ),
          northeast: LatLng(
            math.max(
                  widget.pickupLocation.latitude,
                  widget.destination.latitude,
                ) +
                0.01,
            math.max(
                  widget.pickupLocation.longitude,
                  widget.destination.longitude,
                ) +
                0.01,
          ),
        ),
        100,
      ),
    );
  }

  void _listenLocation() {
    _locationSubscription = _tracker.positionStream.listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _updateRoute();
      });
    }, onError: (error) => debugPrint('Location error: $error'));
  }

  void _addFixedMarkers() {
    _markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: widget.pickupLocation,
        infoWindow: const InfoWindow(title: 'Pickup Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );
    _markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: widget.destination,
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
  }

  void _updateRoute() {
    if (_currentPosition == null) return;

    _polylines.clear();
    final LatLng target = _currentLeg == 1
        ? widget.pickupLocation
        : widget.destination;

    final List<LatLng> routePoints = _generateRoutePoints(
      _currentPosition!,
      target,
    );

    _polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: routePoints,
        color: Colors.blue,
        width: 8,
        patterns: _currentLeg == 1
            ? []
            : [PatternItem.dash(20), PatternItem.gap(10)],
      ),
    );

    setState(() {});
  }

  List<LatLng> _generateRoutePoints(LatLng start, LatLng end) {
    // Generate curved route points for demo (real: use Directions API)
    final List<LatLng> points = [];
    const int numPoints = 20;
    final double latDiff = end.latitude - start.latitude;
    final double lngDiff = end.longitude - start.longitude;

    for (int i = 0; i <= numPoints; i++) {
      final double t = i / numPoints;
      final double curve = math.sin(t * math.pi) * 0.01; // Curve offset
      final double lat =
          start.latitude + latDiff * t + curve * math.cos(t * math.pi * 2);
      final double lng =
          start.longitude + lngDiff * t + curve * math.sin(t * math.pi * 2);
      points.add(LatLng(lat, lng));
    }
    return points;
  }

  void _switchLeg() {
    setState(() {
      _currentLeg = _currentLeg == 1 ? 2 : 1;
    });
    _updateRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: widget.pickupLocation,
              zoom: 14,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            markers: {
              ..._markers,
              if (_currentPosition != null)
                Marker(
                  markerId: const MarkerId('current'),
                  position: _currentPosition!,
                  infoWindow: const InfoWindow(title: 'Driver Current'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue,
                  ),
                ),
            },
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.route,
                      color: _currentLeg == 1 ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _currentLeg == 1
                            ? 'Leg 1: Driver to Pickup'
                            : 'Leg 2: Pickup to Destination',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _switchLeg,
                      child: const Text('Switch Leg'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }
}
