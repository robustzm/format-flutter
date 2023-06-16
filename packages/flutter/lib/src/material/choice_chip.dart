// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart' show clampDouble;
import 'package:flutter/widgets.dart';

import 'chip.dart';
import 'chip_theme.dart';
import 'color_scheme.dart';
import 'colors.dart';
import 'debug.dart';
import 'text_theme.dart';
import 'theme.dart';
import 'theme_data.dart';

enum _ChipVariant { flat, elevated }

/// A Material Design choice chip.
///
/// [ChoiceChip]s represent a single choice from a set. Choice chips contain
/// related descriptive text or categories.
///
/// Requires one of its ancestors to be a [Material] widget. The [selected] and
/// [label] arguments must not be null.
///
/// {@tool dartpad}
/// This example shows how to create [ChoiceChip]s with [onSelected]. When the
/// user taps, the chip will be selected.
///
/// ** See code in examples/api/lib/material/choice_chip/choice_chip.0.dart **
/// {@end-tool}
///
/// ## Material Design 3
///
/// [ChoiceChip] can be used for single select Filter chips from
/// Material Design 3. If [ThemeData.useMaterial3] is true, then [ChoiceChip]
/// will be styled to match the Material Design 3 specification for Filter
/// chips. Use [FilterChip] for multiple select Filter chips.
///
/// See also:
///
///  * [Chip], a chip that displays information and can be deleted.
///  * [InputChip], a chip that represents a complex piece of information, such
///    as an entity (person, place, or thing) or conversational text, in a
///    compact form.
///  * [FilterChip], uses tags or descriptive words as a way to filter content.
///  * [ActionChip], represents an action related to primary content.
///  * [CircleAvatar], which shows images or initials of people.
///  * [Wrap], A widget that displays its children in multiple horizontal or
///    vertical runs.
///  * <https://material.io/design/components/chips.html>
class ChoiceChip extends StatelessWidget
    implements
        ChipAttributes,
        SelectableChipAttributes,
        CheckmarkableChipAttributes,
        DisabledChipAttributes {
  /// Create a chip that acts like a radio button.
  ///
  /// The [label], [selected], [autofocus], and [clipBehavior] arguments must
  /// not be null. The [pressElevation] and [elevation] must be null or
  /// non-negative. Typically, [pressElevation] is greater than [elevation].
  const ChoiceChip({
    super.key,
    this.avatar,
    required this.label,
    this.labelStyle,
    this.labelPadding,
    this.onSelected,
    this.pressElevation,
    required this.selected,
    this.selectedColor,
    this.disabledColor,
    this.tooltip,
    this.side,
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.backgroundColor,
    this.padding,
    this.visualDensity,
    this.materialTapTargetSize,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.iconTheme,
    this.selectedShadowColor,
    this.showCheckmark,
    this.checkmarkColor,
    this.avatarBorder = const CircleBorder(),
  }) : assert(pressElevation == null || pressElevation >= 0.0),
       assert(elevation == null || elevation >= 0.0),
       _chipVariant = _ChipVariant.flat;

  /// Create an elevated chip that acts like a radio button.
  ///
  /// The [label], [selected], [autofocus], and [clipBehavior] arguments must
  /// not be null. The [pressElevation] and [elevation] must be null or
  /// non-negative. Typically, [pressElevation] is greater than [elevation].
  const ChoiceChip.elevated({
    super.key,
    this.avatar,
    required this.label,
    this.labelStyle,
    this.labelPadding,
    this.onSelected,
    this.pressElevation,
    required this.selected,
    this.selectedColor,
    this.disabledColor,
    this.tooltip,
    this.side,
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.backgroundColor,
    this.padding,
    this.visualDensity,
    this.materialTapTargetSize,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.iconTheme,
    this.selectedShadowColor,
    this.showCheckmark,
    this.checkmarkColor,
    this.avatarBorder = const CircleBorder(),
  }) : assert(pressElevation == null || pressElevation >= 0.0),
       assert(elevation == null || elevation >= 0.0),
       _chipVariant = _ChipVariant.elevated;

  @override
  final Widget? avatar;
  @override
  final Widget label;
  @override
  final TextStyle? labelStyle;
  @override
  final EdgeInsetsGeometry? labelPadding;
  @override
  final ValueChanged<bool>? onSelected;
  @override
  final double? pressElevation;
  @override
  final bool selected;
  @override
  final Color? disabledColor;
  @override
  final Color? selectedColor;
  @override
  final String? tooltip;
  @override
  final BorderSide? side;
  @override
  final OutlinedBorder? shape;
  @override
  final Clip clipBehavior;
  @override
  final FocusNode? focusNode;
  @override
  final bool autofocus;
  @override
  final Color? backgroundColor;
  @override
  final EdgeInsetsGeometry? padding;
  @override
  final VisualDensity? visualDensity;
  @override
  final MaterialTapTargetSize? materialTapTargetSize;
  @override
  final double? elevation;
  @override
  final Color? shadowColor;
  @override
  final Color? surfaceTintColor;
  @override
  final Color? selectedShadowColor;
  @override
  final bool? showCheckmark;
  @override
  final Color? checkmarkColor;
  @override
  final ShapeBorder avatarBorder;
  @override
  final IconThemeData? iconTheme;

  @override
  bool get isEnabled => onSelected != null;

  final _ChipVariant _chipVariant;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final ChipThemeData chipTheme = ChipTheme.of(context);
    final ChipThemeData? defaults = Theme.of(context).useMaterial3
        ? _ChoiceChipDefaultsM3(context, isEnabled, selected, _chipVariant)
        : null;
    return RawChip(
      defaultProperties: defaults,
      avatar: avatar,
      label: label,
      labelStyle:
          labelStyle ?? (selected ? chipTheme.secondaryLabelStyle : null),
      labelPadding: labelPadding,
      onSelected: onSelected,
      pressElevation: pressElevation,
      selected: selected,
      showCheckmark: showCheckmark ??
          chipTheme.showCheckmark ??
          Theme.of(context).useMaterial3,
      checkmarkColor: checkmarkColor,
      tooltip: tooltip,
      side: side,
      shape: shape,
      clipBehavior: clipBehavior,
      focusNode: focusNode,
      autofocus: autofocus,
      disabledColor: disabledColor,
      selectedColor: selectedColor ?? chipTheme.secondarySelectedColor,
      backgroundColor: backgroundColor,
      padding: padding,
      visualDensity: visualDensity,
      isEnabled: isEnabled,
      materialTapTargetSize: materialTapTargetSize,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      selectedShadowColor: selectedShadowColor,
      avatarBorder: avatarBorder,
      iconTheme: iconTheme,
    );
  }
}

