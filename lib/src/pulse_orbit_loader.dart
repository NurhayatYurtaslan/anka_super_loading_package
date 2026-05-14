import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Three dots whose scale and opacity follow a staggered sine wave.
///
/// Each dot is offset by one third of a period so the pulse travels across
/// the row. [staticOnly] shows all dots at full emphasis without motion.
class PulseOrbitLoader extends StatefulWidget {
  const PulseOrbitLoader({
    super.key,
    required this.color,
    required this.size,
    required this.duration,
    required this.staticOnly,
  });

  /// Dot fill colour.
  final Color color;

  /// Bounding square side in logical pixels.
  final double size;

  /// Duration of one full pulse cycle.
  final Duration duration;

  /// When true, animation stops and dots render at neutral scale/opacity.
  final bool staticOnly;

  @override
  State<PulseOrbitLoader> createState() => _PulseOrbitLoaderState();
}

class _PulseOrbitLoaderState extends State<PulseOrbitLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.staticOnly) {
      _controller.value = 0.0;
    } else {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(PulseOrbitLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    if (widget.staticOnly != oldWidget.staticOnly) {
      if (widget.staticOnly) {
        _controller
          ..stop()
          ..value = 0.0;
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
    final dot = widget.size * 0.18;
    final gap = widget.size * 0.12;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              // Stagger each dot by 1/3 of a period so the wave reads left-to-right.
              final phase = widget.staticOnly ? 0.0 : (_controller.value + i / 3) % 1.0;
              final t = math.sin(phase * math.pi * 2);
              final scale = widget.staticOnly ? 1.0 : 0.55 + 0.45 * ((t + 1) / 2);
              final opacity = widget.staticOnly ? 1.0 : 0.45 + 0.55 * ((t + 1) / 2);
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: gap * 0.5),
                child: Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: opacity.clamp(0.35, 1.0),
                    child: Container(
                      width: dot,
                      height: dot,
                      decoration: BoxDecoration(
                        color: widget.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
