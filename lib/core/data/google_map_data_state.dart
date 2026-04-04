part of 'data.dart';

class GoogleMapDataState {

  // State
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  // Getters
  GoogleMapController? get mapController =>_mapController;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polylines => _polylines;

  set setMapController(GoogleMapController controller){
    _mapController = controller;
  }

  set setMarker(List<Marker> value){
    _markers = value.toSet();
  }

  set setPolylines(List<Polyline> value){
    _polylines = value.toSet();
  }

}