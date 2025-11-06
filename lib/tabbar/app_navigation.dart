import 'package:flutter/material.dart';
import 'package:flutter_deer/res/colors.dart';
import 'package:flutter_deer/pages/goods/goods_page.dart';
import 'package:flutter_deer/pages/order/order_page.dart';
import 'package:flutter_deer/pages/shop/shop_page.dart';
import 'package:flutter_deer/pages/statistics/statistics_page.dart';
import 'package:flutter_deer/tabbar/app_bottom_bar.dart';
import 'package:flutter_deer/widgets/load_image.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _index = 0;
  final PageController _ctrl = PageController();

  static const double _imageSize = 25.0;

  List<MenuData> get menus => [
    MenuData(
      label: '订单',
      icon: LoadAssetImage(
        'home/icon_order',
        width: _imageSize,
        color: _index == 0 ? Colours.app_main : Colours.unselected_item_color,
      ),
    ),
    MenuData(
      label: '商品',
      icon: LoadAssetImage(
        'home/icon_commodity',
        width: _imageSize,
        color: _index == 1 ? Colours.app_main : Colours.unselected_item_color,
      ),
    ),
    MenuData(
      label: '统计',
      icon: LoadAssetImage(
        'home/icon_statistics',
        width: _imageSize,
        color: _index == 2 ? Colours.app_main : Colours.unselected_item_color,
      ),
    ),
    MenuData(
      label: '店铺',
      icon: LoadAssetImage(
        'home/icon_shop',
        width: _imageSize,
        color: _index == 3 ? Colours.app_main : Colours.unselected_item_color,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(),
      bottomNavigationBar: AppBottomBar(
        currentIndex: _index,
        menus: menus,
        onItemTap: _onChangePage,
      ),
    );
  }

  void _onChangePage(int index) {
    _ctrl.jumpToPage(index);
    setState(() {
      _index = index;
    });
  }

  Widget _buildContent() {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _ctrl,
      children: [OrderPage(), GoodsPage(), StatisticsPage(), ShopPage()],
    );
  }
}
