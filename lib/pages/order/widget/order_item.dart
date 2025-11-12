import 'package:flutter/material.dart';
import 'package:flutter_deer/pages/order/widget/pay_type_dialog.dart';
import 'package:flutter_deer/res/colors.dart';
import 'package:flutter_deer/res/gaps.dart';
import 'package:flutter_deer/util/app_navigator_utils.dart';
import 'package:flutter_deer/util/other_utils.dart';
import 'package:flutter_deer/util/theme_utils.dart';
import 'package:flutter_deer/util/toast_utils.dart';
import 'package:flutter_deer/widgets/my_card.dart';

const List<String> orderLeftButtonText = ['拒单', '拒单', '订单跟踪', '订单跟踪', '订单跟踪'];
const List<String> orderRightButtonText = ['接单', '开始配送', '完成', '', ''];

class OrderItem extends StatelessWidget {
  const OrderItem({super.key, required this.index, required this.tabIndex});

  final int index;
  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: MyCard(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: InkWell(onTap: () {}, child: _buildContent(context)),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final TextStyle? textTextStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(fontSize: 12);

    final bool isDark = context.isDark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: Text('15000000000（郭李）')),
            Text(
              '货到付款',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
        Gaps.vGap8,
        Text(
          '西安市雁塔区 鱼化寨街道唐兴路唐兴数码3楼318',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Gaps.vGap8,
        Gaps.line,
        Gaps.vGap8,
        RichText(
          text: TextSpan(
            style: textTextStyle,
            children: [
              const TextSpan(text: '清凉一度抽纸'),
              TextSpan(
                text: '  x1',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
        Gaps.vGap8,
        RichText(
          text: TextSpan(
            style: textTextStyle,
            children: [
              const TextSpan(text: '清凉一度抽纸'),
              TextSpan(
                text: '  x2',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
        Gaps.vGap12,
        Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: textTextStyle,
                  children: [
                    TextSpan(text: '¥20.00'),
                    TextSpan(
                      text: '  共3件商品',
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
            const Text('2021.02.05 10:00', style: TextStyle(fontSize: 12)),
          ],
        ),
        Gaps.vGap8,
        Gaps.line,
        Gaps.vGap8,
        Row(
          children: [
            OrderItemButton(
              key: Key('order_button_1_$index'),
              text: '联系客服',
              textColor: isDark ? Colours.dark_text : Colours.text,
              bgColor: isDark ? Colours.dark_material_bg : Colours.bg_gray,
              onTap: () => _showCallPhoneDialog(context, '15000000000'),
            ),
            const Expanded(child: Gaps.empty),
            OrderItemButton(
              key: Key('order_button_2_$index'),
              text: orderLeftButtonText[tabIndex],
              textColor: isDark ? Colours.dark_text : Colours.text,
              bgColor: isDark ? Colours.dark_material_bg : Colours.bg_gray,
              onTap: () {
                if (tabIndex >= 2) {
                  // AppNavigatorUtils.push(context, OrderRouter.orderTrackPage);
                }
              },
            ),
            if (orderRightButtonText[tabIndex].isEmpty)
              Gaps.empty
            else
              Gaps.hGap10,
            if (orderRightButtonText[tabIndex].isEmpty)
              Gaps.empty
            else
              OrderItemButton(
                key: Key('order_button_3_$index'),
                text: orderRightButtonText[tabIndex],
                textColor: isDark ? Colours.dark_button_text : Colors.white,
                bgColor: isDark ? Colours.dark_app_main : Colours.app_main,
                onTap: () {
                  if (tabIndex == 2) {
                    _showPayTypeDialog(context);
                  }
                },
              ),
          ],
        ),
      ],
    );
  }

  // 拨打电话弹窗
  void _showCallPhoneDialog(BuildContext context, String phone) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('提示'),
          content: Text('是否拨打：$phone ?'),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          actions: [
            TextButton(
              onPressed: () => AppNavigatorUtils.goBack(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Utils.launchTelURL(phone);
                AppNavigatorUtils.goBack(context);
              },
              style: ButtonStyle(
                // 按下高亮颜色
                overlayColor: WidgetStateProperty.all<Color>(
                  Theme.of(context).colorScheme.error.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                '拨打',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }
}

// 支付方式弹窗
void _showPayTypeDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return PayTypeDialog(
        onPressed: (index, type) {
          Toast.show('收款类型：$type');
        },
      );
    },
  );
}

class OrderItemButton extends StatelessWidget {
  const OrderItemButton({
    super.key,
    this.bgColor,
    this.textColor,
    required this.text,
    this.onTap,
  });

  final Color? bgColor;
  final Color? textColor;
  final String text;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(4.0),
        ),
        constraints: const BoxConstraints(
          minWidth: 64.0,
          maxHeight: 30.0,
          minHeight: 30.0,
        ),
        child: Text(text, style: TextStyle(fontSize: 14, color: textColor)),
      ),
    );
  }
}
