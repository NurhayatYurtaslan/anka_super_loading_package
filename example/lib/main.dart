import 'package:anka_super_loading_package/anka_super_loading_package.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Public GitHub URL for this package; opened from the Info tab.
const String kPackageRepositoryUrl =
    'https://github.com/NurhayatYurtaslan/anka_super_loading_package';

/// Bundled Anka Software Club mark used on the Info screen.
const String kClubLogoAsset = 'assets/branding/anka_club_logo.png';

/// Sample app for **anka_super_loading_package**: gallery, Info tab, detail playground, and theme QA.
///
/// Not published to pub.dev; it exists to validate loaders under light/dark
/// themes and different [AnkaSuperLoading] parameters.
void main() {
  runApp(const ExampleApp());
}

/// Root widget: hosts [MaterialApp] and forwards theme controls to [ExampleShell].
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF156666),
        ),
        useMaterial3: true,
        tabBarTheme: const TabBarThemeData(
          dividerColor: Colors.transparent,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF156666),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        tabBarTheme: const TabBarThemeData(
          dividerColor: Colors.transparent,
        ),
      ),
      home: ExampleShell(
        themeModeLabel: _themeLabel,
        onToggleTheme: _cycleTheme,
      ),
    );
  }
}

/// Home shell: [TabBar] under the [AppBar] switches gallery vs. package Info.
///
/// [themeModeLabel] is shown as the app bar brightness control tooltip.
/// [onToggleTheme] cycles [ThemeMode]: system → light → dark → system.
class ExampleShell extends StatefulWidget {
  const ExampleShell({
    super.key,
    required this.themeModeLabel,
    required this.onToggleTheme,
  });

  /// Tooltip string for the theme toggle action (matches current [ThemeMode]).
  final String themeModeLabel;

  /// Switches [ExampleApp]'s [MaterialApp.themeMode].
  final VoidCallback onToggleTheme;

  @override
  State<ExampleShell> createState() => _ExampleShellState();
}

class _ExampleShellState extends State<ExampleShell>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('anka_super_loading'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Gallery'),
            Tab(text: 'Info'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: widget.themeModeLabel,
            onPressed: widget.onToggleTheme,
            icon: const Icon(Icons.brightness_6_outlined),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          GalleryBody(),
          PackageInfoTab(),
        ],
      ),
    );
  }
}

/// Lists every [LoadingStyle] and opens [StyleDemoPage] when a row is tapped.
class GalleryBody extends StatelessWidget {
  const GalleryBody({super.key});

  @override
  Widget build(BuildContext context) {
    final outline = Theme.of(context).colorScheme.outlineVariant;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      itemCount: LoadingStyle.values.length,
      itemBuilder: (context, index) {
        final style = LoadingStyle.values[index];
        final meta = styleCatalog[style]!;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: outline.withValues(alpha: 0.5)),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (context) => StyleDemoPage(style: style),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: Center(
                        child: AnkaSuperLoading(style: style, size: 40),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meta.title,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            meta.subtitle,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Package context, club branding, and a shortcut to the public repository.
class PackageInfoTab extends StatelessWidget {
  const PackageInfoTab({super.key});

  Future<void> _openRepository(BuildContext context) async {
    final uri = Uri.parse(kPackageRepositoryUrl);
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!context.mounted) return;
    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final surfaceHi = scheme.surfaceContainerHighest;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
      children: [
        Center(
          child: Semantics(
            label: 'Anka Software Club logo',
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: scheme.shadow.withValues(alpha: 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  kClubLogoAsset,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return ColoredBox(
                      color: surfaceHi,
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 40,
                          color: scheme.outline,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Open source at Anka',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            style: textTheme.bodyLarge?.copyWith(
              height: 1.55,
              color: scheme.onSurfaceVariant,
            ),
            children: [
              const TextSpan(text: 'The '),
              TextSpan(
                text: 'anka_super_loading_package',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: scheme.primary,
                  fontFamily: 'monospace',
                  fontSize: (textTheme.bodyLarge?.fontSize ?? 16) * 0.92,
                ),
              ),
              const TextSpan(
                text:
                    ' library is open source and was started for the Anka '
                    'Software Club community event. Use this example to preview '
                    'every preset, then pull the package into your own Flutter '
                    'projects—issues and pull requests are welcome on GitHub.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Repository',
          style: textTheme.labelLarge?.copyWith(
            letterSpacing: 0.6,
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 10),
        Material(
          color: surfaceHi,
          borderRadius: BorderRadius.circular(14),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _openRepository(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(Icons.link_rounded, color: scheme.primary, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SelectableText(
                      kPackageRepositoryUrl,
                      style: textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        height: 1.4,
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.open_in_new_rounded,
                    size: 20,
                    color: scheme.outline,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => _openRepository(context),
            icon: const Icon(Icons.open_in_new_rounded, size: 20),
            label: const Text('Open on GitHub'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Divider(color: scheme.outlineVariant.withValues(alpha: 0.6)),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: AnkaSuperLoading(
            style: LoadingStyle.ringStroke,
            size: 40,
            color: scheme.primary.withValues(alpha: 0.85),
            semanticsLabel: 'Loader accent on info page',
          ),
        ),
      ],
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
            'Package version (pubspec): 0.1.2',
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
