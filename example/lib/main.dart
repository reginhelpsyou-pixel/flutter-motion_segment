import 'package:flutter/material.dart';
import 'package:motion_segment/motion_segment.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'motion_segment Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  int _index1 = 0;
  int _index2 = 0;
  int _index3 = 0;
  int _index4 = 0;
  int _index5 = 0;

  static const _labelStyle =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w500);

  List<MotionSegmentSelections> _timeSelections(BuildContext context) => [
        MotionSegmentSelections(
          selectedColor: Theme.of(context).colorScheme.primary,
          icon: WidgetStateProperty.resolveWith((states) => Icon(
                Icons.calendar_today,
                size: 16,
                color: states.contains(WidgetState.selected)
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              )),
          label: WidgetStateProperty.resolveWith((states) => Center(
                child: Text(
                  'Day',
                  style: _labelStyle.copyWith(
                    color: states.contains(WidgetState.selected)
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              )),
        ),
        MotionSegmentSelections(
          selectedColor: Theme.of(context).colorScheme.primary,
          icon: WidgetStateProperty.resolveWith((states) => Icon(
                Icons.view_week,
                size: 16,
                color: states.contains(WidgetState.selected)
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              )),
          label: WidgetStateProperty.resolveWith((states) => Center(
                child: Text(
                  'Week',
                  style: _labelStyle.copyWith(
                    color: states.contains(WidgetState.selected)
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              )),
        ),
        MotionSegmentSelections(
          selectedColor: Theme.of(context).colorScheme.primary,
          icon: WidgetStateProperty.resolveWith((states) => Icon(
                Icons.calendar_month,
                size: 16,
                color: states.contains(WidgetState.selected)
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              )),
          label: WidgetStateProperty.resolveWith((states) => Center(
                child: Text(
                  'Month',
                  style: _labelStyle.copyWith(
                    color: states.contains(WidgetState.selected)
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              )),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final sections = [
      (
        label: 'None',
        animation: SegmentIndicatorAnimation.none,
        index: _index1,
        onChanged: (v) => setState(() => _index1 = v),
      ),
      (
        label: 'Squish',
        animation: SegmentIndicatorAnimation.squish,
        index: _index2,
        onChanged: (v) => setState(() => _index2 = v),
      ),
      (
        label: 'Bounce',
        animation: SegmentIndicatorAnimation.bounce,
        index: _index3,
        onChanged: (v) => setState(() => _index3 = v),
      ),
      (
        label: 'Stretch',
        animation: SegmentIndicatorAnimation.stretch,
        index: _index4,
        onChanged: (v) => setState(() => _index4 = v),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('motion_segment Demo'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Indicator Animations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tap a segment to see each animation style.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ...sections.map((s) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.label,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 52,
                      child: MotionSegment(
                        selectedIndex: s.index,
                        onChanged: s.onChanged,
                        indicatorAnimation: s.animation,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        margins: 4,
                        selections: _timeSelections(context),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                )),
            const Divider(
              thickness: 4,
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Vertical Layout',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: SizedBox(
                height: 180,
                width: 120,
                child: MotionSegment(
                  selectionDirection: SelectionDirection.vertical,
                  selectedIndex: _index5,
                  onChanged: (v) => setState(() => _index5 = v),
                  indicatorAnimation: SegmentIndicatorAnimation.squish,
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  margins: 4,
                  selections: [
                    MotionSegmentSelections(
                      selectedColor: Theme.of(context).colorScheme.primary,
                      icon: WidgetStateProperty.resolveWith((states) => Icon(
                            Icons.home,
                            color: states.contains(WidgetState.selected)
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                          )),
                    ),
                    MotionSegmentSelections(
                      selectedColor: Theme.of(context).colorScheme.primary,
                      icon: WidgetStateProperty.resolveWith((states) => Icon(
                            Icons.search,
                            color: states.contains(WidgetState.selected)
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                          )),
                    ),
                    MotionSegmentSelections(
                      selectedColor: Theme.of(context).colorScheme.primary,
                      icon: WidgetStateProperty.resolveWith((states) => Icon(
                            Icons.person,
                            color: states.contains(WidgetState.selected)
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
