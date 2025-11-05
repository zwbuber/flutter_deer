import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({super.key, required this.index, required this.tabIndex});

  final int index;
  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('OrderItem'));
  }
}
