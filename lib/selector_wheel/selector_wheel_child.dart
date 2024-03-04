import 'package:flutter/material.dart';
import 'package:selector_wheel/selector_wheel/blendmask.dart';
import 'package:selector_wheel/selector_wheel/utils.dart';

class SelectorWheelChild extends StatefulWidget {
  final double width;
  final double height;
  final String value;
  final bool selected;
  final TextStyle? notHighlightedTextStyle;
  final TextStyle? highlightedTextStyle;
  final Rect highlightedWidgetRect;
  final Axis scrollDirection;
  final bool blendMode;
  final BuildContext containerContext;

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
    required this.containerContext,
  });

  @override
  State<SelectorWheelChild> createState() => _SelectorWheelChildState();
}

class _SelectorWheelChildState extends State<SelectorWheelChild> {
  @override
  Widget build(BuildContext context) {
    if (!widget.blendMode) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: Center(
          child: Text(
            widget.value,
            softWrap: false,
            textAlign: TextAlign.center,
            style: widget.selected || widget.notHighlightedTextStyle == null
                ? widget.highlightedTextStyle
                : widget.notHighlightedTextStyle,
          ),
        ),
      );
    }
    final text = Builder(
      builder: (textContext) {
        final rect =
            textContext.globalPaintRect(widget.containerContext) ?? Rect.zero;

        final intersection = widget.highlightedWidgetRect.intersect(rect);

        bool isIntersecting = Axis.horizontal == widget.scrollDirection
            ? intersection.width > 0
            : intersection.height > 0;

        // debugPrint(
        //     "value: ${widget.value} | isIntersecting: $isIntersecting | rect: $rect | highlightedWidgetRect: ${widget.highlightedWidgetRect}");

        return isIntersecting
            ? BlendMask(
                blendMode: BlendMode.difference,
                opacity: 1,
                // intersectionRect: Rect.zero,
                child: Text(
                  widget.value,
                  softWrap: false,
                  textAlign: TextAlign.center,
                  style: widget.highlightedTextStyle,
                ),
              )
            : Text(
                widget.value,
                softWrap: false,
                textAlign: TextAlign.center,
                style: widget.notHighlightedTextStyle,
              );
      },
    );

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Center(
        child: text,
      ),
    );
  }
}
