import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';
import '../utils/animal_island_assets.dart';

class AnimalPhone extends StatefulWidget {
  const AnimalPhone({super.key});

  @override
  State<AnimalPhone> createState() => _AnimalPhoneState();
}

class _AnimalPhoneState extends State<AnimalPhone> {
  late DateTime _now = DateTime.now();
  Timer? _timer;
  bool _showColon = true;

  static const List<_PhoneApp> _apps = <_PhoneApp>[
    _PhoneApp(
      id: 'camera',
      asset: 'icon-camera',
      color: Color(0xFFB77DEE),
      hasNewMessage: true,
    ),
    _PhoneApp(
      id: 'app',
      asset: 'icon-miles',
      color: Color(0xFF889DF0),
      offset: true,
    ),
    _PhoneApp(
      id: 'critterpedia',
      asset: 'icon-critterpedia',
      color: Color(0xFFF7CD67),
      widthFactor: 0.85,
    ),
    _PhoneApp(id: 'diy', asset: 'icon-diy', color: Color(0xFFE59266)),
    _PhoneApp(id: 'shopping', asset: 'icon-design', color: Color(0xFFF8A6B2)),
    _PhoneApp(
      id: 'variant',
      asset: 'icon-map',
      color: Color(0xFF82D5BB),
      hasNewMessage: true,
      widthFactor: 0.72,
    ),
    _PhoneApp(
      id: 'design',
      asset: 'icon-variant',
      color: Color(0xFF8AC68A),
      widthFactor: 0.65,
    ),
    _PhoneApp(id: 'map', asset: 'icon-helicopter', color: Color(0xFFFC736D)),
    _PhoneApp(id: 'chat', asset: 'icon-chat', color: Color(0xFFD1DA49)),
  ];

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
    final hours = _now.hour;
    final minutes = _now.minute.toString().padLeft(2, '0');
    final ampm = hours >= 12 ? 'PM' : 'AM';
    final displayHours = (hours % 12 == 0 ? 12 : hours % 12).toString();

    return SizedBox(
      width: 527,
      height: 788,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFF8F4E8),
          borderRadius: BorderRadius.circular(136),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(70, 40, 70, 31),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        AnimalIslandAssets.iconWifi,
                        package: AnimalIslandAssets.package,
                        width: 79,
                        height: 29,
                      ),
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.4,
                                color: const Color(0xFFDDDBCC),
                              ),
                          children: [
                            TextSpan(text: displayHours),
                            TextSpan(text: _showColon ? ':' : ' '),
                            TextSpan(text: minutes),
                            TextSpan(text: ampm),
                          ],
                        ),
                      ),
                      SvgPicture.asset(
                        AnimalIslandAssets.iconLocation,
                        package: AnimalIslandAssets.package,
                        width: 36,
                        height: 36,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    theme.mode == AnimalIslandThemeMode.day
                        ? 'Welcome!'
                        : 'Good evening!',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF725C4E),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _apps.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 32,
                    crossAxisSpacing: 32,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) =>
                      _PhoneTile(app: _apps[index]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 74),
              child: SvgPicture.asset(
                AnimalIslandAssets.iconPage,
                package: AnimalIslandAssets.package,
                width: 65,
                height: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhoneTile extends StatefulWidget {
  const _PhoneTile({required this.app});

  final _PhoneApp app;

  @override
  State<_PhoneTile> createState() => _PhoneTileState();
}

class _PhoneTileState extends State<_PhoneTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final iconPath = AnimalIslandAssets.iconMap[widget.app.asset]!;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Container(
        decoration: BoxDecoration(
          color: widget.app.color,
          borderRadius: BorderRadius.circular(45),
        ),
        child: Stack(
          children: [
            if (widget.app.hasNewMessage)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF544A),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFF8F4E8),
                      width: 5,
                    ),
                  ),
                ),
              ),
            Center(
              child: Transform.translate(
                offset: Offset(0, widget.app.offset ? 15 : 0),
                child: AnimatedRotation(
                  turns: _hovered ? (-4 / 360) : 0,
                  duration: AnimalIslandTokens.base,
                  curve: AnimalIslandTokens.motionCurve,
                  child: AnimatedScale(
                    scale: _hovered ? 1.1 : 1,
                    duration: AnimalIslandTokens.base,
                    curve: AnimalIslandTokens.motionCurve,
                    child: SvgPicture.asset(
                      iconPath,
                      package: AnimalIslandAssets.package,
                      width: 123 * widget.app.widthFactor,
                      height: 123 * widget.app.widthFactor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhoneApp {
  const _PhoneApp({
    required this.id,
    required this.asset,
    required this.color,
    this.offset = false,
    this.hasNewMessage = false,
    this.widthFactor = 0.7,
  });

  final String id;
  final String asset;
  final Color color;
  final bool offset;
  final bool hasNewMessage;
  final double widthFactor;
}
