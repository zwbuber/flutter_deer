import 'package:flutter/material.dart';
import 'package:flutter_deer/util/toast_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  // 调起拨号页
  static Future<void> launchTelURL(String phone) async {
    final Uri uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Toast.show('拨号失败！');
    }
  }
}

Future<T?> showElasticDialog<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  required WidgetBuilder builder,
}) {
  return showGeneralDialog(
    context: context,
    pageBuilder:
        (
          BuildContext buildContext,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          final Widget pageChild = Builder(builder: builder);
          return SafeArea(child: pageChild);
        },
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 550),
    transitionBuilder: _buildDialogTransitions,
  );
}

Widget _buildDialogTransitions(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(
    opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
    child: SlideTransition(
      position: Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: animation,
              curve: const ElasticOutCurve(0.85),
              reverseCurve: Curves.easeOutBack,
            ),
          ),
      child: child,
    ),
  );
}

/// String 空安全处理
extension StringExtension on String? {
  String get nullSafe => this ?? '';
}
