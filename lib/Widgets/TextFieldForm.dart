import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldWidget extends StatelessWidget {
  /// [Input and Validator Parameter]
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String Function(String) validator;

  /// [Design Parameters]
  final EdgeInsets contentPadding;
  final double borderRadius;
  final double shadowValue;
  final Color backgroundColor;
  final InputBorder inputBorder;

  //Text Style
  final TextAlign textAlign;
  final TextStyle textStyle;
  final bool obscureText;

  /// [Structure and Utilities]
  final String hintText;
  final TextInputType keyboardType;
  final int maxLines;
  final String prefixText;
  final Widget prefixIcon;
  final Widget suffix;
  final Widget suffixIcon;
  final int maxLength;
  final FocusNode focusNode;
  final double letterSpacing;
  final int errorMaxLinex;
  final String counterText;
  final String value;
  final bool enabled;
  final bool autocorrent;
  final bool enableSuggestions;
  final List<TextInputFormatter> inputFormatters;

  /// [Constructor]
  const TextFormFieldWidget({
    Key key,
    this.controller,
    this.obscureText = false,
    this.onChanged,
    this.contentPadding,
    this.borderRadius,
    this.textAlign,
    this.textStyle,
    this.hintText,
    this.shadowValue,
    this.validator,
    this.keyboardType,
    this.maxLines,
    this.prefixText,
    this.prefixIcon,
    this.suffix,
    this.maxLength,
    this.focusNode,
    this.letterSpacing,
    this.suffixIcon,
    this.backgroundColor,
    this.inputBorder,
    this.errorMaxLinex,
    this.counterText,
    this.value,
    this.enabled = true,
    this.autocorrent = true,
    this.inputFormatters,
    this.enableSuggestions = true,
  }) : super(key: key);

  /// [Builder // Returned Widget]
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ColorsConfig().init(context);

    return TextFormField(
      autocorrect: this.autocorrent,
      enableSuggestions: this.enableSuggestions,
      initialValue: this.value,
      controller: this.controller,
      onChanged: this.onChanged,
      obscureText: this.obscureText,
      enabled: this.enabled,
      inputFormatters: inputFormatters,
      textAlign: this.textAlign ?? TextAlign.start,
      style: this.textStyle ??
          TextStyle(
            color: enabled
                ? ColorsConfig.primaryText
                : ColorsConfig.darkerSecondaryText,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: this.letterSpacing,
          ),
      cursorColor: ColorsConfig.primary,
      validator: this.validator,
      focusNode: this.focusNode,
      keyboardType: this.keyboardType ?? TextInputType.text,
      maxLines: this.maxLines ??
          (this.keyboardType == TextInputType.multiline ? null : 1),
      maxLength: this.maxLength,
      decoration: InputDecoration(
        border: inputBorder == null
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 12),
                borderSide: BorderSide.none,
              )
            : inputBorder,
        enabledBorder: inputBorder ?? null,
        errorBorder: inputBorder != null
            ? inputBorder.copyWith(
                borderSide: BorderSide(color: ColorsConfig.error))
            : null,
        focusedBorder: inputBorder != null
            ? inputBorder.copyWith(
                borderSide: BorderSide(color: ColorsConfig.textFieldBorder))
            : null,
        filled: true,
        fillColor: enabled
            ? (backgroundColor ?? ColorsConfig.inputBackground)
            : ColorsConfig.white,
        hintText: this.hintText,
        hintStyle: TextStyle(color: ColorsConfig.secondaryText),
        contentPadding: this.contentPadding ??
            EdgeInsets.symmetric(
                vertical: SizeConfig.getProportionateScreenHeight(20),
                horizontal: SizeConfig.getProportionateScreenWidth(15)),
        prefixIcon: this.prefixIcon ?? null,
        prefixText: this.prefixText ?? null,
        suffix: this.suffix ?? null,
        suffixIcon: this.suffixIcon ?? null,
        errorMaxLines: this.errorMaxLinex,
        counterText: counterText,
        errorStyle: TextStyle(color: ColorsConfig.error, fontSize: 14),
      ),
    );
  }
}
