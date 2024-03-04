import 'package:flutter/material.dart';

class SelectorWheelHighlight extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadiusGeometry borderRadius;
  final void Function(BuildContext context) onContext;

  const SelectorWheelHighlight({
    Key? key,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.onContext,
  }) : super(key: key);

  @override
  State<SelectorWheelHighlight> createState() => _SelectorWheelHighlightState();
}

class _SelectorWheelHighlightState extends State<SelectorWheelHighlight> {
  @override
  void initState() {
    widget.onContext(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Container(
          width: widget.width,
          height: widget.width,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: widget.borderRadius,
          ),
        ),
      ),
    );
  }
}
