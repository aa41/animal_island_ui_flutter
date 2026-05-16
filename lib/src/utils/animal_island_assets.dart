import 'package:flutter/material.dart';

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

  static const String demoHomeBackground =
      'assets/animal_island/demo/img/home_bg.webp';
  static const String demoContentBackground =
      'assets/animal_island/demo/img/content_bg_pc.jpg';
  static const String demoGuideLine =
      'assets/animal_island/demo/img/guide-bg-line.webp';
  static const String demoMenuBackground =
      'assets/animal_island/demo/img/menu_bg.svg';
  static const String demoAnimalIcon =
      'assets/animal_island/demo/img/animal_icon.png';

  static const String nookPhoneNook1 =
      'assets/animal_island/demo/img/nook-phone/nook1.svg';
  static const String nookPhoneNook2 =
      'assets/animal_island/demo/img/nook-phone/nook2.svg';
  static const String nookPhoneShopping =
      'assets/animal_island/demo/img/nook-phone/Property-Shopping.svg';
  static const String nookPhoneCamera =
      'assets/animal_island/demo/img/nook-phone/Property-Camera.svg';
  static const String nookPhoneChat =
      'assets/animal_island/demo/img/nook-phone/Property-Chat.svg';
  static const String nookPhoneRecipes =
      'assets/animal_island/demo/img/nook-phone/Property-Recipes.svg';
  static const String nookPhoneHelicopter =
      'assets/animal_island/demo/img/nook-phone/Property-Helicopter.svg';

  static const String iconWifi = 'assets/animal_island/src/img/icons/wifi.svg';
  static const String iconLocation =
      'assets/animal_island/src/img/icons/location.svg';
  static const String iconPage = 'assets/animal_island/src/img/icons/page.svg';

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

  static String packageAsset(String path) => path;

  static ImageProvider<Object> raster(String path) =>
      AssetImage(path, package: package);
}
