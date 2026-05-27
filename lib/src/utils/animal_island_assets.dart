import 'package:flutter/material.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';

abstract final class AnimalIslandAssets {
  static const String package = 'animal_island_ui_flutter';

  static const String iconLeaf =
      'assets/animal_island/src/img/icons/icon-leaf.png';
  static const String cursorHand =
      'assets/animal_island/src/img/cursor/cursor-icon.png';
  static const String selectCursor =
      'assets/animal_island/src/img/cursor/select-cursor.svg';

  static const String dividerBrown =
      'assets/animal_island/src/img/dividers/divider-line-brown.svg';
  static const String dividerTeal =
      'assets/animal_island/src/img/dividers/divider-line-teal.svg';
  static const String dividerWhite =
      'assets/animal_island/src/img/dividers/divider-line-white.png';
  static const String dividerYellow =
      'assets/animal_island/src/img/dividers/divider-line-yellow.svg';
  static const String dividerWave =
      'assets/animal_island/src/img/dividers/wave-yellow.svg';

  static const String footerSea =
      'assets/animal_island/src/img/footer/footer-sea.svg';
  static const String footerTree =
      'assets/animal_island/src/img/footer/footer-tree.webp';
  static const String nesFooterTree =
      'assets/animal_island/src/img/nes/footer/tree.png';
  static const String nesFooterSea =
      'assets/animal_island/src/img/nes/footer/sea.png';
  static const String westworldFooterTree =
      'assets/animal_island/src/img/westworld/footer/tree.png';
  static const String westworldFooterSea =
      'assets/animal_island/src/img/westworld/footer/sea.png';
  static const String guofengFooterTree =
      'assets/animal_island/src/img/guofeng/footer/tree.png';
  static const String guofengFooterSea =
      'assets/animal_island/src/img/guofeng/footer/sea.png';

  static const String animalStatusLoading =
      'assets/animal_island/src/img/animal/status/loading.png';
  static const String animalStatusEmpty =
      'assets/animal_island/src/img/animal/status/empty.png';
  static const String animalStatusError =
      'assets/animal_island/src/img/animal/status/error.png';

  static const String guofengStatusLoading =
      'assets/animal_island/src/img/guofeng/status/loading.png';
  static const String guofengStatusEmpty =
      'assets/animal_island/src/img/guofeng/status/empty.png';
  static const String guofengStatusError =
      'assets/animal_island/src/img/guofeng/status/error.png';

  static const String nesStatusLoading =
      'assets/animal_island/src/img/nes/status/loading.png';
  static const String nesStatusEmpty =
      'assets/animal_island/src/img/nes/status/empty.png';
  static const String nesStatusError =
      'assets/animal_island/src/img/nes/status/error.png';

  static const Map<String, String> iconMap = <String, String>{
    'icon-miles': 'assets/animal_island/src/img/icons/icon-miles.svg',
    'icon-camera': 'assets/animal_island/src/img/icons/icon-camera.svg',
    'icon-chat': 'assets/animal_island/src/img/icons/icon-chat.svg',
    'icon-critterpedia':
        'assets/animal_island/src/img/icons/icon-critterpedia.svg',
    'icon-design': 'assets/animal_island/src/img/icons/icon-design.svg',
    'icon-diy': 'assets/animal_island/src/img/icons/icon-diy.svg',
    'icon-helicopter': 'assets/animal_island/src/img/icons/icon-helicopter.svg',
    'icon-map': 'assets/animal_island/src/img/icons/icon-map.svg',
    'icon-shopping': 'assets/animal_island/src/img/icons/icon-shopping.svg',
    'icon-variant': 'assets/animal_island/src/img/icons/icon-variant.svg',
  };

  static String themedIcon(
    AnimalIslandGameStyle gameStyle,
    AnimalIconName name,
  ) {
    final themeDir = switch (gameStyle) {
      AnimalIslandGameStyle.nes8Bit => 'nes',
      AnimalIslandGameStyle.westworld => 'westworld',
      AnimalIslandGameStyle.guofengDoodle => 'guofeng',
      AnimalIslandGameStyle.animalIsland => 'animal',
    };
    return 'assets/animal_island/src/img/icons/$themeDir/${name.iconAssetName}.png';
  }

  static String packageAsset(String path) => path;

  static ImageProvider<Object> raster(String path) =>
      AssetImage(path, package: package);
}

extension AnimalIconNameAsset on AnimalIconName {
  String get iconAssetName {
    return switch (this) {
      AnimalIconName.cameraAlt || AnimalIconName.camera => 'camera_alt',
      AnimalIconName.musicNote => 'music_note',
      AnimalIconName.playArrow => 'play_arrow',
      AnimalIconName.volumeUp => 'volume_up',
      AnimalIconName.calendarToday => 'calendar_today',
      AnimalIconName.accessTime => 'access_time',
      AnimalIconName.locationOn => 'location_on',
      AnimalIconName.directionsCar => 'directions_car',
      AnimalIconName.directionsBike => 'directions_bike',
      AnimalIconName.shoppingCart || AnimalIconName.shopping => 'shopping_cart',
      AnimalIconName.localOffer => 'local_offer',
      AnimalIconName.creditCard => 'credit_card',
      AnimalIconName.accountBalance ||
      AnimalIconName.miles => 'account_balance',
      AnimalIconName.localCafe => 'local_cafe',
      AnimalIconName.localHospital => 'local_hospital',
      AnimalIconName.arrowBack => 'arrow_back',
      AnimalIconName.arrowForward => 'arrow_forward',
      AnimalIconName.expandMore => 'expand_more',
      AnimalIconName.moreVert => 'more_vert',
      AnimalIconName.filterList => 'filter_list',
      AnimalIconName.batteryFull => 'battery_full',
      AnimalIconName.cloudUpload => 'cloud_upload',
      AnimalIconName.bugReport => 'bug_report',
      AnimalIconName.barChart => 'bar_chart',
      AnimalIconName.waterDrop => 'water_drop',
      AnimalIconName.beachAccess => 'beach_access',
      AnimalIconName.critterpedia => 'pets',
      AnimalIconName.design => 'palette',
      AnimalIconName.diy => 'build',
      AnimalIconName.helicopter => 'flight',
      AnimalIconName.variant => 'category',
      _ => name,
    };
  }
}
