import 'package:flutter/material.dart';

class MenuData {
  // 标题
  final String label;

  // 图标
  final Widget icon;

  const MenuData({required this.label, required this.icon});
}

class AppBottomBar extends StatelessWidget {
  final int currentIndex;
  final List<MenuData> menus;
  final ValueChanged<int>? onItemTap;

  const AppBottomBar({
    super.key,
    required this.menus,
    this.currentIndex = 0,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex, // 当前选中项的索引
      type: BottomNavigationBarType.fixed,
      elevation: 5.0, // 阴影高度
      iconSize: 21.0, // 图标大小
      selectedItemColor: Theme.of(context).primaryColor, // 选中颜色
      items: menus.map(_buildItemByMenuMeta).toList(),
      onTap: onItemTap, // 点击事件回调
    );
  }

  BottomNavigationBarItem _buildItemByMenuMeta(MenuData menu) {
    return BottomNavigationBarItem(label: menu.label, icon: menu.icon);
  }
}
