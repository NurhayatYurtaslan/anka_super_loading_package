# Loading animations package — technical analysis

This document analyses how to implement **five distinct loading animation styles** in the `anka_super_loading_package` Flutter package, and how the **example application** should present them for review, QA, and integration reference.

---

## 1. Objectives

| Goal | Description |
|------|-------------|
| **Reusable widgets** | Consumers embed loaders without copying animation code. |
| **Five fixed styles** | A small, curated set with predictable behaviour and visual identity. |
| **Consistent API** | Same constructor knobs (size, colour, semantics) across styles where possible. |
| **Example as living spec** | The example app documents usage and edge cases (theme, layout, accessibility). |

**Non-goals (initial scope)**

- Lottie or Rive assets (pure Flutter `AnimationController` / implicit animations).
- Infinite arbitrary presets from JSON.
- Platform-native progress APIs (e.g. `CupertinoActivityIndicator` as the only implementation).

---

## 2. Proposed loading styles

Each style should be visually distinct and map to a stable **enum** or sealed type in the package API.

| # | Style id | Concept | Implementation sketch |
|---|----------|---------|------------------------|
| 1 | `pulseOrbit` | Three dots orbiting or pulsing in sequence | `TweenAnimationBuilder` or single `AnimationController` driving opacity/scale offsets per dot. |
| 2 | `ringStroke` | Indeterminate circular stroke (arc sweeping) | `CustomPainter` + rotation; stroke caps round; `RepaintBoundary` optional. |
| 3 | `shimmerBar` | Horizontal bar with travelling highlight | `ShaderMask` or gradient `Animation` on a rounded `Container`; respects `BorderRadius`. |
| 4 | `segmentSpinner` | Multiple short arcs rotating at staggered phases | Several arcs on one painter or stacked `Transform.rotate`. |
| 5 | `waveDots` | Row of dots with vertical wave (sine phase per dot) | `Transform.translate` per dot; one controller, phase = `index * delta`. |

Naming in code can differ (e.g. `LoadingStyle.pulseOrbit`) but the **five concepts** above should remain stable for docs and changelog.

---

## 3. Package design

### 3.1 Public surface

Recommended exports from `lib/anka_super_loading_package.dart`:

- **`LoadingStyle`** — enum (or enhanced enum with display metadata) listing the five styles.
- **`AnkaSuperLoading`** (or `SuperLoading`) — primary widget:
  - Required: `style: LoadingStyle`
  - Optional: `double? size`, `Color? color`, `Duration? duration`, `String? semanticsLabel`
- **Style-specific widgets** (optional but useful for tree-shaking and explicit imports):
  - e.g. `PulseOrbitLoader`, `RingStrokeLoader`, … wrapping shared internals.

### 3.2 Layout contract

- Each loader should honour the **constraints** of its parent: default to a square box whose side is `min(constraints.maxWidth, constraints.maxHeight, size ?? 48)` when unconstrained in one axis is ambiguous; document a **minimum touch target** of 48 logical pixels when used as the only interactive feedback.
- Loaders are **non-interactive** (`IgnorePointer` not required unless overlapping tappable areas); use `Semantics` for screen readers (`progressBarIndeterminate` or `loading`).

### 3.3 Theming

- Default `color` should resolve from `Theme.of(context).colorScheme.primary` when `color` is null.
- `size` default: `48.0` (documented constant).
- Animations should respect **`AnimationStyle`** / reduced motion when available (Flutter 3.16+): if `MediaQuery.disableAnimations` is true, show a static frame (e.g. solid ring or middle dot) instead of looping.

### 3.4 Suggested `lib/` layout

```
lib/
  anka_super_loading_package.dart   # barrel export
  src/
    loading_style.dart              # enum + docs
    super_loading.dart              # dispatcher widget
    pulse_orbit_loader.dart
    ring_stroke_loader.dart
    shimmer_bar_loader.dart
    segment_spinner_loader.dart
    wave_dots_loader.dart
    internal/
      animation_ticks.dart          # shared vsync/ticker helpers if needed
```

