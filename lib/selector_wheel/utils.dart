import 'package:flutter/material.dart';

extension GlobalKeyExtension on BuildContext {
  Rect? globalPaintRect(BuildContext? parentContext) {
    final renderObject = findRenderObject();
    final parentRenderObject = parentContext?.findRenderObject();
    final matrix = renderObject?.getTransformTo(parentRenderObject);

    if (matrix != null && renderObject?.paintBounds != null) {
      final rect = MatrixUtils.transformRect(matrix, renderObject!.paintBounds);
      return rect;
    } else {
      return null;
    }
  }
}
