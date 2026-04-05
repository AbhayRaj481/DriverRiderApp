part of 'config.dart';

class AppConfig {

  static String? get mapKey => dotenv.env['MAP_KEY'];
  static String? get baseUrl => dotenv.env['BASE_URL'];

}