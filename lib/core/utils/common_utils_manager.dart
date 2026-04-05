part of 'utils.dart';



class CommonUtilsManager {

  static Future<String> getAddressFromLatLng(LatLng latLng) async {
    try {
      // 1. Fetch placemarks from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
          latLng.latitude, latLng.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0]; // Get the most relevant result

        // 2. Construct the full address string
        // You can customize this format based on your needs
        return "${place.street}, ${place.subLocality}, ${place.locality}, "
            "${place.administrativeArea}, ${place.postalCode}, ${place.country}";
      } else {
        return "No address found for these coordinates.";
      }
    } catch (e) {
      return "Error occurred: $e";
    }
  }

  static Future<LatLng?> getLatLngFromAddress(String address) async {
    try {
      // 1. Fetch locations (coordinates) from the address string
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        // 2. Access the first (most relevant) result
        Location location = locations.first;
        print(">>>_ location -> ${location.toJson()}");
        return LatLng(location.latitude, location.longitude);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error occurred while geocoding: $e");
      }
    }

    return null;
  }

  static Future<List<PointLatLng>> getPolylineRoute(LatLng origin, LatLng destination) async {
    PolylinePoints polylinePoints = PolylinePoints(apiKey: AppConfig.mapKey!);
    // 1. Request route coordinates from Google Directions API
    RoutesApiRequest request = RoutesApiRequest(
        origin: PointLatLng(origin.latitude, origin.longitude),
        destination: PointLatLng(destination.latitude, destination.longitude),
    );

    var response = await polylinePoints.getRouteBetweenCoordinatesV2(
        request: request);

    if (response.routes.isNotEmpty && (response.routes.first.polylinePoints ?? []).isNotEmpty) {

      var data = response.routes.first.polylinePoints ?? [];

      return data;
    }

    return [];
  }

}