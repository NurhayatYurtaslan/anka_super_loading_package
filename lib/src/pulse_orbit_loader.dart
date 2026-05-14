import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Three dots with staggered scale / emphasis.
class PulseOrbitLoader extends StatefulWidget {
  const PulseOrbitLoader({
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
