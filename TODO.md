# Rider Map Screen Task Progress

## Completed
- [x] Created `lib/screens/rider/rider_map_screen.dart` with full functionality:
  - Google Map with current location tracking via LocationTracker.
  - Search TextFields for pickup/destination (mock + map tap + reverse geocode for addresses).
  - Constant draggable bottom sheet showing full addresses.
  - Polyline route generation/markers on destination selection.

## Pending
- [ ] Add GoRouter route for RiderMapScreen (e.g., in `lib/core/route/router.dart` or caller screen).
- [ ] Test in app: Check permissions, map load, search/tap, bottom sheet, route display.
- [ ] Optional: Add flutter_google_places dep for real autocomplete (pubspec + flutter pub get).
- [ ] Optional: Integrate Directions API for real polylines (HTTP + API key).

Run `flutter run` to test. Navigate to RiderMapScreen (temporary: add to existing rider screen or route).
