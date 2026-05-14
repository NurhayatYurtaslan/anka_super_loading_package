import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Three short arcs on one ring, each rotated by 120° plus a shared spin.
///
/// [_SegmentSpinnerPainter] draws all segments in one pass. [staticOnly]
/// pins [progress] so the icon reads as idle while remaining recognizable.
class SegmentSpinnerLoader extends StatefulWidget {
  const SegmentSpinnerLoader({
    super.key,
    required this.color,
    required this.size,
    required this.duration,
    required this.staticOnly,
  });

  /// Stroke colour for every arc segment.
  final Color color;

  /// Bounding square side in logical pixels.
  final double size;

  /// Duration of one full rotation cycle of the combined pattern.
  final Duration duration;

  /// When true, the spinner stops at a fixed [progress] value.
  final bool staticOnly;

  @override
  State<SegmentSpinnerLoader> createState() => _SegmentSpinnerLoaderState();
}

class _SegmentSpinnerLoaderState extends State<SegmentSpinnerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.staticOnly) {
      _controller.value = 0.2;
    } else {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(SegmentSpinnerLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    if (widget.staticOnly != oldWidget.staticOnly) {
      if (widget.staticOnly) {
        _controller
          ..stop()
          ..value = 0.2;
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.square(widget.size),
          painter: _SegmentSpinnerPainter(
            color: widget.color,
            progress: widget.staticOnly ? 0.2 : _controller.value,
          ),
        );
      },
    );
  }
}

/// Draws three equal arc segments around [center] with shared [progress].
class _SegmentSpinnerPainter extends CustomPainter {
  _SegmentSpinnerPainter({
    required this.color,
    required this.progress,
  });

  final Color color;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.shortestSide * 0.08;
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - stroke / 2;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    const arcSweep = math.pi / 3;
    for (var i = 0; i < 3; i++) {
      // Evenly space segments around the circle, then spin the whole set.
      final base = (i * 2 * math.pi / 3) + progress * 2 * math.pi * 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        base,
        arcSweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SegmentSpinnerPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.progress != progress;
}
