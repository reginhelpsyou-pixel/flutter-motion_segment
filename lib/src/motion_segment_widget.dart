import 'package:flutter/material.dart';

/// An animated segmented button with a smooth sliding selection indicator.
///
/// [MotionSegment] displays a horizontal or vertical row of tappable segments,
/// with an animated indicator that slides between selections. Each segment
/// accepts custom widgets for icons and labels via [MotionSegmentSelections].
///
/// IMPORTANT!!!
/// The widget requires bounded constraints from its parent. When placed inside
/// a [Row] or [Column], wrap it with [Expanded] or give it an explicit size.
///
/// Example:
/// ```dart
/// MotionSegment(
///   selections: [
///     MotionSegmentSelections(
///       label: WidgetStateProperty.all(const Text('Day')),
///       selectedColor: Colors.blue,
///     ),
///     MotionSegmentSelections(
///       label: WidgetStateProperty.all(const Text('Week')),
///       selectedColor: Colors.blue,
///     ),
///   ],
///   onChanged: (index) {
///     setState(() => _selectedIndex = index);
///   },
/// )
/// ```
class MotionSegment extends StatefulWidget {
  /// The segments to display inside the button.
  ///
  /// Each entry is a [MotionSegmentSelections] that defines the content
  /// and appearance of one segment. Requires at least one entry.
  ///Example:
  ///```dart
  /// selections: [
  ///   MotionSegmentSelection(...),
  ///   MotionSegmentSelection(...),
  ///   MotionSegmentSelection(...)
  /// ]
  /// ```
  final List<MotionSegmentSelections> selections;

  /// The axis along which segments are laid out.
  ///
  /// Defaults to [SelectionDirection.horizontal]. Use
  /// [SelectionDirection.vertical] for a vertically stacked layout.
  /// Vertical layouts require a bounded height from the parent.
  final SelectionDirection? selectionDirection;

  /// The border radius applied to the widget background and indicator.
  ///
  /// Defaults to `BorderRadius.circular(8)` when null.
  final BorderRadius? borderRadius;

  /// The padding between the widget edge and the segments.
  ///
  /// Defaults to `4.0` when null.
  final double? margins;

  /// The spacing between each segment.
  ///
  /// Adds symmetric padding between segments. Defaults to `0` when null.
  final double? selectionsSpacing;

  /// The background color of the widget.
  ///
  /// Defaults to `Theme.of(context).canvasColor` when null.
  final Color? backgroundColor;

  /// The index of the initially selected segment.
  ///
  /// Defaults to `0`. When changed externally via [didUpdateWidget],
  /// the indicator animates to the new index automatically.
  /// Use alongside [onChanged] to manage selection state:
  /// ```dart
  /// int _index = 0;
  ///
  /// MotionSegment(
  ///   selectedIndex: _index,
  ///   onChanged: (value) => setState(() => _index = value),
  ///   selections: [...],
  /// )
  /// ```
  final int? selectedIndex;

  /// Called when the user taps a segment.
  ///
  /// Returns the index of the tapped segment. Use this to update
  /// the [selectedIndex] in your parent widget's state.
  final ValueChanged<int>? onChanged;

  /// The duration of the sliding indicator animation.
  ///
  /// Defaults to `Duration(milliseconds: 250)` when null.
  final Duration? animationDuration;

  /// The curve applied to the sliding indicator animation.
  ///
  /// Defaults to [Curves.easeInOutCubic] when null. Avoid
  /// [Curves.bounceOut], [Curves.bounceIn], and [Curves.bounceInOut]
  /// on low-end devices as it may cause visual stuttering.
  final Curve? animationCurve;

  /// The style of animation played on the indicator when a segment is tapped.
  ///
  /// Defaults to no animation when null. See [SegmentIndicatorAnimation]
  /// for available options.
  final SegmentIndicatorAnimation? indicatorAnimation;

  const MotionSegment({
    super.key,
    this.selectionDirection = SelectionDirection.horizontal,
    this.borderRadius,
    this.backgroundColor,
    required this.selections,
    this.margins,
    this.selectedIndex = 0,
    this.onChanged,
    this.animationDuration,
    this.animationCurve,
    this.indicatorAnimation,
    this.selectionsSpacing,
  });

  @override
  State<MotionSegment> createState() => _MotionSegmentState();
}

