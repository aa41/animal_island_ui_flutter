import 'package:flutter/material.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';
import '../utils/animal_island_assets.dart';
import 'animal_component_dispatcher.dart';

class AnimalIcon extends StatelessWidget {
  const AnimalIcon({
    super.key,
    required this.name,
    this.size = 24,
    this.bounce = false,
    this.color,
  });

  final AnimalIconName name;
  final double size;
  final bool bounce;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AnimalComponentDispatcher.dispatch(
      context,
      animalIsland: (_) => _AnimalIslandIcon(
        name: name,
        size: size,
        bounce: bounce,
        color: color,
      ),
      nes: (_) =>
          _NesAnimalIcon(name: name, size: size, bounce: bounce, color: color),
      westworld: (_) => _WestworldAnimalIcon(
        name: name,
        size: size,
        bounce: bounce,
        color: color,
      ),
      guofeng: (_) => _GuofengAnimalIcon(
        name: name,
        size: size,
        bounce: bounce,
        color: color,
      ),
    );
  }
}

class _AnimalIslandIcon extends _ThemedAnimalIcon {
  const _AnimalIslandIcon({
    required super.name,
    required super.size,
    required super.bounce,
    required super.color,
  }) : super(gameStyle: AnimalIslandGameStyle.animalIsland);
}

class _NesAnimalIcon extends _ThemedAnimalIcon {
  const _NesAnimalIcon({
    required super.name,
    required super.size,
    required super.bounce,
    required super.color,
  }) : super(gameStyle: AnimalIslandGameStyle.nes8Bit);
}

class _WestworldAnimalIcon extends _ThemedAnimalIcon {
  const _WestworldAnimalIcon({
    required super.name,
    required super.size,
    required super.bounce,
    required super.color,
  }) : super(gameStyle: AnimalIslandGameStyle.westworld);
}

class _GuofengAnimalIcon extends _ThemedAnimalIcon {
  const _GuofengAnimalIcon({
    required super.name,
    required super.size,
    required super.bounce,
    required super.color,
  }) : super(gameStyle: AnimalIslandGameStyle.guofengDoodle);
}

abstract class _ThemedAnimalIcon extends StatefulWidget {
  const _ThemedAnimalIcon({
    required this.gameStyle,
    required this.name,
    required this.size,
    required this.bounce,
    required this.color,
  });

  final AnimalIslandGameStyle gameStyle;
  final AnimalIconName name;
  final double size;
  final bool bounce;
  final Color? color;

  @override
  State<_ThemedAnimalIcon> createState() => _ThemedAnimalIconState();
}

class _ThemedAnimalIconState extends State<_ThemedAnimalIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final filterQuality = theme.isNes ? FilterQuality.none : FilterQuality.high;
    Widget icon = Image.asset(
      AnimalIslandAssets.themedIcon(widget.gameStyle, widget.name),
      package: AnimalIslandAssets.package,
      width: widget.size,
      height: widget.size,
      fit: BoxFit.contain,
      alignment: Alignment.center,
      filterQuality: filterQuality,
      gaplessPlayback: true,
      isAntiAlias: !theme.isNes,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          widget.name.materialIcon,
          size: widget.size,
          color: widget.color ?? theme.textPrimary,
        );
      },
    );

    if (widget.color != null) {
      icon = ColorFiltered(
        colorFilter: ColorFilter.mode(widget.color!, BlendMode.srcIn),
        child: icon,
      );
    }

    final duration = theme.isWestworld
        ? theme.interactionDuration
        : AnimalIslandTokens.base;
    final curve = theme.isWestworld
        ? theme.interactionCurve
        : AnimalIslandTokens.motionCurve;

    Widget animated = AnimatedScale(
      scale: widget.bounce && _hovered ? (theme.isWestworld ? 1.06 : 1.1) : 1,
      duration: duration,
      curve: curve,
      child: icon,
    );

    if (!theme.isWestworld) {
      animated = Transform.translate(
        offset: Offset(0, widget.bounce && _hovered ? -2 : 0),
        child: AnimatedRotation(
          turns: widget.bounce && _hovered ? (-5 / 360) : 0,
          duration: duration,
          curve: curve,
          child: animated,
        ),
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: animated,
    );
  }
}

