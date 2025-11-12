import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

typedef ApiCallback =
    Future<Map<String, dynamic>> Function(int pageNum, int pageSize);
typedef CustomChildBuilder =
    Widget Function(BuildContext context, List<dynamic> dataList);

class RefreshList extends StatefulWidget {
  final ApiCallback apiCallback; // API 回调函数，用于获取数据列表
  final Widget Function(BuildContext context, dynamic item)?
  itemBuilder; // 构建列表项
  final Widget emptyWidget; // 空数据时的显示组件
  final CustomChildBuilder? childBuilder; // 自定义 child 构建方法

  const RefreshList({
    super.key,
    required this.apiCallback,
    this.emptyWidget = const Center(child: Text("暂无数据")),
    this.itemBuilder,
    this.childBuilder,
  });

  @override
  State<RefreshList> createState() => _RefreshListState();
}

class _RefreshListState extends State<RefreshList> {
  int pageNum = 1; // 当前页码
  final int pageSize = 10; // 每页数
  int totalPages = 0; // 总页数
  bool isLoading = false; // 是否正在加载中
  List<dynamic> dataList = []; // 数据列表

  @override
  void initState() {
    super.initState();
    fetchData(isRefresh: true);
  }

  void onLoad() async {
    if (pageNum >= totalPages) return;
    setState(() {
      pageNum++;
    });
    await fetchData();
  }

  Future<void> onRefresh() async {
    dataList.clear();
    setState(() {
      pageNum = 1;
    });
    await fetchData(isRefresh: true);
  }

  Future<void> fetchData({bool isRefresh = false}) async {
    if (isLoading) return; // 防止重复加载

    setState(() {
      isLoading = true; // 开始加载
    });

    try {
      final response = await widget.apiCallback(pageNum, pageSize);

      final dynamic rawData = response['data'] ?? []; // 获取原始数据
      final List<dynamic> newData = rawData is List
          ? rawData
          : [rawData]; // 转为列表

      setState(() {
        if (isRefresh) {
          dataList = newData;
        } else {
          dataList.addAll(newData);
        }
        totalPages = response['pages'] ?? 1; // 设置总页数
      });
    } catch (e) {
      debugPrint("加载数据失败: $e");
    } finally {
      setState(() {
        isLoading = false; // 加载结束
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      onRefresh: onRefresh,
      onLoad: onLoad,
      child: widget.childBuilder != null
          ? widget.childBuilder!(context, dataList)
          : (dataList.isEmpty
                ? widget.emptyWidget
                : ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      return widget.itemBuilder!(context, dataList[index]);
                    },
                  )),
    );
  }
}
