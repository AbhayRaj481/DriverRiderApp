part of 'utils.dart';



class CommonUtilsManager {

  static Future<Position?> getAddress(LatLng coordinate){

    return Geolocator.getLastKnownPosition(forceAndroidLocationManager: true);
  }

}