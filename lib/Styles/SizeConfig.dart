import 'dart:io';

import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }

  // Get the proportionate height as per screen size
  static double getProportionateScreenHeight(double inputHeight) {
    double screenHeight = SizeConfig.screenHeight;

    if (Platform.isIOS || Platform.isAndroid)
      return (inputHeight / 896) * screenHeight;
    else
      return (inputHeight / 1080) * screenHeight;
  }

// Get the proportionate height as per screen sizes
  static double getProportionateScreenWidth(double inputWidth) {
    double screenWidth = SizeConfig.screenWidth;

    if (Platform.isIOS || Platform.isAndroid)
      return (inputWidth / 414) * screenWidth;
    else
      return (inputWidth / 1920) * screenWidth;
  }
}
