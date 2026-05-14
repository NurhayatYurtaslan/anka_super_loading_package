import 'package:anka_super_loading_package/anka_super_loading_package.dart';
import 'package:flutter/material.dart';

/// Sample app for **anka_super_loading_package**: gallery, detail playground, and theme QA.
///
/// Not published to pub.dev; it exists to validate loaders under light/dark
/// themes and different [AnkaSuperLoading] parameters.
void main() {
  runApp(const ExampleApp());
}

/// Root widget: hosts [MaterialApp] and forwards theme controls to [GalleryPage].
class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  ThemeMode _themeMode = ThemeMode.system;

  /// Rotates [ThemeMode] for the app bar brightness control.
  void _cycleTheme() {
    setState(() {
      _themeMode = switch (_themeMode) {
        ThemeMode.system => ThemeMode.light,
        ThemeMode.light => ThemeMode.dark,
        ThemeMode.dark => ThemeMode.system,
      };
    });
  }

  String get _themeLabel => switch (_themeMode) {
        ThemeMode.system => 'System theme',
        ThemeMode.light => 'Light theme',
        ThemeMode.dark => 'Dark theme',
      };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'anka_super_loading_package example',
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: GalleryPage(
        themeModeLabel: _themeLabel,
        onToggleTheme: _cycleTheme,
      ),
    );
  }
}

/// Lists every [LoadingStyle] and opens [StyleDemoPage] when a row is tapped.
///
/// [themeModeLabel] is shown as the app bar brightness control tooltip.
/// [onToggleTheme] cycles [ThemeMode]: system → light → dark → system.
class GalleryPage extends StatelessWidget {
  const GalleryPage({
    super.key,
    required this.themeModeLabel,
    required this.onToggleTheme,
  });

  /// Tooltip string for the theme toggle action (matches current [ThemeMode]).
  final String themeModeLabel;

  /// Switches [ExampleApp]'s [MaterialApp.themeMode].
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading style gallery'),
        actions: [
          IconButton(
            tooltip: themeModeLabel,
            onPressed: onToggleTheme,
            icon: const Icon(Icons.brightness_6_outlined),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        itemCount: LoadingStyle.values.length,
        itemBuilder: (context, index) {
          final style = LoadingStyle.values[index];
          final meta = styleCatalog[style]!;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: SizedBox(
                width: 56,
                height: 56,
                child: Center(
                  child: AnkaSuperLoading(style: style, size: 40),
                ),
              ),
              title: Text(meta.title),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(meta.subtitle),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (context) => StyleDemoPage(style: style),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// Per-style playground: live [AnkaSuperLoading] plus size, duration, and colour.
///
/// Sliders map directly to widget constructor arguments for quick visual QA.
class StyleDemoPage extends StatefulWidget {
  const StyleDemoPage({super.key, required this.style});

  /// Which loader preset this page demonstrates.
  final LoadingStyle style;

  @override
  State<StyleDemoPage> createState() => _StyleDemoPageState();
}

class _StyleDemoPageState extends State<StyleDemoPage> {
  double _size = 96;
  double _durationMs = 1400;
  Color _color = Colors.indigo;

  /// Fixed palette so the demo avoids a heavy colour-picker dependency.
  static const _presetColors = <Color>[
    Colors.indigo,
    Colors.teal,
    Colors.deepOrange,
    Colors.purple,
    Colors.black87,
  ];

  @override
  Widget build(BuildContext context) {
    final meta = styleCatalog[widget.style]!;
    final duration = Duration(milliseconds: _durationMs.round());

    return Scaffold(
      appBar: AppBar(
        title: Text(meta.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            meta.subtitle,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: AnkaSuperLoading(
                  style: widget.style,
                  size: _size,
                  color: _color,
                  duration: duration,
                  semanticsLabel: '${meta.title} preview',
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text('Size (${_size.round()} px)', style: Theme.of(context).textTheme.titleSmall),
          Slider(
            min: 32,
            max: 160,
            value: _size.clamp(32, 160),
            onChanged: (v) => setState(() => _size = v),
          ),
          Text(
            'Loop duration (${duration.inMilliseconds} ms)',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Slider(
            min: 600,
            max: 3200,
            value: _durationMs.clamp(600, 3200),
            onChanged: (v) => setState(() => _durationMs = v),
          ),
          const SizedBox(height: 8),
          Text('Accent colour', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in _presetColors)
                GestureDetector(
                  onTap: () => setState(() => _color = c),
                  child: CircleAvatar(
                    backgroundColor: c,
                    child: _color == c
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 32),
          Text('Sample code', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SelectableText(
            _snippet(widget.style),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Package version (pubspec): 0.1.1',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
          ),
        ],
      ),
    );
  }

  /// Minimal copy-paste sample matching the current [style] enum name.
  String _snippet(LoadingStyle style) {
    final name = style.name;
    return "AnkaSuperLoading(\n  style: LoadingStyle.$name,\n  size: 64,\n  duration: const Duration(milliseconds: 1400),\n);";
  }
}

/// Titles and one-line descriptions shown in the gallery and detail header.
class StyleMeta {
  const StyleMeta({required this.title, required this.subtitle});

  /// Short name for list tiles and the detail app bar.
  final String title;

  /// Single-sentence hint for when to use this style.
  final String subtitle;
}

/// Static copy for the gallery; keys cover every [LoadingStyle] value.
const styleCatalog = <LoadingStyle, StyleMeta>{
  LoadingStyle.pulseOrbit: StyleMeta(
    title: 'Pulse orbit',
    subtitle: 'Three dots pulsing in sequence — good for compact inline states.',
  ),
  LoadingStyle.ringStroke: StyleMeta(
    title: 'Ring stroke',
    subtitle: 'Classic sweeping arc on a ring — familiar and unobtrusive.',
  ),
  LoadingStyle.shimmerBar: StyleMeta(
    title: 'Shimmer bar',
    subtitle: 'Horizontal bar with a moving highlight — ideal for placeholders.',
  ),
  LoadingStyle.segmentSpinner: StyleMeta(
    title: 'Segment spinner',
    subtitle: 'Staggered arc segments rotating together.',
  ),
  LoadingStyle.waveDots: StyleMeta(
    title: 'Wave dots',
    subtitle: 'Dots oscillate vertically in a wave pattern.',
  ),
};
