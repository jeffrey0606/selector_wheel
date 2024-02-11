import 'package:flutter/material.dart';

class SelectorWheelChild extends StatelessWidget {
  final double width;
  final double height;
  final String value;
  final bool selected;
  final TextStyle? notHighlightedTextStyle;
  final TextStyle? highlightedTextStyle;

  const SelectorWheelChild({
    super.key,
    required this.width,
    required this.height,
    required this.value,
    required this.selected,
    this.notHighlightedTextStyle,
    this.highlightedTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: Text(
          value,
          softWrap: false,
          textAlign: TextAlign.center,
          style: selected || notHighlightedTextStyle == null
              ? highlightedTextStyle
              : notHighlightedTextStyle,
        ),
      ),
    );
  }
}
