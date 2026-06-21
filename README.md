# motion_segment

A highly customizable animated segmented button for Flutter with a smooth sliding selection indicator.

## Features

- Smooth sliding indicator animation between segments
- Four indicator animation styles: `none`, `squish`, `bounce`, `stretch`
- Horizontal and vertical layouts
- Per-state icon and label customization via `WidgetStateProperty`
- Customizable colors, border radius, margins, and spacing
- Custom animation duration and curve
- Light and dark theme support
- Supports Android, iOS, Web, Windows, macOS, and Linux

## Installation

Add `motion_segment` to your `pubspec.yaml`:

```yaml
dependencies:
  motion_segment: ^0.1.2
```

Then run:

```bash
flutter pub get
```

## Basic Usage

```dart
import 'package:motion_segment/motion_segment.dart';

int _selectedIndex = 0;

SizedBox(
  height: 52,
  child: MotionSegment(
    selectedIndex: _selectedIndex,
    onChanged: (value) {
      setState(() => _selectedIndex = value);
    },
    backgroundColor: Colors.grey.shade200,
    indicatorAnimation: SegmentIndicatorAnimation.squish,
    selections: [
      MotionSegmentSelections(
        selectedColor: Colors.blue,
        label: WidgetStateProperty.resolveWith((states) => Text(
          'Day',
          style: TextStyle(
            color: states.contains(WidgetState.selected)
                ? Colors.white
                : Colors.black54,
          ),
        )),
      ),
      MotionSegmentSelections(
        selectedColor: Colors.blue,
        label: WidgetStateProperty.resolveWith((states) => Text(
          'Week',
          style: TextStyle(
            color: states.contains(WidgetState.selected)
                ? Colors.white
                : Colors.black54,
          ),
        )),
      ),
      MotionSegmentSelections(
        selectedColor: Colors.blue,
        label: WidgetStateProperty.resolveWith((states) => Text(
          'Month',
          style: TextStyle(
            color: states.contains(WidgetState.selected)
                ? Colors.white
                : Colors.black54,
          ),
        )),
      ),
    ],
  ),
)
```

## Vertical Layout

```dart
SizedBox(
  height: 180,
  width: 64,
  child: MotionSegment(
    selectionDirection: SelectionDirection.vertical,
    selectedIndex: _selectedIndex,
    onChanged: (value) => setState(() => _selectedIndex = value),
    indicatorAnimation: SegmentIndicatorAnimation.bounce,
    selections: [
      MotionSegmentSelections(
        selectedColor: Colors.blue,
        icon: WidgetStateProperty.resolveWith((states) => Icon(
          Icons.home,
          color: states.contains(WidgetState.selected)
              ? Colors.white
              : Colors.black54,
        )),
      ),
      MotionSegmentSelections(
        selectedColor: Colors.blue,
        icon: WidgetStateProperty.resolveWith((states) => Icon(
          Icons.search,
          color: states.contains(WidgetState.selected)
              ? Colors.white
              : Colors.black54,
        )),
      ),
      MotionSegmentSelections(
        selectedColor: Colors.blue,
        icon: WidgetStateProperty.resolveWith((states) => Icon(
          Icons.person,
          color: states.contains(WidgetState.selected)
              ? Colors.white
              : Colors.black54,
        )),
      ),
    ],
  ),
)
```

## MotionSegment Parameters

| Parameter            | Type                            | Default           | Description                          |
| -------------------- | ------------------------------- | ----------------- | ------------------------------------ |
| `selections`         | `List<MotionSegmentSelections>` | required          | The segments to display              |
| `onChanged`          | `ValueChanged<int>?`            | null              | Called when a segment is tapped      |
| `selectedIndex`      | `int?`                          | 0                 | The initially selected segment index |
| `selectionDirection` | `SelectionDirection?`           | horizontal        | Axis of layout                       |
| `indicatorAnimation` | `SegmentIndicatorAnimation?`    | null              | Indicator animation style            |
| `backgroundColor`    | `Color?`                        | theme canvasColor | Background color                     |
| `borderRadius`       | `BorderRadiusGeometry?`         | circular(8)       | Border radius                        |
| `margins`            | `double?`                       | 4.0               | Padding around segments              |
| `selectionsSpacing`  | `double?`                       | 0                 | Spacing between segments             |
| `animationDuration`  | `Duration?`                     | 250ms             | Animation duration                   |
| `animationCurve`     | `Curve?`                        | easeInOutCubic    | Animation curve                      |

## MotionSegmentSelections Parameters

| Parameter       | Type                            | Description                                   |
| --------------- | ------------------------------- | --------------------------------------------- |
| `selectedColor` | `Color?`                        | Indicator color when this segment is selected |
| `icon`          | `WidgetStateProperty<Widget?>?` | Icon with per-state customization             |
| `label`         | `WidgetStateProperty<Widget?>?` | Label with per-state customization            |
| `hoverColor`    | `Color?`                        | Hover overlay color                           |
| `mouseCursor`   | `MouseCursor?`                  | Cursor on hover, defaults to click            |

## Indicator Animation Styles

| Style     | Description                            |
| --------- | -------------------------------------- |
| `none`    | Slides without shape change            |
| `squish`  | Squishes horizontally mid-slide        |
| `bounce`  | Overshoots and bounces on arrival      |
| `stretch` | Stretches across segments during slide |

## Layout Constraints

`MotionSegment` expands to fill its parent's constraints. When used inside a `Row`, wrap with `Expanded` or give it an explicit width. When using vertical layout inside a `Column`, wrap with `Expanded` or give it an explicit height.

```dart
// Inside a Row
Row(
  children: [
    Expanded(child: MotionSegment(...)),
  ],
)

// Explicit size
SizedBox(
  height: 52,
  child: MotionSegment(...),
)
```

## License

MIT
