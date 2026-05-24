import 'dart:async';

import 'package:flutter/material.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';
import 'theme_strategies/animal_time_theme_strategy.dart';

class AnimalTime extends StatefulWidget {
  const AnimalTime({super.key});

  @override
  State<AnimalTime> createState() => _AnimalTimeState();
}

class _AnimalTimeState extends State<AnimalTime> {
  static const List<String> _weekdays = <String>[
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  static const List<String> _months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  late DateTime _now = DateTime.now();
  Timer? _timer;
  bool _showColon = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _now = DateTime.now();
        _showColon = !_showColon;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final compact = MediaQuery.sizeOf(context).width < 768;
    final strategy = AnimalTimeThemeStrategy.of(theme);

    return AnimatedContainer(
      duration: AnimalIslandTokens.base,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 20 : 36,
        vertical: compact ? 12 : 16,
      ),
      decoration: strategy.decoration(theme),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(right: compact ? 12 : 24),
            margin: EdgeInsets.only(right: compact ? 12 : 24),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: theme.border.withValues(alpha: 0.35),
                  width: 3,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _weekdays[_now.weekday % 7].toUpperCase(),
                  style: strategy.weekdayStyle(context, theme, compact: compact),
                ),
                Text(
                  '${_months[_now.month - 1]} ${_now.day}',
                  style: strategy.dateStyle(context, theme, compact: compact),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              style: strategy.timeStyle(context, theme, compact: compact),
              children: [
                TextSpan(text: _now.hour.toString().padLeft(2, '0')),
                TextSpan(
                  text: _showColon ? ':' : ' ',
                  style: strategy.colonStyle(context, theme),
                ),
                TextSpan(text: _now.minute.toString().padLeft(2, '0')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
