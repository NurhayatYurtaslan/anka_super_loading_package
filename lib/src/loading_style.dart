/// Visual presets for [AnkaSuperLoading].
///
/// Each value maps to a dedicated implementation in `lib/src/`. Enum names
/// are stable public API; avoid renaming without a major version bump.
enum LoadingStyle {
  /// Three dots with a sequential pulse / scale wave.
  pulseOrbit,

  /// Indeterminate circular stroke with a sweeping arc.
  ringStroke,

  /// Rounded bar with a travelling highlight (shimmer).
  shimmerBar,

  /// Several short arcs rotating with staggered phase.
  segmentSpinner,

  /// A row of dots oscillating vertically in a wave pattern.
  waveDots,
}