class _MotionSegmentState extends State<MotionSegment>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late int _selectedIndex;
  late Animation<Color?> _indicatorColor;
  late double _fromIndex;
  late double _toIndex;
  late Animation<double> _indicatorPosition;
  late Animation<double> _indicatorYScale;
  late Animation<double> _indicatorXScale;

  bool get _isHorizontal =>
      widget.selectionDirection == SelectionDirection.horizontal;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex ?? 0;
    _fromIndex = _selectedIndex.toDouble();
    _toIndex = _selectedIndex.toDouble();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration ?? const Duration(milliseconds: 250),
    );

    _updateAnimation();
  }

  @override
  void didUpdateWidget(covariant MotionSegment oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      setState(() {
        if ((widget.selectedIndex ?? 0) >= widget.selections.length) {
          _selectedIndex = (widget.selectedIndex ?? widget.selections.length) -
              widget.selections.length;
        } else {
          _selectedIndex = widget.selectedIndex ?? 0;
        }
      });
      _updateAnimation();
      _animationController.forward(from: 0.0);
    }
  }

  void _updateAnimation() {
    _indicatorPosition =
        Tween<double>(begin: _fromIndex, end: _toIndex).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve ?? Curves.easeInOutCubic,
      ),
    );

    _indicatorColor = ColorTween(
      begin: widget.selections[_fromIndex.round()].selectedColor,
      end: widget.selections[_toIndex.round()].selectedColor,
    ).animate(_animationController);

    switch (widget.indicatorAnimation) {
      case SegmentIndicatorAnimation.none:
        _indicatorYScale = const AlwaysStoppedAnimation(1.0);
        _indicatorXScale = const AlwaysStoppedAnimation(1.0);

      case SegmentIndicatorAnimation.squish:
        _indicatorYScale = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 70),
          TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 30),
        ]).animate(_animationController);

        _indicatorXScale = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.5), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.0), weight: 50),
        ]).animate(_animationController);
      case SegmentIndicatorAnimation.bounce:
        _indicatorXScale = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 40),
          TweenSequenceItem(tween: Tween(begin: 1.3, end: 0.95), weight: 40),
          TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.0), weight: 20),
        ]).animate(_animationController);
        _indicatorYScale = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.9), weight: 40),
          TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.1), weight: 30),
          TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 30),
        ]).animate(_animationController);
      case SegmentIndicatorAnimation.stretch:
        _indicatorXScale = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 2), weight: 70),
          TweenSequenceItem(tween: Tween(begin: 2, end: 1.0), weight: 30),
        ]).animate(_animationController);
        _indicatorYScale = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.9), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 50),
        ]).animate(_animationController);
      default:
        _indicatorYScale = const AlwaysStoppedAnimation(1.0);
        _indicatorXScale = const AlwaysStoppedAnimation(1.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.backgroundColor,
      borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(widget.margins ?? 4.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            assert(
              !(_isHorizontal && constraints.maxWidth == double.infinity),
              'MotionSegment has unbounded width. '
              'If you are inside a Row, wrap MotionSegment with Expanded: '
              'Row(children: [Expanded(child: MotionSegment(...))])',
            );
            assert(
              !(!_isHorizontal && constraints.maxHeight == double.infinity),
              'MotionSegment has unbounded height. '
              'If you are inside a Column, wrap MotionSegment with Expanded: '
              'Column(children: [Expanded(child: MotionSegment(...))])',
            );

            final segmentedSize = _isHorizontal
                ? constraints.maxWidth / widget.selections.length
                : constraints.maxHeight / widget.selections.length;
            return Stack(
              children: [
                _indicator(segmentedSize),
                _isHorizontal
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widget.selections.indexed.map((record) {
                          final (index, item) = record;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: widget.selectionsSpacing ?? 0,
                              ),
                              child: _buildSegment(item, index),
                            ),
                          );
                        }).toList(),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widget.selections.indexed.map((record) {
                          final (index, item) = record;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: widget.selectionsSpacing ?? 0,
                              ),
                              child: _buildSegment(item, index),
                            ),
                          );
                        }).toList(),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSegment(MotionSegmentSelections item, int index) {
    final states =
        index == _selectedIndex ? {WidgetState.selected} : <WidgetState>{};

    final resolvedIcon = item.icon?.resolve(states);
    final resolvedLabel = item.label?.resolve(states);
    return Ink(
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        hoverColor: item.hoverColor,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        mouseCursor: item.mouseCursor ?? SystemMouseCursors.click,
        onTap: () {
          widget.onChanged?.call(index);
          setState(() {
            _fromIndex = _toIndex * _animationController.value +
                _fromIndex * (1 - _animationController.value);
            _toIndex = index.toDouble();

            _selectedIndex = index;
          });
          _updateAnimation();
          _animationController.forward(from: 0.0);
        },
        child: _isHorizontal
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (resolvedIcon != null) resolvedIcon,
                  if (resolvedIcon != null && resolvedLabel != null)
                    const SizedBox(
                      width: 4,
                      height: double.maxFinite,
                    ),
                  if (resolvedLabel != null) resolvedLabel,
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (resolvedIcon != null) resolvedIcon,
                  if (resolvedIcon != null && resolvedLabel != null)
                    const SizedBox(width: double.maxFinite, height: 4),
                  if (resolvedLabel != null) resolvedLabel,
                ],
              ),
      ),
    );
  }

  Widget _indicator(double segmentSize) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return _isHorizontal
            ? Positioned(
                left: _indicatorPosition.value * segmentSize +
                    ((widget.selectionsSpacing ?? 0)),
                top: 0,
                bottom: 0,
                width: segmentSize - ((widget.selectionsSpacing ?? 0) * 2),
                child: Align(
                  alignment: Alignment.center,
                  child: FractionallySizedBox(
                    heightFactor: _indicatorYScale.value,
                    widthFactor: _indicatorXScale.value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _indicatorColor.value,
                        borderRadius:
                            widget.borderRadius ?? BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              )
            : Positioned(
                top: _indicatorPosition.value * segmentSize +
                    ((widget.selectionsSpacing ?? 0)),
                left: 0,
                right: 0,
                height: segmentSize - ((widget.selectionsSpacing ?? 0) * 2),
                child: Align(
                  alignment: Alignment.center,
                  child: FractionallySizedBox(
                    heightFactor: _indicatorXScale.value,
                    widthFactor: _indicatorYScale.value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _indicatorColor.value,
                        borderRadius:
                            widget.borderRadius ?? BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}

/// Defines the content and appearance of a single segment in [MotionSegment].
class MotionSegmentSelections {
  /// The icon displayed inside the segment.
  ///
  /// Accepts a [WidgetStateProperty] so the icon can differ between
  /// selected and unselected states:
  /// ```dart
  /// icon: WidgetStateProperty.resolveWith((states) {
  ///   if (states.contains(WidgetState.selected)) {
  ///     return const Icon(Icons.check, color: Colors.white);
  ///   }
  ///   return const Icon(Icons.check, color: Colors.grey);
  /// }),
  /// ```
  final WidgetStateProperty<Widget?>? icon;

  /// The label displayed inside the segment.
  ///
  /// Accepts a [WidgetStateProperty] so the label style can differ
  /// between selected and unselected states. Can be any [Widget],
  /// not just [Text].
  final WidgetStateProperty<Widget?>? label;

  /// The background color of the sliding indicator when this segment is selected.
  ///
  /// If null, the indicator renders with a transparent color.
  final Color? selectedColor;

  /// The color of the hover overlay when the segment is hovered.
  ///
  /// Defaults to the theme's hover color when null. Pass
  /// [Colors.transparent] to disable hover highlighting.
  final Color? hoverColor;

  /// The mouse cursor shown when hovering over this segment.
  ///
  /// Defaults to [SystemMouseCursors.click] when null.
  final MouseCursor? mouseCursor;
  const MotionSegmentSelections({
    this.icon,
    this.label,
    this.selectedColor,
    this.mouseCursor,
    this.hoverColor,
  });
}

/// The axis along which [MotionSegment] lays out its segments.
enum SelectionDirection {
  /// Segments are arranged left to right.
  ///
  /// Requires the parent to provide a bounded height.
  horizontal,

  /// Segments are arranged top to bottom.
  ///
  /// Requires the parent to provide a bounded height.
  vertical
}

/// The animation style applied to the sliding indicator in [MotionSegment].
enum SegmentIndicatorAnimation {
  /// No deformation animation. The indicator slides without changing shape.
  none,

  /// The indicator squishes horizontally and expands vertically mid-slide,
  /// then recovers at the destination.
  squish,

  /// The indicator overshoots slightly and bounces back on arrival.
  bounce,

  /// The indicator stretches horizontally across segments during the slide,
  /// then snaps back to its normal size.
  stretch,
}
