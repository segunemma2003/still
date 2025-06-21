import 'package:flutter/material.dart';

// Gradient colors for consistent styling
const List<Color> _gradientColors = [
  Color(0xB2919191), // 70% #919191B2
  Color(0xFF1F1F1F), // 30% #1F1F1F
];

// Floating label input widget function
Widget floatingLabelInput({
  required TextEditingController controller,
  required String labelText,
  required String hintText,
  bool obscureText = false,
  Widget? prefixIcon,
  Widget? suffixIcon,
  TextInputType? keyboardType,
  Function(String)? onChanged,
  String? Function(String?)? validator,
  bool enabled = true,
  int maxLines = 1,
  TextInputAction? textInputAction,
  FocusNode? focusNode,
}) {
  return Container(
    height: maxLines == 1 ? 49 : null,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      gradient: LinearGradient(
        colors: _gradientColors,
        stops: const [0.7, 1.0],
      ),
    ),
    child: Container(
      margin: const EdgeInsets.all(1), // Border width
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: const Color(0xFF1D1E20), // Background color
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        enabled: enabled,
        maxLines: maxLines,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onChanged: onChanged,
        validator: validator,
        style: const TextStyle(
          color: Color(0xFFE8E7EA),
          fontSize: 14,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 14,
          ),
          floatingLabelStyle: const TextStyle(
            color: Color(0xFFE8E7EA),
            fontSize: 12,
            backgroundColor: Color(0xFF1D1E20),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 14,
          ),
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: BorderSide.none,
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: prefixIcon != null ? 8 : 16,
            vertical: 12,
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
        ),
      ),
    ),
  );
}

// Password input widget function with built-in visibility toggle
Widget floatingLabelPasswordInput({
  required TextEditingController controller,
  required String labelText,
  required String hintText,
  required bool isPasswordVisible,
  required VoidCallback onVisibilityToggle,
  Widget? prefixIcon,
  Function(String)? onChanged,
  String? Function(String?)? validator,
  bool enabled = true,
  TextInputAction? textInputAction,
  FocusNode? focusNode,
}) {
  return floatingLabelInput(
    controller: controller,
    focusNode: focusNode,
    labelText: labelText,
    hintText: hintText,
    obscureText: !isPasswordVisible,
    prefixIcon: prefixIcon ??
        const Icon(
          Icons.lock_outline,
          color: Color(0xFFE8E7EA),
          size: 20,
        ),
    suffixIcon: IconButton(
      icon: Icon(
        isPasswordVisible
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined,
        color: Color(0xFFE8E7EA),
        size: 20,
      ),
      onPressed: onVisibilityToggle,
    ),
    onChanged: onChanged,
    validator: validator,
    enabled: enabled,
    textInputAction: textInputAction,
  );
}

// Usage in your SignIn page - replace the Container sections with:
/*
// Username Field
floatingLabelInput(
  controller: _usernameController,
  labelText: 'Username',
  hintText: 'Enter a username',
  keyboardType: TextInputType.text,
  textInputAction: TextInputAction.next,
),

const SizedBox(height: 24),

// Password Field  
floatingLabelPasswordInput(
  controller: _passwordController,
  labelText: 'Password',
  hintText: 'Enter password',
  isPasswordVisible: _isPasswordVisible,
  onVisibilityToggle: () {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  },
  textInputAction: TextInputAction.done,
),
*/
