import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';
import 'animal_button.dart';
import 'animal_bottom_sheet.dart';
import 'animal_modal.dart';
import 'theme_strategies/animal_date_time_picker_theme_strategy.dart';

Future<DateTime?> showAnimalDateTimePicker({
  required BuildContext context,
  DateTime? initialValue,
  DateTime? firstDate,
  DateTime? lastDate,
  AnimalDateTimePickerMode mode = AnimalDateTimePickerMode.dateTime,
  int minuteStep = 5,
  bool use24Hour = true,
  bool allowHourFormatToggle = false,
  String title = '',
  String confirmText = '确定',
  String cancelText = '取消',
  bool useRootNavigator = true,
}) async {
  final initial = _clampToRange(
    initialValue ?? DateTime.now(),
    firstDate,
    lastDate,
  );
  final compact = MediaQuery.sizeOf(context).width < 720;
  final width = switch (mode) {
    AnimalDateTimePickerMode.date => 420.0,
    AnimalDateTimePickerMode.time => 340.0,
    AnimalDateTimePickerMode.dateTime => 460.0,
  };
  var draft = initial;

  Widget buildFooter(BuildContext context, StateSetter _) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimalButton(
          type: AnimalButtonType.defaultType,
          size: AnimalButtonSize.middle,
          onPressed: () =>
              Navigator.of(context, rootNavigator: useRootNavigator).pop(),
          child: Text(cancelText),
        ),
        const SizedBox(width: 12),
        AnimalButton(
          type: AnimalButtonType.primary,
          size: AnimalButtonSize.middle,
          onPressed: () =>
              Navigator.of(context, rootNavigator: useRootNavigator).pop(draft),
          child: Text(confirmText),
        ),
      ],
    );
  }

  Widget buildPicker(StateSetter setState) {
    return AnimalDateTimePicker(
      value: draft,
      firstDate: firstDate,
      lastDate: lastDate,
      minuteStep: minuteStep,
      mode: mode,
      use24Hour: true,
      allowHourFormatToggle: false,
      onChanged: (value) => setState(() => draft = value),
    );
  }

  if (compact) {
    return showAnimalBottomSheet<DateTime>(
      context: context,
      useRootNavigator: useRootNavigator,
      maxWidth: 520,
      maxHeightRatio: 0.94,
      showHandle: true,
      showCloseButton: true,
      typewriter: false,
      title: Text(title),
      footer: StatefulBuilder(builder: buildFooter),
      child: StatefulBuilder(
        builder: (context, setState) => buildPicker(setState),
      ),
    );
  }

  return showAnimalDialog<DateTime>(
    context: context,
    width: width,
    useRootNavigator: useRootNavigator,
    typewriter: false,
    title: Text(title),
    footer: StatefulBuilder(builder: buildFooter),
    child: StatefulBuilder(
      builder: (context, setState) => buildPicker(setState),
    ),
  );
}

class AnimalDateTimePicker extends StatefulWidget {
  const AnimalDateTimePicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
    this.mode = AnimalDateTimePickerMode.dateTime,
    this.minuteStep = 5,
    this.use24Hour = true,
    this.allowHourFormatToggle = false,
    this.showQuickActions = false,
    this.enabled = true,
    this.onHourFormatChanged,
  });

  final DateTime value;
  final ValueChanged<DateTime> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final AnimalDateTimePickerMode mode;
  final int minuteStep;
  final bool use24Hour;
  final bool allowHourFormatToggle;
  final bool showQuickActions;
  final bool enabled;
  final ValueChanged<bool>? onHourFormatChanged;

  @override
  State<AnimalDateTimePicker> createState() => _AnimalDateTimePickerState();
}

class _AnimalDateTimePickerState extends State<AnimalDateTimePicker> {
  late DateTime _displayMonth = _monthStart(widget.value);
  late final FixedExtentScrollController _hourController =
      FixedExtentScrollController(initialItem: widget.value.hour);
  late final FixedExtentScrollController _minuteController =
      FixedExtentScrollController(
        initialItem: _closestMinuteIndex(
          widget.value.minute,
          widget.minuteStep,
        ),
      );

  bool get _showsDate =>
      widget.mode == AnimalDateTimePickerMode.date ||
      widget.mode == AnimalDateTimePickerMode.dateTime;

  bool get _showsTime =>
      widget.mode == AnimalDateTimePickerMode.time ||
      widget.mode == AnimalDateTimePickerMode.dateTime;

