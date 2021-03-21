import 'package:flutter/material.dart';

enum ColorTheme { bright, dark }

class ColorsConfig {
  final ColorTheme colorTheme;

  const ColorsConfig(
      {this.colorTheme = ColorTheme
          .bright /* store.state.theme.bool or similar*/}); //TODO: Manage the theme with the state

  static Color background;
  static Color primary;
  static Color primaryLight;
  static Color primaryText;
  static Color textFieldBorder;

  static Color yellowLabel;
  static Color redLabel;
  static Color orangeLabel;
  static Color cyanLabel;
  static Color purpleLabel;
  static Color blueLabel;
  static Color pinkLabel;

  static List<Color> colorLabels;

  void init(BuildContext context) {
    (colorTheme == ColorTheme.bright) ? brightThemeInit() : darkThemeInit();
  }

  /// [Init Colors for White Theme]
  void brightThemeInit() {
    background = const Color(0xFFFAFAFB);
    primary = const Color(0xFF4D4683);
    primaryLight = const Color(0xFF4D4683).withOpacity(0.55);
    primaryText = const Color(0xFF070707);
    textFieldBorder = const Color(0xFF707070);

    yellowLabel = const Color(0xFFFFCA69);
    redLabel = const Color(0xFFF37070);
    orangeLabel = const Color(0xFFFF9D69);
    cyanLabel = const Color(0xFF59C7C1);
    purpleLabel = const Color(0xFF7781CA);
    blueLabel = const Color(0xFF0095F5);
    pinkLabel = const Color(0xFFFAB3D1);

    createListOfColors();
  }

  void createListOfColors() {
    colorLabels = [];

    colorLabels.add(yellowLabel);
    colorLabels.add(redLabel);
    colorLabels.add(orangeLabel);
    colorLabels.add(cyanLabel);
    colorLabels.add(purpleLabel);
    colorLabels.add(blueLabel);
    colorLabels.add(pinkLabel);
  }

  /// [Init Colors for Dark Theme]
  void darkThemeInit() {}
}
