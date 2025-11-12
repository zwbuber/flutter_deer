import 'package:flutter/material.dart';
import 'package:flutter_deer/res/dimens.dart';
import 'package:flutter_deer/res/gaps.dart';
import 'package:flutter_deer/util/app_navigator_utils.dart';
import 'package:flutter_deer/widgets/base_dialog.dart';
import 'package:flutter_deer/widgets/load_image.dart';

// design/3订单/index.html#artboard5
class PayTypeDialog extends StatefulWidget {
  const PayTypeDialog({super.key, this.onPressed});

  final void Function(int, String)? onPressed;

  @override
  State<PayTypeDialog> createState() => _PayTypeDialogState();
}

class _PayTypeDialogState extends State<PayTypeDialog> {
  int _value = 0;

  final _list = ['未收款', '支付宝', '微信', '现金'];

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: '收款方式',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_list.length, (i) => _buildItem(i)),
      ),
      onPressed: () {
        AppNavigatorUtils.goBack(context);
        widget.onPressed?.call(_value, _list[_value]);
      },
    );
  }

  Widget _buildItem(int index) {
    // Material
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        child: SizedBox(
          height: 42.0,
          child: Row(
            children: [
              Gaps.hGap16,
              Expanded(
                child: Text(
                  _list[index],
                  style: _value == index
                      ? TextStyle(
                          fontSize: Dimens.font_sp14,
                          color: Theme.of(context).primaryColor,
                        )
                      : null,
                ),
              ),
              Visibility(
                visible: _value == index,
                child: const LoadAssetImage(
                  'order/ic_check',
                  width: 16.0,
                  height: 16.0,
                ),
              ),
              Gaps.hGap16,
            ],
          ),
        ),
        onTap: () {
          if (!mounted) {
            return;
          }
          setState(() {
            _value = index;
          });
        },
      ),
    );
  }
}
