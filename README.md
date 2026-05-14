# anka_super_loading_package

Five curated **indeterminate** loading animations for Flutter behind one small API: pick a [`LoadingStyle`](lib/src/loading_style.dart) and drop in [`AnkaSuperLoading`](lib/src/super_loading.dart).

| Style | Description |
|--------|-------------|
| `pulseOrbit` | Three dots pulsing in sequence. |
| `ringStroke` | Sweeping arc on a circular ring. |
| `shimmerBar` | Rounded bar with a travelling highlight. |
| `segmentSpinner` | Short arc segments rotating with staggered phase. |
| `waveDots` | Dots moving vertically in a wave pattern. |

Design notes and roadmap live in [doc/analysis.md](doc/analysis.md).

## Install

```yaml
dependencies:
  anka_super_loading_package: ^0.1.1
```

```bash
dart pub add anka_super_loading_package
```

## Usage

```dart
import 'package:anka_super_loading_package/anka_super_loading_package.dart';

AnkaSuperLoading(
  style: LoadingStyle.ringStroke,
  size: 64,
  color: Theme.of(context).colorScheme.primary,
  duration: const Duration(milliseconds: 1400),
  semanticsLabel: 'Loading data',
);
```

When `color` is omitted, loaders use `Theme.of(context).colorScheme.primary`. When `size` is omitted, the default side length is `48` (`kAnkaDefaultLoadingSize`). If `MediaQuery.disableAnimations` is true, each style shows a static frame instead of animating.

## Example

Run the bundled gallery from the repository root:

```bash
cd example
flutter run
```

The example lists every style, supports **light / dark / system** theme from the app bar, and opens a detail screen with sliders for size and loop duration plus colour presets.

## Contributing

Issues and pull requests are welcome on [GitHub](https://github.com/NurhayatYurtaslan/anka_super_loading_package).

## Screenshots

_Add GIFs or static images of the five loaders here after you capture them from the example app._
