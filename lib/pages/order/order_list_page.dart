import 'package:flutter/material.dart';
import 'package:flutter_deer/pages/order/provider/order_page_provider.dart';
import 'package:flutter_deer/pages/order/widget/order_item.dart';
import 'package:flutter_deer/pages/order/widget/order_tag_item.dart';
import 'package:flutter_deer/util/change_notifier_manage.dart';
import 'package:provider/provider.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key, required this.index});

  final int index;

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

// AutomaticKeepAliveClientMixin 实现 keepAlive 保持状态，避免重建页面，保持状态不变。

class _OrderListPageState extends State<OrderListPage>
    with
        AutomaticKeepAliveClientMixin<OrderListPage>,
        ChangeNotifierMixin<OrderListPage> {
  final ScrollController _controller = ScrollController();

  int _page = 1;
  int _index = 0;
  List<String> _list = [];

  @override
  void initState() {
    super.initState();
    _index = widget.index;
    _onRefresh();
  }

  @override
  Map<ChangeNotifier, List<VoidCallback>?>? changeNotifier() {
    return {_controller: null};
  }

  @override
  Widget build(BuildContext context) {
    // NotificationListener 监听通知

    return NotificationListener(
      // RefreshIndicator 下拉刷新控件
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        displacement: 120.0, // 默认40， 多添加的80为Header高度
        child: Consumer<OrderPageProvider>(
          builder: (_, provider, child) {
            return CustomScrollView(
              /// 这里指定controller可以与外层NestedScrollView的滚动分离，避免一处滑动，5个Tab中的列表同步滑动。
              /// 这种方法的缺点是会重新layout列表
              controller: _index != provider.index ? _controller : null,
              key: PageStorageKey<String>('$_index'),
              slivers: <Widget>[
                SliverOverlapInjector(
                  ///SliverAppBar的expandedHeight高度,避免重叠
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                    context,
                  ),
                ),
                child!,
              ],
            );
          },
          child: SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: _list.isEmpty
                ? SliverFillRemaining(child: Text('无数据'))
                : SliverList(
                    delegate: SliverChildBuilderDelegate((
                      BuildContext context,
                      int index,
                    ) {
                      return index < _list.length
                          ? (index % 5 == 0
                                ? const OrderTagItem(
                                    date: '2021年2月5日',
                                    orderTotal: 4,
                                  )
                                : OrderItem(
                                    key: Key('order_item_$index'),
                                    index: index,
                                    tabIndex: _index,
                                  ))
                          : const SizedBox();
                    }, childCount: _list.length + 1),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _page = 1;
        _list = List.generate(10, (i) => 'newItem：$i');
      });
    });
  }

  @override
  bool get wantKeepAlive => true;
}