extension on AnimalIconName {
  IconData get materialIcon {
    return switch (this) {
      AnimalIconName.home => Icons.home_outlined,
      AnimalIconName.search => Icons.search,
      AnimalIconName.settings => Icons.settings_outlined,
      AnimalIconName.person => Icons.person_outline,
      AnimalIconName.favorite => Icons.favorite_border,
      AnimalIconName.star => Icons.star_border,
      AnimalIconName.notifications => Icons.notifications_none,
      AnimalIconName.mail => Icons.mail_outline,
      AnimalIconName.phone => Icons.phone_outlined,
      AnimalIconName.chat => Icons.chat_bubble_outline,
      AnimalIconName.cameraAlt ||
      AnimalIconName.camera => Icons.camera_alt_outlined,
      AnimalIconName.photo || AnimalIconName.image => Icons.image_outlined,
      AnimalIconName.musicNote => Icons.music_note,
      AnimalIconName.playArrow => Icons.play_arrow,
      AnimalIconName.pause => Icons.pause,
      AnimalIconName.stop => Icons.stop,
      AnimalIconName.volumeUp => Icons.volume_up_outlined,
      AnimalIconName.mic => Icons.mic_none,
      AnimalIconName.videocam => Icons.videocam_outlined,
      AnimalIconName.calendarToday => Icons.calendar_today_outlined,
      AnimalIconName.accessTime => Icons.access_time,
      AnimalIconName.alarm => Icons.alarm,
      AnimalIconName.locationOn => Icons.location_on_outlined,
      AnimalIconName.map => Icons.map_outlined,
      AnimalIconName.navigation => Icons.navigation_outlined,
      AnimalIconName.directionsCar => Icons.directions_car_outlined,
      AnimalIconName.flight ||
      AnimalIconName.helicopter => Icons.flight_outlined,
      AnimalIconName.train => Icons.train_outlined,
      AnimalIconName.directionsBike => Icons.directions_bike,
      AnimalIconName.shoppingCart ||
      AnimalIconName.shopping => Icons.shopping_cart_outlined,
      AnimalIconName.store => Icons.storefront_outlined,
      AnimalIconName.localOffer => Icons.local_offer_outlined,
      AnimalIconName.creditCard => Icons.credit_card,
      AnimalIconName.accountBalance ||
      AnimalIconName.miles => Icons.account_balance_outlined,
      AnimalIconName.work => Icons.work_outline,
      AnimalIconName.school => Icons.school_outlined,
      AnimalIconName.restaurant => Icons.restaurant_outlined,
      AnimalIconName.localCafe => Icons.local_cafe_outlined,
      AnimalIconName.localHospital => Icons.local_hospital_outlined,
      AnimalIconName.check => Icons.check,
      AnimalIconName.close => Icons.close,
      AnimalIconName.add => Icons.add,
      AnimalIconName.remove => Icons.remove,
      AnimalIconName.edit => Icons.edit_outlined,
      AnimalIconName.delete => Icons.delete_outline,
      AnimalIconName.download => Icons.download,
      AnimalIconName.upload => Icons.upload,
      AnimalIconName.share => Icons.share_outlined,
      AnimalIconName.refresh => Icons.refresh,
      AnimalIconName.arrowBack => Icons.arrow_back,
      AnimalIconName.arrowForward => Icons.arrow_forward,
      AnimalIconName.expandMore => Icons.expand_more,
      AnimalIconName.menu => Icons.menu,
      AnimalIconName.moreVert => Icons.more_vert,
      AnimalIconName.filterList => Icons.filter_list,
      AnimalIconName.sort => Icons.sort,
      AnimalIconName.visibility => Icons.visibility_outlined,
      AnimalIconName.lock => Icons.lock_outline,
      AnimalIconName.key => Icons.key,
      AnimalIconName.wifi => Icons.wifi,
      AnimalIconName.bluetooth => Icons.bluetooth,
      AnimalIconName.batteryFull => Icons.battery_full,
      AnimalIconName.cloud => Icons.cloud_outlined,
      AnimalIconName.cloudUpload => Icons.cloud_upload_outlined,
      AnimalIconName.computer => Icons.computer,
      AnimalIconName.smartphone => Icons.smartphone,
      AnimalIconName.tablet => Icons.tablet_mac,
      AnimalIconName.watch => Icons.watch_outlined,
      AnimalIconName.print => Icons.print_outlined,
      AnimalIconName.build || AnimalIconName.diy => Icons.build_outlined,
      AnimalIconName.construction => Icons.construction,
      AnimalIconName.brush => Icons.brush_outlined,
      AnimalIconName.palette || AnimalIconName.design => Icons.palette_outlined,
      AnimalIconName.code => Icons.code,
      AnimalIconName.bugReport => Icons.bug_report_outlined,
      AnimalIconName.lightbulb => Icons.lightbulb_outline,
      AnimalIconName.science => Icons.science_outlined,
      AnimalIconName.analytics => Icons.analytics_outlined,
      AnimalIconName.barChart => Icons.bar_chart,
      AnimalIconName.pets || AnimalIconName.critterpedia => Icons.pets,
      AnimalIconName.park => Icons.park_outlined,
      AnimalIconName.eco => Icons.eco_outlined,
      AnimalIconName.waterDrop => Icons.water_drop_outlined,
      AnimalIconName.beachAccess => Icons.beach_access_outlined,
      AnimalIconName.forest => Icons.forest_outlined,
      AnimalIconName.terrain => Icons.terrain_outlined,
      AnimalIconName.sailing => Icons.sailing_outlined,
      AnimalIconName.anchor => Icons.anchor,
      AnimalIconName.waves => Icons.waves,
      AnimalIconName.help => Icons.help_outline,
      AnimalIconName.info => Icons.info_outline,
      AnimalIconName.warning => Icons.warning_amber_outlined,
      AnimalIconName.error => Icons.error_outline,
      AnimalIconName.security => Icons.security,
      AnimalIconName.shield => Icons.shield_outlined,
      AnimalIconName.verified => Icons.verified_outlined,
      AnimalIconName.bookmark => Icons.bookmark_border,
      AnimalIconName.flag => Icons.flag_outlined,
      AnimalIconName.category ||
      AnimalIconName.variant => Icons.category_outlined,
    };
  }
}
