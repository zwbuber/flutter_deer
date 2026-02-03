import 'package:flutter/material.dart';
import 'package:flutter_deer/widgets/my_app_bar.dart';

class OrderTrackPage extends StatefulWidget {
  const OrderTrackPage({super.key});

  @override
  State<OrderTrackPage> createState() => _OrderTrackPageState();
}

class _OrderTrackPageState extends State<OrderTrackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(centerTitle: '订单跟踪'),
      body: Text('订单跟踪'),
    );
  }
}
