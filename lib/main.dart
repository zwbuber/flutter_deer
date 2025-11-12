import 'package:flutter/material.dart';
import 'package:flutter_deer/common/provider/theme_provider.dart';
import 'package:flutter_deer/pages/login/login_page.dart';
import 'package:flutter_deer/pages/order/order_page.dart';
import 'package:flutter_deer/tabbar/app_navigation.dart';
import 'package:flutter_deer/util/device_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

// 应用程序入口
void main() async {
  // 确保初始化完成
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化设备信息
  await Device.initDeviceInfo();

  // 运行应用程序
  runApp(const MyApp());
}

// 创建 MyApp 类继承自 StatelessWidget
class MyApp extends StatelessWidget {
  const MyApp({super.key, this.theme});

  final ThemeData? theme;

  @override
  Widget build(BuildContext context) {
    final Widget app = MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // 主题配置
      ],
      child: Consumer<ThemeProvider>(
        builder: (_, ThemeProvider provider, _) {
          return _buildMaterialApp(provider);
        },
      ),
    );

    // OKToast 配置
    return OKToast(
      backgroundColor: Colors.black54, // 背景颜色
      textPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 10.0,
      ), // 文本间距
      radius: 20.0, // 圆角大小
      position: ToastPosition.bottom, // 显示位置
      child: app, // 子组件配置
    );
  }

  Widget _buildMaterialApp(ThemeProvider provider) {
    // 路由路径匹配
    Route<dynamic>? getRoute(RouteSettings settings) {
      // Map arg = {};
      // if (settings.arguments != null) {
      //   arg = settings.arguments as Map;
      // }

      Map<String, WidgetBuilder> routes = {
        '/': (_) => const AppNavigation(), // 首页
        '/login': (BuildContext context) => LoginPage(), // 登录页
        '/order': (BuildContext context) => OrderPage(), // 订单页
      };

      var widget = routes[settings.name];

      if (widget != null) {
        return MaterialPageRoute<void>(settings: settings, builder: widget);
      }

      return null;
    }

    return MaterialApp(
      title: 'Flutter Deer', // 应用名称
      debugShowCheckedModeBanner: false, // 是否显示右上角debug的标签
      theme: provider.getTheme(), // 主题配置
      darkTheme: provider.getTheme(isDarkMode: true), // 深色主题配置
      home: const AppNavigation(), // 首页配置
      onGenerateRoute: getRoute, // 路由配置
    );
  }
}