Keep `src/` for implementation privacy; export only the barrel and any intentionally public sub-widgets.

### 3.5 Lifecycle and performance

- One `AnimationController` per loader instance; `dispose` in `State`.
- Prefer **`RepaintBoundary`** only if profiling shows repaint bleeding into large parents.
- Avoid rebuilding the whole page: loaders update only their subtree.

### 3.6 Testing (package)

- **Golden tests** per style (fixed frame at t=0, t=0.5) optional but valuable.
- **Smoke test**: pump each style, assert semantics and no exceptions over several frames.

---

## 4. Example application design

The example app (`example/`) should act as a **showcase**, not a second product. In this repository the example is limited to **Android**, **iOS**, and **Web** platform folders (desktop runners are intentionally omitted).

### 4.1 Information architecture

| Screen / section | Purpose |
|------------------|---------|
| **Home / gallery** | List or grid of the five styles with title and short description; tap navigates to detail. |
| **Detail page per style** | Large live preview, code snippet (static string or reference to README), controls for **size**, **colour**, **speed** (scale duration). |
| **Light / dark toggle** | `ThemeMode` switch in the `AppBar` or drawer to verify contrast on `colorScheme` defaults. |
| **Layout sandbox** (optional) | `Align`, tight `SizedBox`, and `Expanded` cases to validate constraint behaviour. |

### 4.2 UX details

- Use **English** copy in the example UI (aligned with package docs language).
- Show **package version** from `package_info_plus` only if you add the dependency; otherwise a static `0.0.1` line in `About` is enough for early phase.
- **Safe area** and `AppBar` title: e.g. `anka_super_loading_package example`.

### 4.3 Example `main.dart` structure (conceptual)

- `MaterialApp` with `theme` / `darkTheme` / `themeMode`.
- `HomePage`: `ListView` of `ListTile` / `Card` entries, one per `LoadingStyle`.
- `StyleDemoPage(style)`: `Column` with preview `Center(child: AnkaSuperLoading(style: style, size: _size, color: _color))` and `Slider` / `ColorPicker` or preset colour chips.

### 4.4 Example dependencies

- Path dependency on the root package (already standard for Flutter packages).
- No need for extra animation packages if core APIs suffice.

---

## 5. Documentation and repo hygiene

| Artifact | Role |
|----------|------|
| **`doc/analysis.md`** (this file) | Architecture and product decisions before/during implementation. |
| **`README.md`** (root) | Quick start, GIFs or static images of five loaders, API table. |
| **`CHANGELOG.md`** | Follow Keep a Changelog when releasing. |

Consider linking `README.md` to `doc/analysis.md` for contributors.

---

## 6. Implementation order (recommended)

1. Add `LoadingStyle` enum and `AnkaSuperLoading` shell that switches on style (placeholder `SizedBox` per style).
2. Implement **ring** and **pulse dots** first (most familiar patterns).
3. Add **wave dots** and **segment spinner** (shared math for phases).
4. Add **shimmer bar** (gradient + clipping edge cases).
5. Wire example gallery + detail; capture screenshots for README.

---

## 7. Risks and mitigations

| Risk | Mitigation |
|------|------------|
| Janky frames on low-end devices | Cap animation complexity; use `const` where possible; profile with Impeller/Skia. |
| Shimmer clipping on RTL | Test `Directionality`; mirror gradient or document LTR-only. |
| API churn | Keep enum values stable; mark experimental APIs in doc comments until 1.0. |

---

## 8. Summary

The package should expose a **single entry widget** driven by **`LoadingStyle`** with five concrete implementations under `lib/src/`. The example app should provide a **gallery**, **per-style detail** with tunable parameters, and **light/dark** validation. This split keeps the package lean while the example remains the authoritative visual and integration reference.
