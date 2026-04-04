part of '../../core_lib.dart';


class CustomMaterialButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final TextStyle? textStyle;
  const CustomMaterialButton({
    super.key,
    required this.text ,
    this.onPressed,
    this.color,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {

    bool isActive = (onPressed!= null);
    return MaterialButton(
        onPressed: onPressed,
        color: color ?? AppColors.black.withValues(alpha: .8),
        shape: RoundedRectangleBorder(
          borderRadius: AppStyles.borderRadius_1
        ),
        child: Center(
            child: Text(
              text,
              style: textStyle ?? AppStyles.buttonPrimaryTextStyle.copyWith(
                color: isActive ? AppColors.white : AppColors.black,
              ),
            )
        ),
    );
  }
}
