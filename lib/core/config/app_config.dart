part of 'config.dart';

class AppConfig {

  String? get mapKey => dotenv.env['MAP_KEY'];
  String? get baseUrl => dotenv.env['BASE_URL'];

}