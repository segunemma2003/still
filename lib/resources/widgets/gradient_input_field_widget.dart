import 'package:flutter/material.dart';

class GradientInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  final VoidCallback? onSuffixIconPressed; // For password visibility toggle

  const GradientInputField({
    Key? key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.onSuffixIconPressed,
  }) : super(key: key);

  // Gradient colors for consistent styling
  static const List<Color> _gradientColors = [
    Color(0xFF1F1F1F), // 30% #1F1F1F
    Color(0xB2919191), // 70% #919191B2
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Gradient border container
        Container(
          height: 49,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: _gradientColors,
              stops: const [0.3, 1.0],
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(1), // Border width
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              // Completely transparent to show page background
            ),
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              style: const TextStyle(color: Color(0xFFE8E7EA)),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Color(0xFFE8E7EA),
                  fontSize: 10,
                ),
                filled: false, // Don't fill with any color
                fillColor: Colors.transparent,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                isDense: true,
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon != null && onSuffixIconPressed != null
                    ? GestureDetector(
                        onTap: onSuffixIconPressed,
                        child: suffixIcon,
                      )
                    : suffixIcon,
              ),
            ),
          ),
        ),
        // Floating label without background
        Positioned(
          left: 12,
          top: -10,
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFFE8E7EA),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// Reusable Gradient Button Widget
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final BorderRadius? borderRadius;
  final bool isOutlined;

  const GradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.height = 48,
    this.borderRadius,
    this.isOutlined = false,
  }) : super(key: key);

  // Gradient colors for consistent styling
  static const List<Color> _gradientColors = [
    Color(0xB2919191), // 70% #919191B2
    Color(0xFF1F1F1F), // 30% #1F1F1F
  ];

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      // Outlined button with gradient border
      return Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(0),
          gradient: LinearGradient(
            colors: _gradientColors,
            stops: const [0.7, 1.0],
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(1), // Border width
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(0),
            color: const Color(0xFF1D1E20), // Background color
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: borderRadius ?? BorderRadius.circular(0),
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFE8E7EA),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      // Filled button
      return SizedBox(
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC8DEFC),
            foregroundColor: const Color(0xFFC8DEFC),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(28),
            ),
            elevation: 0,
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xff121417),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
  }
}

// Reusable Gradient Divider Widget
class GradientDivider extends StatelessWidget {
  final String text;

  const GradientDivider({
    Key? key,
    required this.text,
  }) : super(key: key);

  // Gradient colors for consistent styling
  static const List<Color> _gradientColors = [
    Color(0xB2919191), // 70% #919191B2
    Color(0xFF1F1F1F), // 30% #1F1F1F
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _gradientColors,
                stops: const [0.7, 1.0],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFFE8E7EA),
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _gradientColors,
                stops: const [0.7, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
