import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';

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

    return AnimatedContainer(
      duration: AnimalIslandTokens.base,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 20 : 36,
        vertical: compact ? 12 : 16,
      ),
      decoration: BoxDecoration(
        color: theme.isNes ? theme.surfaceRaised : null,
        gradient: theme.isNes
            ? null
            : LinearGradient(
                colors: <Color>[
                  Colors.white.withValues(
                    alpha: theme.mode == AnimalIslandThemeMode.day ? 1 : 0.2,
                  ),
                  theme.surface,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
        borderRadius: BorderRadius.circular(theme.isNes ? theme.radiusSm : 18),
        border: Border.all(
          color: theme.isNes ? theme.border : const Color(0xFFD4CFC3),
          width: 3,
        ),
        boxShadow: theme.isNes
            ? [
                BoxShadow(
                  color: theme.buttonShadow,
                  blurRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
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
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: theme.isNes ? theme.primary : theme.success,
                    fontWeight: FontWeight.w900,
                    fontSize: compact
                        ? AnimalIslandTokens.fontMicro
                        : AnimalIslandTokens.fontCaption,
                    letterSpacing: compact ? 1.1 : 1.3,
                  ),
                ),
                Text(
                  '${_months[_now.month - 1]} ${_now.day}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: theme.isNes
                        ? theme.textPrimary
                        : const Color(0xFF8B7355),
                    fontWeight: FontWeight.w800,
                    fontSize: compact
                        ? AnimalIslandTokens.fontBody
                        : AnimalIslandTokens.fontTitleSm,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: theme.isNes
                    ? theme.textPrimary
                    : const Color(0xFF8B7355),
                fontSize: compact ? 24 : 32,
                fontWeight: FontWeight.w900,
                letterSpacing: compact ? 1.1 : 1.5,
              ),
              children: [
                TextSpan(text: _now.hour.toString().padLeft(2, '0')),
                TextSpan(
                  text: _showColon ? ':' : ' ',
                  style: TextStyle(
                    color: theme.isNes
                        ? theme.focusYellow
                        : const Color(0xFF8B7355),
                  ),
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
