import 'dart:async';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driving_mobile_app/core/core_lib.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

// Declare Part's Here
part 'maps/navigation_map.dart';
part 'builders/custom_value_listanble_builder.dart';
part 'builders/firebase_stream_builder.dart';
part 'builders/firestore_stream_builder.dart';
part 'builders/socket_stream_builder.dart';