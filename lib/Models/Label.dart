import 'package:flutter/material.dart';

class Label {
  final Color colorLabel;
  final String labelName;

  Label({this.colorLabel, this.labelName});

  Label copyWith({
    String labelName,
    Color colorLabel,
  }) {
    return Label(
        colorLabel: colorLabel ?? this.colorLabel,
        labelName: labelName ?? this.labelName);
  }
}
