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

enum AnimalMessageType { info, success, warning, error }

enum AnimalMessageDisplayMode { queue, replace }

enum AnimalToastPosition { top, center, bottom }

enum AnimalSnackbarPosition { top, bottom }

enum AnimalDateTimePickerMode { date, time, dateTime }

enum AnimalIconName {
  home,
  search,
  settings,
  person,
  favorite,
  star,
  notifications,
  mail,
  phone,
  chat,
  cameraAlt,
  photo,
  image,
  musicNote,
  playArrow,
  pause,
  stop,
  volumeUp,
  mic,
  videocam,
  calendarToday,
  accessTime,
  alarm,
  locationOn,
  map,
  navigation,
  directionsCar,
  flight,
  train,
  directionsBike,
  shoppingCart,
  store,
  localOffer,
  creditCard,
  accountBalance,
  work,
  school,
  restaurant,
  localCafe,
  localHospital,
  check,
  close,
  add,
  remove,
  edit,
  delete,
  download,
  upload,
  share,
  refresh,
  arrowBack,
  arrowForward,
  expandMore,
  menu,
  moreVert,
  filterList,
  sort,
  visibility,
  lock,
  key,
  wifi,
  bluetooth,
  batteryFull,
  cloud,
  cloudUpload,
  computer,
  smartphone,
  tablet,
  watch,
  print,
  build,
  construction,
  brush,
  palette,
  code,
  bugReport,
  lightbulb,
  science,
  analytics,
  barChart,
  pets,
  park,
  eco,
  waterDrop,
  beachAccess,
  forest,
  terrain,
  sailing,
  anchor,
  waves,
  help,
  info,
  warning,
  error,
  security,
  shield,
  verified,
  bookmark,
  flag,
  category,
  miles,
  camera,
  critterpedia,
  design,
  diy,
  helicopter,
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
  AnimalIconInfo(name: AnimalIconName.home, label: 'Home'),
  AnimalIconInfo(name: AnimalIconName.search, label: 'Search'),
  AnimalIconInfo(name: AnimalIconName.settings, label: 'Settings'),
  AnimalIconInfo(name: AnimalIconName.person, label: 'Person'),
  AnimalIconInfo(name: AnimalIconName.favorite, label: 'Favorite'),
  AnimalIconInfo(name: AnimalIconName.star, label: 'Star'),
  AnimalIconInfo(name: AnimalIconName.notifications, label: 'Notifications'),
  AnimalIconInfo(name: AnimalIconName.mail, label: 'Mail'),
  AnimalIconInfo(name: AnimalIconName.phone, label: 'Phone'),
  AnimalIconInfo(name: AnimalIconName.chat, label: 'Chat'),
  AnimalIconInfo(name: AnimalIconName.cameraAlt, label: 'Camera'),
  AnimalIconInfo(name: AnimalIconName.photo, label: 'Photo'),
  AnimalIconInfo(name: AnimalIconName.image, label: 'Image'),
  AnimalIconInfo(name: AnimalIconName.musicNote, label: 'Music'),
  AnimalIconInfo(name: AnimalIconName.playArrow, label: 'Play'),
  AnimalIconInfo(name: AnimalIconName.pause, label: 'Pause'),
  AnimalIconInfo(name: AnimalIconName.stop, label: 'Stop'),
  AnimalIconInfo(name: AnimalIconName.volumeUp, label: 'Volume'),
  AnimalIconInfo(name: AnimalIconName.mic, label: 'Mic'),
  AnimalIconInfo(name: AnimalIconName.videocam, label: 'Videocam'),
  AnimalIconInfo(name: AnimalIconName.calendarToday, label: 'Calendar'),
  AnimalIconInfo(name: AnimalIconName.accessTime, label: 'Time'),
  AnimalIconInfo(name: AnimalIconName.alarm, label: 'Alarm'),
  AnimalIconInfo(name: AnimalIconName.locationOn, label: 'Location'),
  AnimalIconInfo(name: AnimalIconName.map, label: 'Map'),
  AnimalIconInfo(name: AnimalIconName.navigation, label: 'Navigation'),
  AnimalIconInfo(name: AnimalIconName.directionsCar, label: 'Car'),
  AnimalIconInfo(name: AnimalIconName.flight, label: 'Flight'),
  AnimalIconInfo(name: AnimalIconName.train, label: 'Train'),
  AnimalIconInfo(name: AnimalIconName.directionsBike, label: 'Bike'),
  AnimalIconInfo(name: AnimalIconName.shoppingCart, label: 'Shopping Cart'),
  AnimalIconInfo(name: AnimalIconName.store, label: 'Store'),
  AnimalIconInfo(name: AnimalIconName.localOffer, label: 'Offer'),
  AnimalIconInfo(name: AnimalIconName.creditCard, label: 'Credit Card'),
  AnimalIconInfo(name: AnimalIconName.accountBalance, label: 'Bank'),
  AnimalIconInfo(name: AnimalIconName.work, label: 'Work'),
  AnimalIconInfo(name: AnimalIconName.school, label: 'School'),
  AnimalIconInfo(name: AnimalIconName.restaurant, label: 'Restaurant'),
  AnimalIconInfo(name: AnimalIconName.localCafe, label: 'Cafe'),
  AnimalIconInfo(name: AnimalIconName.localHospital, label: 'Hospital'),
  AnimalIconInfo(name: AnimalIconName.check, label: 'Check'),
  AnimalIconInfo(name: AnimalIconName.close, label: 'Close'),
  AnimalIconInfo(name: AnimalIconName.add, label: 'Add'),
  AnimalIconInfo(name: AnimalIconName.remove, label: 'Remove'),
  AnimalIconInfo(name: AnimalIconName.edit, label: 'Edit'),
  AnimalIconInfo(name: AnimalIconName.delete, label: 'Delete'),
  AnimalIconInfo(name: AnimalIconName.download, label: 'Download'),
  AnimalIconInfo(name: AnimalIconName.upload, label: 'Upload'),
  AnimalIconInfo(name: AnimalIconName.share, label: 'Share'),
  AnimalIconInfo(name: AnimalIconName.refresh, label: 'Refresh'),
  AnimalIconInfo(name: AnimalIconName.arrowBack, label: 'Arrow Back'),
  AnimalIconInfo(name: AnimalIconName.arrowForward, label: 'Arrow Forward'),
  AnimalIconInfo(name: AnimalIconName.expandMore, label: 'Expand More'),
  AnimalIconInfo(name: AnimalIconName.menu, label: 'Menu'),
  AnimalIconInfo(name: AnimalIconName.moreVert, label: 'More'),
  AnimalIconInfo(name: AnimalIconName.filterList, label: 'Filter'),
  AnimalIconInfo(name: AnimalIconName.sort, label: 'Sort'),
  AnimalIconInfo(name: AnimalIconName.visibility, label: 'Visibility'),
  AnimalIconInfo(name: AnimalIconName.lock, label: 'Lock'),
  AnimalIconInfo(name: AnimalIconName.key, label: 'Key'),
  AnimalIconInfo(name: AnimalIconName.wifi, label: 'Wifi'),
  AnimalIconInfo(name: AnimalIconName.bluetooth, label: 'Bluetooth'),
  AnimalIconInfo(name: AnimalIconName.batteryFull, label: 'Battery'),
  AnimalIconInfo(name: AnimalIconName.cloud, label: 'Cloud'),
  AnimalIconInfo(name: AnimalIconName.cloudUpload, label: 'Cloud Upload'),
  AnimalIconInfo(name: AnimalIconName.computer, label: 'Computer'),
  AnimalIconInfo(name: AnimalIconName.smartphone, label: 'Smartphone'),
  AnimalIconInfo(name: AnimalIconName.tablet, label: 'Tablet'),
  AnimalIconInfo(name: AnimalIconName.watch, label: 'Watch'),
  AnimalIconInfo(name: AnimalIconName.print, label: 'Print'),
  AnimalIconInfo(name: AnimalIconName.build, label: 'Build'),
  AnimalIconInfo(name: AnimalIconName.construction, label: 'Construction'),
  AnimalIconInfo(name: AnimalIconName.brush, label: 'Brush'),
  AnimalIconInfo(name: AnimalIconName.palette, label: 'Palette'),
  AnimalIconInfo(name: AnimalIconName.code, label: 'Code'),
  AnimalIconInfo(name: AnimalIconName.bugReport, label: 'Bug Report'),
  AnimalIconInfo(name: AnimalIconName.lightbulb, label: 'Lightbulb'),
  AnimalIconInfo(name: AnimalIconName.science, label: 'Science'),
  AnimalIconInfo(name: AnimalIconName.analytics, label: 'Analytics'),
  AnimalIconInfo(name: AnimalIconName.barChart, label: 'Bar Chart'),
  AnimalIconInfo(name: AnimalIconName.pets, label: 'Pets'),
  AnimalIconInfo(name: AnimalIconName.park, label: 'Park'),
  AnimalIconInfo(name: AnimalIconName.eco, label: 'Eco'),
  AnimalIconInfo(name: AnimalIconName.waterDrop, label: 'Water Drop'),
  AnimalIconInfo(name: AnimalIconName.beachAccess, label: 'Beach'),
  AnimalIconInfo(name: AnimalIconName.forest, label: 'Forest'),
  AnimalIconInfo(name: AnimalIconName.terrain, label: 'Terrain'),
  AnimalIconInfo(name: AnimalIconName.sailing, label: 'Sailing'),
  AnimalIconInfo(name: AnimalIconName.anchor, label: 'Anchor'),
  AnimalIconInfo(name: AnimalIconName.waves, label: 'Waves'),
  AnimalIconInfo(name: AnimalIconName.help, label: 'Help'),
  AnimalIconInfo(name: AnimalIconName.info, label: 'Info'),
  AnimalIconInfo(name: AnimalIconName.warning, label: 'Warning'),
  AnimalIconInfo(name: AnimalIconName.error, label: 'Error'),
  AnimalIconInfo(name: AnimalIconName.security, label: 'Security'),
  AnimalIconInfo(name: AnimalIconName.shield, label: 'Shield'),
  AnimalIconInfo(name: AnimalIconName.verified, label: 'Verified'),
  AnimalIconInfo(name: AnimalIconName.bookmark, label: 'Bookmark'),
  AnimalIconInfo(name: AnimalIconName.flag, label: 'Flag'),
  AnimalIconInfo(name: AnimalIconName.category, label: 'Category'),
];