// BEGIN GENERATED TOKEN PROPERTIES - ChoiceChip

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

class _ChoiceChipDefaultsM3 extends ChipThemeData {
  _ChoiceChipDefaultsM3(
    this.context,
    this.isEnabled,
    this.isSelected,
    this._chipVariant,
  ) : super(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        showCheckmark: true,
      );

  final BuildContext context;
  final bool isEnabled;
  final bool isSelected;
  final _ChipVariant _chipVariant;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  @override
  double? get elevation => _chipVariant == _ChipVariant.flat
      ? 0.0
      : isEnabled
          ? 1.0
          : 0.0;

  @override
  double? get pressElevation => 1.0;

  @override
  TextStyle? get labelStyle => _textTheme.labelLarge;

  @override
  Color? get backgroundColor => null;

  @override
  Color? get shadowColor =>
      _chipVariant == _ChipVariant.flat ? Colors.transparent : _colors.shadow;

  @override
  Color? get surfaceTintColor => _colors.surfaceTint;

  @override
  Color? get selectedColor => _chipVariant == _ChipVariant.flat
      ? isEnabled
          ? _colors.secondaryContainer
          : _colors.onSurface.withOpacity(0.12)
      : isEnabled
          ? _colors.secondaryContainer
          : _colors.onSurface.withOpacity(0.12);

  @override
  Color? get checkmarkColor => _colors.onSecondaryContainer;

  @override
  Color? get disabledColor => _chipVariant == _ChipVariant.flat
      ? isSelected
          ? _colors.onSurface.withOpacity(0.12)
          : null
      : _colors.onSurface.withOpacity(0.12);

  @override
  Color? get deleteIconColor => _colors.onSecondaryContainer;

  @override
  BorderSide? get side => _chipVariant == _ChipVariant.flat && !isSelected
      ? isEnabled
          ? BorderSide(color: _colors.outline)
          : BorderSide(color: _colors.onSurface.withOpacity(0.12))
      : const BorderSide(color: Colors.transparent);

  @override
  IconThemeData? get iconTheme => IconThemeData(
    color: isEnabled ? null : _colors.onSurface,
    size: 18.0,
  );

  @override
  EdgeInsetsGeometry? get padding => const EdgeInsets.all(8.0);

  /// The chip at text scale 1 starts with 8px on each side and as text scaling
  /// gets closer to 2 the label padding is linearly interpolated from 8px to 4px.
  /// Once the widget has a text scaling of 2 or higher than the label padding
  /// remains 4px.
  @override
  EdgeInsetsGeometry? get labelPadding => EdgeInsets.lerp(
    const EdgeInsets.symmetric(horizontal: 8.0),
    const EdgeInsets.symmetric(horizontal: 4.0),
    clampDouble(MediaQuery.textScaleFactorOf(context) - 1.0, 0.0, 1.0),
  )!;
}

// END GENERATED TOKEN PROPERTIES - ChoiceChip
