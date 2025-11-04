import 'package:flutter/material.dart';
import 'package:flutter_deer/common/constant/colors.dart';
import 'package:flutter_deer/pages/order/order_list_page.dart';
import 'package:flutter_deer/pages/order/provider/order_page_provider.dart';
import 'package:flutter_deer/util/theme_utils.dart';
import 'package:flutter_deer/widgets/load_image.dart';
import 'package:flutter_deer/widgets/my_flexible_space_bar.dart';
import 'package:flutter_deer/widgets/screen_utils.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final PageController _pageController = PageController(); // 页面控制器

  int _lastReportedPage = 0; // 最后一次报告的页面索引

  TabController? _tabController; // 选项卡控制器

  OrderPageProvider provider = OrderPageProvider(); // 订单页面数据提供者

  bool isDark = false; // 是否为深色模式

  @override
  void initState() {
    super.initState();
    // _tabController = TabController(vsync: this, length: 5);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isDark = context.isDark;

    return ChangeNotifierProvider<OrderPageProvider>(
      create: (context) => provider,
      child: Scaffold(
        body: Stack(
          // 堆叠容器
          children: [
            SafeArea(
              // 尺寸容器
              child: SizedBox(
                height: 105,
                width: double.infinity,
                child: isDark
                    ? null
                    : const DecoratedBox(
                        // 装饰容器
                        // 背景渐变效果
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colours.gradient_blue, Color(0xFF4647FA)],
                          ),
                        ),
                      ),
              ),
            ),
            // 嵌套滚动视图
            NestedScrollView(
              // 头部
              headerSliverBuilder: (context, innerBoxIsScrolled) =>
                  _sliverBuilder(context),
              // NotificationListener  监听滚动事件
              body: NotificationListener<ScrollNotification>(
                // 滚动事件回调函数
                onNotification: (ScrollNotification notification) {
                  // PageView的onPageChanged是监听ScrollUpdateNotification，会造成滑动中卡顿。这里修改为监听滚动结束再更新
                  if (notification.depth == 0 &&
                      notification is ScrollEndNotification) {
                    final PageMetrics metrics =
                        notification.metrics as PageMetrics;
                    final int currentPage = (metrics.page ?? 0).round();
                    if (currentPage != _lastReportedPage) {
                      _lastReportedPage = currentPage;
                      _onPageChange(currentPage);
                    }
                  }
                  return false;
                },
                // PageView 页面滑动视图
                child: PageView.builder(
                  key: const Key('pageView'), // 设置PageView的key，以便在重建时保持状态
                  itemCount: 5,
                  controller: _pageController,
                  itemBuilder: (_, index) => OrderListPage(index: index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _sliverBuilder(BuildContext context) {
    return [
      // SliverOverlapAbsorber 组件用于处理嵌套滚动视图中重叠的问题。它允许你将一个滑动视图中的滑动事件传递给另一个滑动视图，从而避免滑动冲突和重叠问题
      SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        // SliverAppBar 组件用于创建滑动时可以折叠的标题栏
        sliver: SliverAppBar(
          // 标题栏的背景颜色
          systemOverlayStyle: isDark ? ThemeUtils.light : ThemeUtils.dark,
          actions: [
            IconButton(
              icon: LoadAssetImage(
                'order/icon_search',
                width: 22.0,
                height: 22.0,
                color: ThemeUtils.getIconColor(context),
              ),
              tooltip: '搜索',
              onPressed: () {},
            ),
          ],
          backgroundColor: Colors.transparent, // 背景颜色设置为透明，以便可以看到下面的渐变效果
          elevation: 0.0, // 去掉阴影效果，使标题栏看起来更简洁
          centerTitle: true, // 标题居中显示
          expandedHeight: 100.0, // 不随着滑动隐藏标题
          pinned: true, // 固定标题栏，使其在滑动时不会消失
          // 自定义标题栏内容，这里使用了MyFlexibleSpaceBar组件来创建可折叠的标题栏
          flexibleSpace: MyFlexibleSpaceBar(
            background: isDark
                ? Container(height: 113.0, color: Colours.dark_bg_color)
                : LoadAssetImage(
                    'order/order_bg',
                    width: context.width,
                    height: 113.0,
                    fit: BoxFit.fill,
                  ),
            centerTitle: true, // 标题居中显示
            // 标题内边距
            titlePadding: const EdgeInsetsDirectional.only(
              start: 16.0,
              bottom: 14.0,
            ),
            collapseMode: CollapseMode.pin, // 固定标题栏，使其在滑动时不会消失
            // 标题
            title: Text(
              '订单',
              style: TextStyle(color: ThemeUtils.getIconColor(context)),
            ),
          ),
        ),
      ),
    ];
  }

  _onPageChange(int index) {
    provider.setIndex(index);
    // 这里没有指示器，所以缩短过渡动画时间，减少不必要的刷新
    _tabController?.animateTo(index, duration: Duration.zero);
  }
}
