import 'package:flutter/material.dart';

/// Rounded horizontal bar with a travelling shimmer highlight.
class ShimmerBarLoader extends StatefulWidget {
  const ShimmerBarLoader({
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
  State<ShimmerBarLoader> createState() => _ShimmerBarLoaderState();
}

class _ShimmerBarLoaderState extends State<ShimmerBarLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.staticOnly) {
      _controller.value = 0.35;
    } else {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(ShimmerBarLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    if (widget.staticOnly != oldWidget.staticOnly) {
      if (widget.staticOnly) {
        _controller
          ..stop()
          ..value = 0.35;
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
    final barHeight = widget.size * 0.22;
    final barWidth = widget.size * 0.92;
    final radius = BorderRadius.circular(barHeight / 2);
    final base = widget.color.withValues(alpha: 0.28);
    final highlight = widget.color.withValues(alpha: 0.95);

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Center(
        child: ClipRRect(
          borderRadius: radius,
          child: SizedBox(
            width: barWidth,
            height: barHeight,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final t = widget.staticOnly ? 0.35 : _controller.value;
                return CustomPaint(
                  size: Size(barWidth, barHeight),
                  painter: _ShimmerBarPainter(
                    baseColor: base,
                    highlightColor: highlight,
                    highlightT: t,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ShimmerBarPainter extends CustomPainter {
  _ShimmerBarPainter({
    required this.baseColor,
    required this.highlightColor,
    required this.highlightT,
  });

  final Color baseColor;
  final Color highlightColor;
  final double highlightT;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final r = RRect.fromRectAndRadius(rect, Radius.circular(size.height / 2));
    final t = highlightT;
    final gradient = LinearGradient(
      begin: Alignment(-1.1 + 2.2 * t, 0),
      end: Alignment(0.1 + 2.2 * t, 0),
      colors: [
        baseColor,
        highlightColor,
        baseColor,
      ],
      stops: const [0.0, 0.5, 1.0],
    );
    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRRect(r, paint);
  }

  @override
  bool shouldRepaint(covariant _ShimmerBarPainter oldDelegate) =>
      oldDelegate.baseColor != baseColor ||
      oldDelegate.highlightColor != highlightColor ||
      oldDelegate.highlightT != highlightT;
}
