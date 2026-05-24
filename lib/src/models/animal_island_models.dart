import 'package:flutter/widgets.dart';

enum AnimalButtonType { primary, defaultType, dashed, text, link }

enum AnimalButtonSize { small, middle, large }

enum AnimalInputSize { small, middle, large }

enum AnimalInputStatus { error, warning }

enum AnimalSwitchSize { small, normal }

enum AnimalCardType { defaultType, title, dashed }

enum AnimalFooterType { sea, tree }

enum AnimalDividerType {
  lineBrown,
  lineTeal,
  lineWhite,
  lineYellow,
  waveYellow,
}

enum AnimalCheckboxSize { small, middle, large }

enum AnimalCheckboxDirection { horizontal, vertical }

enum AnimalLoadMoreState { idle, loading, noMore, error }

enum AnimalStatusTone { loading, error, empty }

enum AnimalDateTimePickerMode { date, time, dateTime }

enum AnimalIconName {
  miles,
  camera,
  chat,
  critterpedia,
  design,
  diy,
  helicopter,
  map,
  shopping,
  variant,
}

class AnimalSelectOption {
  const AnimalSelectOption({required this.keyId, required this.label});

  final String keyId;
  final String label;
}

class AnimalCheckboxOption<T> {
  const AnimalCheckboxOption({
    required this.value,
    required this.label,
    this.disabled = false,
  });

  final T value;
  final Widget label;
  final bool disabled;
}

class AnimalTabItem {
  const AnimalTabItem({
    required this.id,
    required this.label,
    required this.child,
  });

  final String id;
  final Widget label;
  final Widget child;
}

class AnimalIconInfo {
  const AnimalIconInfo({required this.name, required this.label});

  final AnimalIconName name;
  final String label;
}

class AnimalStatusConfig {
  const AnimalStatusConfig({
    required this.title,
    required this.message,
    required this.badge,
    required this.fill,
    required this.accent,
    required this.border,
    required this.shadow,
    required this.foreground,
    required this.badgeColor,
    required this.badgeForeground,
  });

  final String title;
  final String message;
  final String badge;
  final Color fill;
  final Color accent;
  final Color border;
  final Color shadow;
  final Color foreground;
  final Color badgeColor;
  final Color badgeForeground;
}

const List<AnimalIconInfo> kAnimalIslandIconList = <AnimalIconInfo>[
  AnimalIconInfo(name: AnimalIconName.miles, label: 'NookMiles'),
  AnimalIconInfo(name: AnimalIconName.camera, label: 'Camera'),
  AnimalIconInfo(name: AnimalIconName.chat, label: 'Chat'),
  AnimalIconInfo(name: AnimalIconName.critterpedia, label: 'Critterpedia'),
  AnimalIconInfo(name: AnimalIconName.design, label: 'Design'),
  AnimalIconInfo(name: AnimalIconName.diy, label: 'DIY'),
  AnimalIconInfo(name: AnimalIconName.helicopter, label: 'Helicopter'),
  AnimalIconInfo(name: AnimalIconName.map, label: 'Map'),
  AnimalIconInfo(name: AnimalIconName.shopping, label: 'Shopping'),
  AnimalIconInfo(name: AnimalIconName.variant, label: 'Variant'),
];
