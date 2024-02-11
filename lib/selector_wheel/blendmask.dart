import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// Applies a BlendMode to its child.
class BlendMask extends SingleChildRenderObjectWidget {
  final BlendMode blendMode;
  final double opacity;
  final Rect? intersectionRect;

  const BlendMask({
    required this.blendMode,
    this.opacity = 1.0,
    super.key,
    super.child,
    this.intersectionRect,
  });

  @override
  RenderObject createRenderObject(context) {
    return RenderBlendMask(blendMode, opacity, intersectionRect);
  }

  @override
  void updateRenderObject(BuildContext context, RenderBlendMask renderObject) {
    renderObject.blendMode = blendMode;
    renderObject.opacity = opacity;
  }
}

class RenderBlendMask extends RenderProxyBox {
  BlendMode blendMode;
  double opacity;
  Rect? intersectionRect;

  RenderBlendMask(
    this.blendMode,
    this.opacity,
    this.intersectionRect,
  );

  @override
  void paint(context, offset) {
    // Create a new layer and specify the blend mode and opacity to composite it with:
    context.canvas.saveLayer(
      intersectionRect ?? (offset & size),
      Paint()
        ..blendMode = blendMode
        ..color = Color.fromARGB((opacity * 255).round(), 255, 255, 255),
    );

    super.paint(context, offset);

    // Composite the layer back into the canvas using the blendmode:
    context.canvas.restore();
  }
}
