import 'package:flutter/material.dart';
import 'package:flutter_deer/res/colors.dart';
import 'package:flutter_deer/pages/order/order_list_page.dart';
import 'package:flutter_deer/pages/order/provider/order_page_provider.dart';
import 'package:flutter_deer/util/theme_utils.dart';
import 'package:flutter_deer/widgets/load_image.dart';
import 'package:flutter_deer/widgets/my_card.dart';
import 'package:flutter_deer/widgets/my_flexible_space_bar.dart';
import 'package:flutter_deer/widgets/screen_utils.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

/*
AutomaticKeepAliveClientMixin 可以实现页面在切换时保持状态不被重置，
SingleTickerProviderStateMixin 可以实现页面在切换时保持动画状态不被重置，
 */
class _OrderPageState extends State<OrderPage>
    with
        AutomaticKeepAliveClientMixin<OrderPage>,
        SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(); // 页面控制器

  int _lastReportedPage = 0; // 最后一次报告的页面索引

  TabController? _tabController; // 选项卡控制器

  OrderPageProvider provider = OrderPageProvider(); // 订单页面数据提供者

  bool isDark = false; // 是否为深色模式

  @override
  void initState() {
    super.initState();
    // 初始化选项卡控制器，vsync: this 表示使用当前State的TickerProvider
    _tabController = TabController(vsync: this, length: 5);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  // https://github.com/simplezhli/flutter_deer/issues/194
  @override
  // ignore: must_call_super
  void didChangeDependencies() {}

  @override
  Widget build(BuildContext context) {
    super.build(context);
    isDark = context.isDark;
    return ChangeNotifierProvider<OrderPageProvider>(
      create: (context) => provider,
      child: Scaffold(
        // 堆叠组件
        body: Stack(
          children: [
            // 嵌套滚动视图组件
            NestedScrollView(
              key: const Key('order_list'), // 设置NestedScrollView的key，以便在重建时保持状态
              physics: const ClampingScrollPhysics(), // 滚动物理属性，防止滑动到底部时可以继续滑动
              // 头部构建
              headerSliverBuilder: (context, innerBoxIsScrolled) =>
                  _headerSliverBuilder(context),
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

  // 头部构建
  List<Widget> _headerSliverBuilder(BuildContext context) {
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
      // SliverPersistentHeader 组件用于创建可以跟随滑动而固定的头部
      SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegate(
          DecoratedBox(
            decoration: BoxDecoration(
              color: isDark ? Colours.dark_bg_color : null,
              image: isDark
                  ? null
                  : DecorationImage(
                      image: AssetImage('assets/images/order/order_bg1.png'),
                      fit: BoxFit.fill,
                    ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ), // 设置左右内边距为16.0
              child: MyCard(
                child: Container(
                  height: 80.0,
                  padding: const EdgeInsets.only(top: 8.0), // 设置顶部内边距为8.0
                  child: TabBar(
                    labelPadding: EdgeInsets.zero,
                    controller: _tabController,
                    labelColor: context.isDark
                        ? Colours.dark_text
                        : Colours.text,
                    unselectedLabelColor: context.isDark
                        ? Colours.dark_text_gray
                        : Colours.text,
                    labelStyle: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ), // 设置选中标签的样式，字体大小设置为14.0，加粗显示
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 14.0,
                    ), // 设置未选中标签的样式，字体大小设置为14.0
                    indicatorColor: Colors.transparent, // 设置指示器的颜色为透明，不显示下划线
                    dividerColor: Colors.transparent, // 设置分割线的颜色为透明，不显示分割线
                    tabs: const [
                      _TabView(0, '新订单'),
                      _TabView(1, '待配送'),
                      _TabView(2, '待完成'),
                      _TabView(3, '已完成'),
                      _TabView(4, '已取消'),
                    ],
                    onTap: (index) {
                      // mounted 是用来判断当前组件是否已经挂载到树上了，如果没有挂载则不执行下面的代码。这样可以避免在组件销毁后还尝试更新UI导致的错误。
                      if (!mounted) {
                        return;
                      }
                      _pageController.jumpToPage(index);
                    },
                  ),
                ),
              ),
            ),
          ),
          80.0,
        ),
      ),
    ];
  }

  _onPageChange(int index) {
    provider.setIndex(index);
    // 这里没有指示器，所以缩短过渡动画时间，减少不必要的刷新
    _tabController?.animateTo(index, duration: Duration.zero);
  }

  @override
  bool get wantKeepAlive => true;
}

// SliverPersistentHeaderDelegate 是一个抽象类，用于创建可以跟随滑动而固定的头部
class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate(this.widget, this.height);

  final Widget widget;
  final double height;

  // minHeight 和 maxHeight 的值设置为相同时，header就不会收缩了
  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return widget;
  }

  // 是否需要重建头部控件，这里设置为true，表示每次滑动都会重新构建头部控件
  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return true;
  }
}

// 订单页头部标签

List<List<String>> img = [
  ['order/xdd_s', 'order/xdd_n'],
  ['order/dps_s', 'order/dps_n'],
  ['order/dwc_s', 'order/dwc_n'],
  ['order/ywc_s', 'order/ywc_n'],
  ['order/yqx_s', 'order/yqx_n'],
];

// 夜间模式图标列表
List<List<String>> darkImg = [
  ['order/dark/icon_xdd_s', 'order/dark/icon_xdd_n'],
  ['order/dark/icon_dps_s', 'order/dark/icon_dps_n'],
  ['order/dark/icon_dwc_s', 'order/dark/icon_dwc_n'],
  ['order/dark/icon_ywc_s', 'order/dark/icon_ywc_n'],
  ['order/dark/icon_yqx_s', 'order/dark/icon_yqx_n'],
];

// 订单页头部标签控件
class _TabView extends StatelessWidget {
  const _TabView(this.index, this.text);

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    final List<List<String>> imgList = context.isDark ? darkImg : img;
    return Stack(
      children: [
        // 标签控件
        Container(
          width: 46.0,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              LoadAssetImage(
                context.select<OrderPageProvider, int>(
                          (value) => value.index,
                        ) ==
                        index
                    ? imgList[index][0]
                    : imgList[index][1],
                width: 24.0,
                height: 24.0,
              ),
              SizedBox(height: 4),
              Text(text),
            ],
          ),
        ),
        // 小红点控件，只在前三项显示
        Positioned(
          right: 0.0,
          child: index < 3
              ? DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(11.0),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.5,
                      vertical: 2.0,
                    ),
                    child: Text(
                      '10',
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ),
      ],
    );
  }
}
