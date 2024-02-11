import 'package:flutter/material.dart';

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
  final GlobalKey highlightedWidgetGlobalKey;
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
    required this.highlightedWidgetGlobalKey,
    required this.blendMode,
  }) : super(key: key);

  @override
  State<SelectorWheelWheel<T>> createState() => _SelectorWheelWheelState<T>();
}

class _SelectorWheelWheelState<T> extends State<SelectorWheelWheel<T>> {
  int currentIndex = 0;
  bool isScrolling = false;
  Rect highlightedWidgetRect = Rect.zero;

  Rect getWidgetRect(BuildContext parentBoxContext, BuildContext boxContext) {
    RenderBox box = boxContext.findRenderObject() as RenderBox;
    RenderBox parentBox = parentBoxContext.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(
      Offset.zero,
      // ancestor: parentBox,
    ); //this is global position

    // print("box.size.width: ${box.size.width}");

    return (position & box.size);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        if (widget.selectedItemIndex != null) {
          currentIndex = widget.selectedItemIndex!;
        }
        highlightedWidgetRect = getWidgetRect(
          context,
          widget.highlightedWidgetGlobalKey.currentContext!,
        );
        print("highlightedWidgetRect: $highlightedWidgetRect");
      });
    });

    super.initState();
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
