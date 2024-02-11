import 'package:flutter/material.dart';
import 'package:selector_wheel/selector_wheel/blendmask.dart';

class SelectorWheelChild extends StatelessWidget {
  final double width;
  final double height;
  final String value;
  final bool selected;
  final TextStyle? notHighlightedTextStyle;
  final TextStyle? highlightedTextStyle;
  final Rect highlightedWidgetRect;
  final Axis scrollDirection;
  final bool blendMode;

  const SelectorWheelChild({
    super.key,
    required this.width,
    required this.height,
    required this.value,
    required this.selected,
    this.notHighlightedTextStyle,
    this.highlightedTextStyle,
    required this.highlightedWidgetRect,
    required this.scrollDirection,
    required this.blendMode,
  });

  Rect? getWidgetRect(BuildContext boxContext) {
    RenderBox? box = boxContext.findRenderObject() as RenderBox?;

    if (box == null) {
      return null;
    }
    Offset position = box.localToGlobal(
      Offset.zero,
      // ancestor: parentBox,
    ); //this is global position

    // print("box.size.width: ${box.size.width}");

    return (position & box.size);
  }

  @override
  Widget build(BuildContext context) {
    if (!blendMode) {
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
    final text = Builder(builder: (textContext) {
      final rect = getWidgetRect(textContext) ?? Rect.zero;
      // if (selected) {
      //   print(
      //       "highlightedWidgetRect: dx: ${highlightedWidgetRect.left.ceil()} | dy: ${highlightedWidgetRect.top.ceil()} | width: ${highlightedWidgetRect.width} | height: ${highlightedWidgetRect.height}");

      //   print(
      //       "rect: width: dx: ${rect.left.ceil()} | dy: ${rect.top.ceil()}  width: ${rect.width} | height: ${rect.height}");
      // }

      final intersection = highlightedWidgetRect.intersect(rect);
      // if (selected) {
      //   print(
      //       "intersection width: ${intersection.width.ceil()} | height: ${intersection.height.ceil()}");
      // }

      bool isIntersecting = Axis.horizontal == scrollDirection
          ? intersection.width > 0
          : intersection.height > 0;

      return isIntersecting
          ? BlendMask(
              blendMode: BlendMode.difference,
              opacity: 1,
              // intersectionRect: Rect.zero,
              child: Text(
                value,
                softWrap: false,
                textAlign: TextAlign.center,
                style: highlightedTextStyle,
              ),
            )
          : Text(
              value,
              softWrap: false,
              textAlign: TextAlign.center,
              style: notHighlightedTextStyle,
            );
    });

    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: text,
      ),
    );
  }
}
