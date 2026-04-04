import 'package:driving_mobile_app/core/di/service_locator.dart';
import 'package:driving_mobile_app/firebase_options.dart'
    show DefaultFirebaseOptions;
import 'package:driving_mobile_app/app.dart';
import 'package:driving_mobile_app/screens/screen_lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await init();

  try{
    await dotenv.load(fileName: ".env");
  }catch(e){
    if (kDebugMode) {
      print("dotenv oad failed.");
    }
  }

  runApp(
    const AppBlocConnector(child: App()),
  );
}
