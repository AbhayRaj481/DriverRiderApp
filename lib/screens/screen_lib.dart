library;
// Declare imports
import 'dart:async';
import 'dart:math' as math;

import 'package:driving_mobile_app/core/core_lib.dart';
import 'package:driving_mobile_app/core/di/service_locator.dart';
import 'package:driving_mobile_app/core/widgets/widgets_lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:driving_mobile_app/blocs/bloc_lib.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pinput/pinput.dart';
// Declare part below
part './splash/splash_screen.dart';
part './home/home_screen.dart';
part './login/login_screen.dart';
part './register/signup_screen.dart';
part './navigation_map/driver_navigation_map_screen.dart';
part 'app_bloc_connector.dart';

part 'auth/otp_verification_screen.dart';
part 'auth/phone_number_screen.dart';
part 'rider/rider_map_screen.dart';