import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_deer/pages/order/order_page.dart';
import 'package:flutter_deer/util/app_navigator_utils.dart';
import 'package:flutter_deer/util/device_utils.dart';
import 'package:flutter_deer/util/theme_utils.dart';
import 'package:flutter_deer/widgets/fractionally_aligned_sized_box.dart';
import 'package:flutter_deer/widgets/load_image.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Device.initDeviceInfo();
      _initSplash();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initSplash() {
    Future.delayed(const Duration(microseconds: 1500), () {
      _goLogin();
    });
  }

  void _goLogin() {
    AppNavigatorUtils.push(context, const OrderPage());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.backgroundColor,
      child: const FractionallyAlignedSizedBox(
        heightFactor: 0.3,
        widthFactor: 0.33,
        leftFactor: 0.33,
        bottomFactor: 0,
        child: LoadAssetImage('logo'),
      ),
    );
  }
}
