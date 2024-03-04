import 'package:flutter/material.dart';
import 'package:selector_wheel/selector_wheel/utils.dart';

import 'models/selector_wheel_value.dart';
import 'selector_wheel_child.dart';
import 'selector_wheel_fixed_extent_scroll_physics.dart';

class SelectorWheelWheel<T> extends StatefulWidget {
  final double width;
  final double height;
  final int? childCount;
  final FixedExtentScrollController controller;
  final SelectorWheelValue<T> Function(int index) convertIndexToValue;
  final void Function(SelectorWheelValue<T> value) onValueChanged;
  final double? perspective;
  final double? diameterRatio;
  final int? selectedItemIndex;
  final TextStyle? notHighlightedTextStyle;
  final TextStyle? highlightedTextStyle;
  final Axis scrollDirection;
  final BuildContext containerContext;
  final BuildContext? highlightedWidgetContext;
  final bool blendMode;

  const SelectorWheelWheel({
    Key? key,
    required this.width,
    required this.height,
    required this.childCount,
    required this.controller,
    required this.convertIndexToValue,
    required this.onValueChanged,
    this.perspective,
    this.diameterRatio,
    this.selectedItemIndex,
    this.notHighlightedTextStyle,
    this.highlightedTextStyle,
    required this.scrollDirection,
    required this.containerContext,
    required this.blendMode,
    required this.highlightedWidgetContext,
  }) : super(key: key);

  @override
  State<SelectorWheelWheel<T>> createState() => _SelectorWheelWheelState<T>();
}

class _SelectorWheelWheelState<T> extends State<SelectorWheelWheel<T>> {
  int currentIndex = 0;
  bool isScrolling = false;
  Rect highlightedWidgetRect = Rect.zero;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        if (widget.selectedItemIndex != null) {
          currentIndex = widget.selectedItemIndex!;
        }
        if (widget.highlightedWidgetContext != null) {
          highlightedWidgetRect = widget.highlightedWidgetContext!
                  .globalPaintRect(widget.containerContext) ??
              Rect.zero;
        }
      });

      widget.onValueChanged(
          widget.convertIndexToValue(widget.controller.selectedItem));
    });

    super.initState();
  }

  @override
  void didUpdateWidget(covariant SelectorWheelWheel<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.highlightedWidgetContext != null &&
        widget.highlightedWidgetContext != oldWidget.highlightedWidgetContext) {
      highlightedWidgetRect = widget.highlightedWidgetContext!
              .globalPaintRect(widget.containerContext) ??
          Rect.zero;
    }
    if (widget.childCount != oldWidget.childCount) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          // isScrolling = false;
          currentIndex = widget.controller.selectedItem;
        });

        widget.onValueChanged(widget.convertIndexToValue(currentIndex));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      color: Colors.transparent,
      child: NotificationListener(
        onNotification: (notification) {
          if (notification is ScrollEndNotification) {
            final index = widget.controller.selectedItem;

            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {
                // isScrolling = false;
                currentIndex = index;
              });
            });

            widget.onValueChanged(widget.convertIndexToValue(index));
          } else if (notification is ScrollUpdateNotification &&
              widget.blendMode) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {
                isScrolling = true;
              });
            });
          }

          return false;
        },
        child: ListWheelScrollView.useDelegate(
          controller: widget.controller,
          itemExtent: widget.height,
          perspective: widget.perspective ?? 0.009,
          diameterRatio: widget.diameterRatio ?? 2.0,
          physics: const SelectorWheelFixedExtentScrollPhysics(),
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: widget.childCount,
            builder: (context, index) {
              return RotatedBox(
                quarterTurns: widget.scrollDirection == Axis.horizontal ? 1 : 0,
                child: SelectorWheelChild(
                  width: widget.width,
                  height: widget.height,
                  selected: index == currentIndex,
                  value: widget.convertIndexToValue(index).label,
                  notHighlightedTextStyle: widget.notHighlightedTextStyle,
                  highlightedTextStyle: widget.highlightedTextStyle,
                  highlightedWidgetRect: highlightedWidgetRect,
                  scrollDirection: widget.scrollDirection,
                  blendMode: widget.blendMode,
                  containerContext: widget.containerContext,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
