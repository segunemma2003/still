import 'package:flutter/material.dart';
import '/bootstrap/extensions.dart';
import '/resources/widgets/buttons/abstract/app_button.dart';

class TransparencyButton extends AppButton {
  final Color? color;

  const TransparencyButton({
    super.key,
    required super.text,
    super.onPressed,
    this.color,
    super.width,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Color(0xFFE8E7EA).withAlpha((255.0 * 0.3).round()),
      elevation: 0,
      onPressed: onPressed,
      child: buildButtonChild(
        context,
        textColor: color ?? context.color.buttonContent,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
