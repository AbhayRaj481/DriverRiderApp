part of '../screen_lib.dart';


class ChooseLocationByMapScreen extends StatefulWidget {
  const ChooseLocationByMapScreen({super.key});

  @override
  State<ChooseLocationByMapScreen> createState() =>
      _ChooseLocationByMapScreenState();
}

class _ChooseLocationByMapScreenState extends State<ChooseLocationByMapScreen> {
  GoogleMapController? _controller;
  LatLng? _selectedPosition;
  String? _selectedAddress;
  String? _selectedCoordinates;
  bool _isLoading = true;
  final Set<Marker> _markers = {};

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    // Permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackBar('Location permissions are denied');
        setState(() => _isLoading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackBar('Location permissions are permanently denied');
      setState(() => _isLoading = false);
      return;
    }

    // Services
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackBar('Location services are disabled.');
      setState(() => _isLoading = false);
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best
        )
      );
      _selectedPosition = LatLng(position.latitude, position.longitude);
      await _updateAddress(_selectedPosition!);
      if (_controller != null) {
        _controller!.animateCamera(
          CameraUpdate.newLatLngZoom(_selectedPosition!, 16),
        );
      }
    } catch (e) {
      _showSnackBar('Error getting location: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateAddress(LatLng position) async {
    try {
      var address = await CommonUtilsManager.getAddressFromLatLng(position);
      _selectedAddress = address;
      _selectedCoordinates = '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
      setState(() {});
      _updateMarker();
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  void _updateMarker() {
    _markers.clear();
    if (_selectedPosition != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('selected'),
          position: _selectedPosition!,
          infoWindow: InfoWindow(
            title: _selectedAddress ?? 'Selected Location',
          ),
        ),
      );
      setState(() {});
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    if (_selectedPosition != null) {
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(_selectedPosition!, 16),
      );
    }
  }

  void _onMapTap(LatLng position) {
    _selectedPosition = position;
    _controller?.animateCamera(CameraUpdate.newLatLng(position));
    _updateAddress(position);
  }

  void _confirmLocation() {
    if (_selectedAddress != null) {
      var map = {
        "latLng":{
          "lat": _selectedPosition?.latitude,
          "lng": _selectedPosition?.longitude
        },
        "address": _selectedAddress
      };
      Navigator.pop(context, map);
    } else {
      _showSnackBar('Please select a location first');
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Location'), elevation: 0),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _selectedPosition != null
                      ? CameraPosition(target: _selectedPosition!, zoom: 16)
                      : _kGooglePlex,
                  onMapCreated: _onMapCreated,
                  onTap: _onMapTap,
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                ),
                Positioned(
                  bottom: context.getBottomNotchHeight(),
                  left: 16,
                  right: 16,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text(
                                 'Address:',
                                 style: Theme.of(context).textTheme.titleMedium,
                               ),
                               const SizedBox(height: 8),
                               Expanded(
                                 child: Text(
                                   _selectedAddress ??
                                       'Tap on map to select location',
                                   style: Theme.of(context).textTheme.bodyLarge,
                                 ),
                               ),
                             ],
                           ),
                            if(_selectedCoordinates != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Coordinates:',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _selectedCoordinates ??
                                      'Tap on map to select location',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _confirmLocation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Confirm Location',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