  @override
  void didUpdateWidget(covariant AnimalDateTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isSameMonth(oldWidget.value, widget.value)) {
      _displayMonth = _monthStart(widget.value);
    }
    _scheduleWheelSync();
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  void _updateValue(DateTime next) {
    if (!widget.enabled) {
      return;
    }
    final clamped = _clampToRange(next, widget.firstDate, widget.lastDate);
    if (_isSameMoment(clamped, widget.value)) {
      return;
    }
    widget.onChanged(clamped);
  }

  void _selectDate(DateTime date) {
    _updateValue(
      DateTime(
        date.year,
        date.month,
        date.day,
        widget.value.hour,
        widget.value.minute,
      ),
    );
  }

  void _setHour(int hour) {
    _updateValue(
      DateTime(
        widget.value.year,
        widget.value.month,
        widget.value.day,
        hour,
        widget.value.minute,
      ),
    );
  }

  void _setMinute(int minute) {
    _updateValue(
      DateTime(
        widget.value.year,
        widget.value.month,
        widget.value.day,
        widget.value.hour,
        minute,
      ),
    );
  }

  void _changeMonth(int delta) {
    final next = DateTime(_displayMonth.year, _displayMonth.month + delta);
    if (!_canDisplayMonth(next)) {
      return;
    }
    setState(() => _displayMonth = next);
  }

