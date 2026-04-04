part of 'utils.dart';



class AppStyles {

  // Box Styles e.g. -> decoration, radius etc
  static double get smRadius => 8;
  static double get mdRadius => 16;
  static double get lgRadius => 21;

  // Border Radius
  static BorderRadius get borderRadius_1 => BorderRadius.all(
      Radius.circular(AppStyles.smRadius)
  );

  // Text Style
  static TextStyle get buttonPrimaryTextStyle => TextStyle(
    color: AppColors.black,
    fontSize: 18
  );
}