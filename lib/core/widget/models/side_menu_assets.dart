import '../../style/icon_sets.dart';

class SideMenuAssets {
  String title;
  final String icon;

  SideMenuAssets({required this.title, required this.icon});
}

List<SideMenuAssets> asetIcon = [
  SideMenuAssets(title: "Home", icon: homeIcon),
  SideMenuAssets(title: "History", icon: historyIcon),
  SideMenuAssets(title: "Settings", icon: settingIcon),
  SideMenuAssets(title: "About", icon: infoIcon),
];