  void _scheduleWheelSync() {
    final hour = widget.value.hour;
    final minuteIndex = _closestMinuteIndex(
      widget.value.minute,
      widget.minuteStep,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _jumpWheelIfNeeded(_hourController, hour);
      _jumpWheelIfNeeded(_minuteController, minuteIndex);
    });
  }

  void _jumpWheelIfNeeded(
    FixedExtentScrollController controller,
    int targetItem,
  ) {
    if (!controller.hasClients || controller.selectedItem == targetItem) {
      return;
    }
    controller.jumpToItem(targetItem);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final strategy = AnimalDateTimePickerThemeStrategy.of(theme);
    final compact = MediaQuery.sizeOf(context).width < 720;

    return Opacity(
      opacity: widget.enabled ? 1 : 0.58,
      child: AnimatedContainer(
        duration: AnimalIslandTokens.base,
        curve: AnimalIslandTokens.motionCurve,
        padding: strategy.rootPadding(compact: compact),
        decoration: strategy.rootDecoration(theme, compact: compact),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_showsDate) _buildCalendar(context),
            if (_showsTime) ...[
              if (_showsDate) SizedBox(height: strategy.sectionGap()),
              _buildTimePanel(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    final theme = context.animalIslandTheme;
    final strategy = AnimalDateTimePickerThemeStrategy.of(theme);
    final daysInMonth = DateUtils.getDaysInMonth(
      _displayMonth.year,
      _displayMonth.month,
    );
    final systemHeader = strategy.buildSystemHeader(
      context,
      theme,
      label: 'CALENDAR VECTOR',
      value:
          '${_displayMonth.year}.${_displayMonth.month.toString().padLeft(2, '0')}',
    );
    final firstWeekday =
        DateTime(_displayMonth.year, _displayMonth.month, 1).weekday % 7;
    final cells = <Widget>[];

    for (var index = 0; index < 42; index++) {
      final day = index - firstWeekday + 1;
      if (day < 1 || day > daysInMonth) {
        cells.add(const SizedBox.shrink());
        continue;
      }

      final date = DateTime(_displayMonth.year, _displayMonth.month, day);
      final selected = _isSameDate(widget.value, date);
      final today = _isSameDate(DateTime.now(), date);
      final disabled = !_isWithinRange(date, widget.firstDate, widget.lastDate);

      cells.add(
        _CalendarCell(
          day: day,
          selected: selected,
          today: today,
          disabled: disabled || !widget.enabled,
          onTap: () => _selectDate(date),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        strategy.panelPadding(AnimalDateTimePickerPanelKind.calendar).top,
        12,
        strategy.panelPadding(AnimalDateTimePickerPanelKind.calendar).bottom,
      ),
      decoration: strategy.pickerPanelDecoration(theme),
      child: Column(
        children: [
          if (systemHeader != null) ...[
            systemHeader,
            const SizedBox(height: 6),
          ],
          Row(
            children: [
              _RoundActionButton(
                icon: Icons.chevron_left_rounded,
                enabled:
                    widget.enabled &&
                    _canDisplayMonth(
                      DateTime(_displayMonth.year, _displayMonth.month - 1),
                    ),
                onTap: () => _changeMonth(-1),
              ),
              Expanded(
                child: Text(
                  '${_displayMonth.year}年 ${_monthLabels[_displayMonth.month - 1]}',
                  textAlign: TextAlign.center,
                  style: strategy.monthTitleStyle(context, theme),
                ),
              ),
              _RoundActionButton(
                icon: Icons.chevron_right_rounded,
                enabled:
                    widget.enabled &&
                    _canDisplayMonth(
                      DateTime(_displayMonth.year, _displayMonth.month + 1),
                    ),
                onTap: () => _changeMonth(1),
              ),
            ],
          ),
          SizedBox(height: strategy.calendarHeaderGap()),
          Row(
            children: _weekdayLabels
                .map(
                  (label) => Expanded(
                    child: Center(
                      child: Text(
                        label,
                        style: strategy.weekdayStyle(context, theme),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: strategy.weekdayGap()),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: strategy.gridMainAxisSpacing(),
            crossAxisSpacing: strategy.gridCrossAxisSpacing(),
            childAspectRatio: strategy.gridChildAspectRatio(),
            children: cells,
          ),
        ],
      ),
    );
  }

  Widget _buildTimePanel(BuildContext context) {
    final theme = context.animalIslandTheme;
    final strategy = AnimalDateTimePickerThemeStrategy.of(theme);
    final compact = MediaQuery.sizeOf(context).width < 720;
    final minuteValues = _minuteChoices(
      _normalizedMinuteStep(widget.minuteStep),
    );
    final systemHeader = strategy.buildSystemHeader(
      context,
      theme,
      label: 'TIME WINDOW',
      value:
          '${widget.value.hour.toString().padLeft(2, '0')}:${widget.value.minute.toString().padLeft(2, '0')}',
    );

    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        strategy.panelPadding(AnimalDateTimePickerPanelKind.time).top,
        12,
        strategy.panelPadding(AnimalDateTimePickerPanelKind.time).bottom,
      ),
      decoration: strategy.pickerPanelDecoration(theme),
      child: SizedBox(
        height: strategy.timePanelHeight(compact: compact),
        child: Column(
          children: [
            if (systemHeader != null) ...[
              systemHeader,
              const SizedBox(height: 6),
            ],
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _WheelPicker(
                      controller: _hourController,
                      values: List<int>.generate(24, (index) => index),
                      selectedValue: widget.value.hour,
                      enabled: widget.enabled,
                      formatter: (value) => value.toString().padLeft(2, '0'),
                      onSelected: _setHour,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      ':',
                      style: strategy.timeSeparatorStyle(
                        context,
                        theme,
                        compact: compact,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _WheelPicker(
                      controller: _minuteController,
                      values: minuteValues,
                      selectedValue: widget.value.minute,
                      enabled: widget.enabled,
                      formatter: (value) => value.toString().padLeft(2, '0'),
                      onSelected: _setMinute,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canDisplayMonth(DateTime month) {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 0);
    if (widget.firstDate != null &&
        end.isBefore(_dateOnly(widget.firstDate!))) {
      return false;
    }
    if (widget.lastDate != null && start.isAfter(_dateOnly(widget.lastDate!))) {
      return false;
    }
    return true;
  }
}

class _CalendarCell extends StatelessWidget {
  const _CalendarCell({
    required this.day,
    required this.selected,
    required this.today,
    required this.disabled,
    required this.onTap,
  });

  final int day;
  final bool selected;
  final bool today;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final strategy = AnimalDateTimePickerThemeStrategy.of(theme);

    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: AnimatedContainer(
        duration: AnimalIslandTokens.fast,
        curve: AnimalIslandTokens.motionCurve,
        decoration: strategy.calendarCellDecoration(
          theme,
          selected: selected,
          today: today,
        ),
        alignment: Alignment.center,
        child: Text(
          strategy.calendarCellText(day),
          style: strategy.calendarCellTextStyle(
            context,
            theme,
            selected: selected,
            disabled: disabled,
          ),
        ),
      ),
    );
  }
}

class _WheelPicker extends StatelessWidget {
  const _WheelPicker({
    required this.controller,
    required this.values,
    required this.selectedValue,
    required this.enabled,
    required this.formatter,
    required this.onSelected,
  });

  final FixedExtentScrollController controller;
  final List<int> values;
  final int selectedValue;
  final bool enabled;
  final String Function(int value) formatter;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final strategy = AnimalDateTimePickerThemeStrategy.of(theme);

    return Container(
      decoration: strategy.wheelDecoration(theme),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            top: 72,
            bottom: 72,
            child: IgnorePointer(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 14),
                decoration: strategy.wheelSelectionDecoration(theme),
              ),
            ),
          ),
          ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: 44,
            diameterRatio: 1.18,
            perspective: 0.003,
            squeeze: 0.94,
            physics: enabled
                ? const FixedExtentScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            onSelectedItemChanged: (index) => onSelected(values[index]),
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: values.length,
              builder: (context, index) {
                final value = values[index];
                final selected = value == selectedValue;
                return Center(
                  child: AnimatedDefaultTextStyle(
                    duration: AnimalIslandTokens.fast,
                    curve: AnimalIslandTokens.motionCurve,
                    style: Theme.of(context).textTheme.headlineMedium!
                        .copyWith(
                          color: selected ? theme.textPrimary : theme.textMuted,
                        )
                        .merge(
                          strategy.wheelTextStyle(
                            context,
                            theme,
                            selected: selected,
                          ),
                        ),
                    child: Text(formatter(value)),
                  ),
                );
              },
            ),
          ),
          IgnorePointer(
            child: Container(decoration: strategy.wheelFadeDecoration(theme)),
          ),
        ],
      ),
    );
  }
}

class _RoundActionButton extends StatelessWidget {
  const _RoundActionButton({
    required this.icon,
    required this.enabled,
    this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    return SizedBox(
      width: 42,
      child: AnimalButton(
        type: AnimalButtonType.defaultType,
        size: AnimalButtonSize.small,
        enabled: enabled,
        onPressed: enabled ? onTap : null,
        child: Icon(
          icon,
          size: 18,
          color: enabled ? theme.textPrimary : theme.textDisabled,
        ),
      ),
    );
  }
}

const List<String> _weekdayLabels = <String>['日', '一', '二', '三', '四', '五', '六'];
const List<String> _monthLabels = <String>[
  '1月',
  '2月',
  '3月',
  '4月',
  '5月',
  '6月',
  '7月',
  '8月',
  '9月',
  '10月',
  '11月',
  '12月',
];

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

DateTime _monthStart(DateTime value) => DateTime(value.year, value.month);

DateTime _clampToRange(
  DateTime value,
  DateTime? firstDate,
  DateTime? lastDate,
) {
  if (firstDate != null && value.isBefore(firstDate)) {
    return firstDate;
  }
  if (lastDate != null && value.isAfter(lastDate)) {
    return lastDate;
  }
  return value;
}

bool _isWithinRange(DateTime value, DateTime? firstDate, DateTime? lastDate) {
  final candidate = _dateOnly(value);
  final min = firstDate == null ? null : _dateOnly(firstDate);
  final max = lastDate == null ? null : _dateOnly(lastDate);
  if (min != null && candidate.isBefore(min)) {
    return false;
  }
  if (max != null && candidate.isAfter(max)) {
    return false;
  }
  return true;
}

bool _isSameMonth(DateTime left, DateTime right) =>
    left.year == right.year && left.month == right.month;

bool _isSameDate(DateTime left, DateTime right) =>
    left.year == right.year &&
    left.month == right.month &&
    left.day == right.day;

bool _isSameMoment(DateTime left, DateTime right) =>
    left.year == right.year &&
    left.month == right.month &&
    left.day == right.day &&
    left.hour == right.hour &&
    left.minute == right.minute;

int _normalizedMinuteStep(int step) => math.max(1, math.min(30, step));

List<int> _minuteChoices(int step) {
  final values = <int>{0, 15, 30, 45};
  for (var minute = 0; minute < 60; minute += step) {
    values.add(minute);
  }
  final sorted = values.toList()..sort();
  return sorted;
}

int _closestMinuteIndex(int minute, int step) {
  final values = _minuteChoices(_normalizedMinuteStep(step));
  var bestIndex = 0;
  var bestDelta = 1000;
  for (var index = 0; index < values.length; index++) {
    final delta = (values[index] - minute).abs();
    if (delta < bestDelta) {
      bestDelta = delta;
      bestIndex = index;
    }
  }
  return bestIndex;
}
