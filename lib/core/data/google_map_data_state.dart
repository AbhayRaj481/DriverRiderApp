part of 'data.dart';

class GoogleMapDataState {

  // State
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  LatLng? _pickupCoordinate;
  LatLng? _destinationCoordinate;

  // Getters
  GoogleMapController? get mapController =>_mapController;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polylines => _polylines;
  LatLng? get pickupCoordinate => _pickupCoordinate;
  LatLng? get destinationCoordinate => _destinationCoordinate;

  set setMapController(GoogleMapController controller){
    _mapController = controller;
  }

  // Polyliine
  set setPolylines(List<Polyline> value){
    _polylines = value.toSet();
  }

  addPolyLine(Polyline value){
    _polylines.clear();
    _polylines.add(value);
  }

  // Markers
  set setMarker(List<Marker> value){
    _markers = value.toSet();
  }

  void addMarker(Marker value) {
    _markers.add(value);
  }

  set setPickupCoordinate(LatLng? value){
    _pickupCoordinate = value;
  }

  set setDestinationCoordinate(LatLng? value){
    _destinationCoordinate = value;
  }


  Future drawRoute() async {
    if((_pickupCoordinate == null) || (_destinationCoordinate == null)) return;
    var result = await GoogleMapUtils.getPolylineRoute(_pickupCoordinate!, _destinationCoordinate!);
    List<LatLng> polylineCoordinates = [];
    for (var latLng in result) {
      polylineCoordinates.add(
        LatLng(latLng.latitude, latLng.longitude));
    }

    PolylineId id = const PolylineId("poly_route");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 5,
    );
    addPolyLine(polyline);
  }

  void clearRoute() => _polylines.clear();
}