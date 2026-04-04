part of 'utils.dart';


extension ContextExtension on BuildContext {

  double getTopNotchHeight() => MediaQuery.of(this).padding.top;
  double getBottomNotchHeight() => kBottomNavigationBarHeight + MediaQuery.of(this).padding.bottom;

  double get deviceHeight => MediaQuery.of(this).size.height;
}