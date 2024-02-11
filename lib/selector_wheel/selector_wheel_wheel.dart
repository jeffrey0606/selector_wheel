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

  const SelectorWheelWheel(
      {Key? key,
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
      this.highlightedTextStyle})
      : super(key: key);

  @override
  State<SelectorWheelWheel<T>> createState() => _SelectorWheelWheelState<T>();
}

class _SelectorWheelWheelState<T> extends State<SelectorWheelWheel<T>> {
  int currentIndex = 0;

  @override
  void initState() {
    if (widget.selectedItemIndex != null) {
      currentIndex = widget.selectedItemIndex!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: NotificationListener(
        onNotification: (notification) {
          if (notification is ScrollEndNotification) {
            final index = widget.controller.selectedItem;

            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {
                currentIndex = index;
              });
            });

            widget.onValueChanged(widget.convertIndexToValue(index));
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
              return SelectorWheelChild(
                width: widget.width,
                height: widget.height,
                selected: index == currentIndex,
                value: widget.convertIndexToValue(index).label,
                notHighlightedTextStyle: widget.notHighlightedTextStyle,
                highlightedTextStyle: widget.highlightedTextStyle,
              );
            },
          ),
        ),
      ),
    );
  }
}
