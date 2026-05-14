import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Five dots translated on Y by a sine wave with per-index phase offset.
///
/// Dot size and padding are tuned so the row fits a square [size] without
/// horizontal overflow in tight layouts. [staticOnly] freezes a mid-wave pose.
class WaveDotsLoader extends StatefulWidget {
  const WaveDotsLoader({
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

  /// Duration of one vertical oscillation cycle (shared phase driver).
  final Duration duration;

  /// When true, dots stop moving and show a fixed wave snapshot.
  final bool staticOnly;

  @override
  State<WaveDotsLoader> createState() => _WaveDotsLoaderState();
}

class _WaveDotsLoaderState extends State<WaveDotsLoader>
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
  void didUpdateWidget(WaveDotsLoader oldWidget) {
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
    // Five dots balance density and fitting inside [size] with narrow padding.
    const count = 5;
    final dot = widget.size * 0.11;
    final amplitude = widget.size * 0.14;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(count, (i) {
              final phase = widget.staticOnly
                  ? i * 0.4
                  : _controller.value * 2 * math.pi + i * 0.65;
              final dy = widget.staticOnly
                  ? amplitude * 0.5 * math.sin(i * 0.65)
                  : amplitude * math.sin(phase);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Transform.translate(
                  offset: Offset(0, dy),
                  child: Container(
                    width: dot,
                    height: dot,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
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
