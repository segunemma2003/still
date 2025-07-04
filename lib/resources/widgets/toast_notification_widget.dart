import '/bootstrap/extensions.dart';
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class ToastNotification extends StatelessWidget {
  const ToastNotification(ToastMeta toastMeta, {Function? onDismiss, super.key})
      : _toastMeta = toastMeta,
        _dismiss = onDismiss;

  final Function? _dismiss;
  final ToastMeta _toastMeta;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        height: 100,
        decoration: BoxDecoration(
          color: context.color.toastNotificationBackground,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: context.isThemeDark
                  ? Colors.transparent
                  : Colors.grey.withAlpha((255.0 * 0.1).round()),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(children: [
          InkWell(
            onTap: () {
              if (_toastMeta.action != null) {
                _toastMeta.action!();
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: _toastMeta.color,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        topLeft: Radius.circular(8)),
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  margin: const EdgeInsets.only(right: 12),
                  child: Center(child: _toastMeta.icon),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _toastMeta.title.tr(),
                        ).bodyLarge(
                            color: context.color.content,
                            fontWeight: FontWeight.bold),
                        Flexible(
                          child: Text(
                            _toastMeta.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ).bodyMedium(
                              color: context.color.content
                                  .withAlpha((255.0 * 0.8).round())),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            bottom: 12,
            child: Center(
              child: Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: context.isThemeDark
                        ? Color(0xFFE8E7EA)
                        : "#f2f2f2".toHexColor(),
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      if (_dismiss != null) {
                        _dismiss();
                      }
                    },
                    icon: Icon(
                      Icons.close,
                      color: context.isThemeDark
                          ? Color(0xFFE8E7EA)
                          : "#878787".toHexColor(),
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
