part of '../rider.dart';

class RiderMapScreen extends StatefulWidget {
  const RiderMapScreen({super.key});

  @override
  State<RiderMapScreen> createState() => _RiderMapScreenState();
}

class _RiderMapScreenState extends State<RiderMapScreen> {

  // State
  final GoogleMapDataState _googleMapDataState = GoogleMapDataState();
  String? _pickup;
  String? _destination;


  @override
  void initState() {
    super.initState();
    _initLocation();
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
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(child: Container(color: AppColors.black.withValues(alpha: .8),)),
          Positioned.fill(child: Column(
            children: [
              // Search Bar
              RiderMapHeader(
                onPickupChanged: (value) async {
                  var latLng = await CommonUtilsManager.getLatLngFromAddress(value);
                  if(latLng != null) {
                    var marker = Marker(
                        markerId: const MarkerId("Pickup"),
                        position: latLng,
                        icon: BitmapDescriptor.defaultMarkerWithHue(.3)
                    );
                    _googleMapDataState.addMarker(marker);
                    _googleMapDataState.setPickupCoordinate = latLng;
                    _pickup = value.trim().isNotEmpty ? value : "N/A";
                    setState(() {});
                  }
                },
                onDestinationChanged: (value) async {
                  var latLng = await CommonUtilsManager.getLatLngFromAddress(value);
                  if(latLng != null) {
                    var marker = Marker(
                        markerId: const MarkerId("Destination"),
                        position: latLng,
                        icon: BitmapDescriptor.defaultMarkerWithHue(.3)
                    );
                    _googleMapDataState.addMarker(marker);
                    _googleMapDataState.setDestinationCoordinate = latLng;
                    _destination = value.trim().isNotEmpty ? value : "N/A";
                    setState(() {});
                  }
                },
              ),
             // Google Map
              Expanded(child:  GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(37.7749, -122.4194),
                  zoom: 12,
                ),
                onMapCreated: (controller) => _googleMapDataState.setMapController = controller,
                markers: {
                  ..._googleMapDataState.markers,
                },
                polylines: _googleMapDataState.polylines,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onTap: (latLng){},
              ),)
            ],
          )),

          // Constant Bottom Sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: context.deviceHeight * .6,
              child: RiderMapBottomSheet(
                pickupAddress: _pickup ?? "N/A",
                destinationAddress: _destination ?? "N/A",
                onSearch: () async {
                  if(validate()){
                    await _googleMapDataState.drawPolyline();
                    setState(() {});
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }



  bool validate() {
    if((_pickup ?? "").trim().isEmpty){
      CustomSnackbar.showError(context, "Please select location for pickup.");
      return false;
    }

    if((_destination ?? "").trim().isEmpty){
      CustomSnackbar.showError(context, "Please select location for destination.");
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
