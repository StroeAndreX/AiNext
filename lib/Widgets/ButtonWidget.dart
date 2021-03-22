import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  /// [Action Parameter]
  final GestureTapCallback onPressed;

  /// [Design Parameters]
  final Widget child;
  final EdgeInsets contentPadding;
  final EdgeInsets margin;
  final double width;
  final double height;

  //Colors
  final Color color;
  final Gradient gradient;
  final Color splashColor;
  final Color highlightColor;

  //Shadow control
  final List<BoxShadow> boxShadows;

  //Border
  final BorderStyle borderStyle;
  final BorderSide borderSide;
  final BorderRadius borderRadius;

  /// [Constructor]
  const ButtonWidget({
    Key key,
    @required this.onPressed,
    this.gradient,
    this.width,
    this.height,
    this.child,
    this.boxShadows,
    this.contentPadding,
    this.color,
    this.splashColor,
    this.highlightColor,
    this.borderStyle,
    this.borderSide,
    this.borderRadius,
    this.margin,
  }) : super(key: key);

  /// [Builder // Returned Widget]
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ColorsConfig().init(context);

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Container(
        width: this.width,
        height: this.height,
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(12),
        ),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
            side: this.borderSide ?? BorderSide.none,
          ),
          clipBehavior: Clip.none,
          color: gradient == null
              ? (color ?? ColorsConfig.primary)
              : Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black87, width: 2.5),
              borderRadius: borderRadius ?? BorderRadius.circular(12),
              gradient: gradient,
            ),
            child: InkWell(
              onTap: onPressed,
              child: Container(
                padding: contentPadding ??
                    EdgeInsets.symmetric(
                        vertical: SizeConfig.getProportionateScreenHeight(12),
                        horizontal: SizeConfig.getProportionateScreenWidth(15)),
                alignment: Alignment.center,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
