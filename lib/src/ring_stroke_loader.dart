import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Indeterminate ring: sweeping arc on a circle.
class RingStrokeLoader extends StatefulWidget {
  const RingStrokeLoader({
    super.key,
    required this.color,
    required this.size,
    required this.duration,
    required this.staticOnly,
  });

  final Color color;
  final double size;
  final Duration duration;
  final bool staticOnly;

  @override
  State<RingStrokeLoader> createState() => _RingStrokeLoaderState();
}

class _RingStrokeLoaderState extends State<RingStrokeLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.staticOnly) {
      _controller.value = 0.25;
    } else {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(RingStrokeLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    if (widget.staticOnly != oldWidget.staticOnly) {
      if (widget.staticOnly) {
        _controller
          ..stop()
          ..value = 0.25;
      } else {
        _controller.repeat();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: Size.square(widget.size),
            painter: _RingStrokePainter(
              color: widget.color,
              rotation: widget.staticOnly ? 0.8 : _controller.value * 2 * math.pi * 2,
            ),
          );
        },
      ),
    );
  }
}

class _RingStrokePainter extends CustomPainter {
  _RingStrokePainter({
    required this.color,
    required this.rotation,
  });

  final Color color;
  final double rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.shortestSide * 0.09;
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - stroke / 2;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    const sweep = 1.35;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      rotation,
      sweep,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingStrokePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.rotation != rotation;
}
