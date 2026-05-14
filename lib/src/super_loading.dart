import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'loading_style.dart';
import 'pulse_orbit_loader.dart';
import 'ring_stroke_loader.dart';
import 'segment_spinner_loader.dart';
import 'shimmer_bar_loader.dart';
import 'wave_dots_loader.dart';

/// Default side length for loaders when no explicit [size] is passed.
const double kAnkaDefaultLoadingSize = 48.0;

/// Indeterminate loading indicator with five curated visual styles.
///
/// Respects [MediaQuery.disableAnimations] by showing a static frame.
class AnkaSuperLoading extends StatelessWidget {
  /// Creates a loader for [style].
  const AnkaSuperLoading({
    super.key,
    required this.style,
    this.size,
    this.color,
    this.duration,
    this.semanticsLabel,
  });

  /// Which animation preset to render.
  final LoadingStyle style;

  /// Side length of the square loader area. Defaults to [kAnkaDefaultLoadingSize].
  final double? size;

  /// Stroke / dot colour. Defaults to [ColorScheme.primary].
  final Color? color;

  /// One loop duration for the animation (style-dependent interpretation).
  final Duration? duration;

  /// Accessibility label; defaults to "Loading".
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? Theme.of(context).colorScheme.primary;
    final resolvedDuration = duration ?? const Duration(milliseconds: 1400);
    final staticOnly = MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return LayoutBuilder(
      builder: (context, constraints) {
        final requested = size ?? kAnkaDefaultLoadingSize;
        final maxW = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : requested;
        final maxH = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : requested;
        final maxSide = math.max(
          kAnkaDefaultLoadingSize * 0.25,
          math.min(maxW, maxH),
        );
        final side = math.min(requested, maxSide);

        final child = _buildChild(
          style: style,
          color: resolvedColor,
          side: side,
          duration: resolvedDuration,
          staticOnly: staticOnly,
        );

        return Semantics(
          label: semanticsLabel ?? 'Loading',
          container: true,
          child: SizedBox(
            width: side,
            height: side,
            child: Center(child: child),
          ),
        );
      },
    );
  }
}

Widget _buildChild({
  required LoadingStyle style,
  required Color color,
  required double side,
  required Duration duration,
  required bool staticOnly,
}) {
  return switch (style) {
    LoadingStyle.pulseOrbit => PulseOrbitLoader(
        color: color,
        size: side,
        duration: duration,
        staticOnly: staticOnly,
      ),
    LoadingStyle.ringStroke => RingStrokeLoader(
        color: color,
        size: side,
        duration: duration,
        staticOnly: staticOnly,
      ),
    LoadingStyle.shimmerBar => ShimmerBarLoader(
        color: color,
        size: side,
        duration: duration,
        staticOnly: staticOnly,
      ),
    LoadingStyle.segmentSpinner => SegmentSpinnerLoader(
        color: color,
        size: side,
        duration: duration,
        staticOnly: staticOnly,
      ),
    LoadingStyle.waveDots => WaveDotsLoader(
        color: color,
        size: side,
        duration: duration,
        staticOnly: staticOnly,
      ),
  };
}
