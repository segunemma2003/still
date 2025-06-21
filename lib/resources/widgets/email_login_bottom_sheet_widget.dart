import 'package:flutter/material.dart';
import 'package:flutter_app/app/utils.dart';
import 'package:nylo_framework/nylo_framework.dart';

class EmailLoginBottomSheet extends StatefulWidget {
  const EmailLoginBottomSheet({super.key});

  @override
  createState() => _EmailLoginBottomSheetState();
}

class _EmailLoginBottomSheetState extends NyState<EmailLoginBottomSheet> {
  final TextEditingController _emailController = TextEditingController();

  // Gradient colors for consistent styling (matching other pages)
  static const List<Color> _gradientColors = [
    Color(0xFF1F1F1F), // 30% #1F1F1F
    Color(0xB2919191), // 70% #919191B2
  ];

  @override
  get init => () {
        // Initialize any required data here
      };

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget view(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1D1E20),
            Color(0xFF000714),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Clickable Handle bar area
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                height: 40,
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Color(0xFFE8E7EA).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Logo - Using image instead of icon (consistent with other pages)
            Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'email.png', // Using the specified image
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ).localAsset(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Title - Updated to match design system typography
            const Text(
              'Your Email',
              style: TextStyle(
                color: Color(0xFFE8E7EA),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            // Description - Updated typography
            const Text(
              'Enter your email to continue login',
              style: TextStyle(
                color: Color(0xFF565560),
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 40),

            // Email Input with gradient border
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
                  color: const Color(0xFF1D1E20), // Background color
                ),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: Color(0xFFE8E7EA),
                    fontSize: 14,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: 'Enter email',
                    hintStyle: const TextStyle(
                      color: Color(0xFFE8E7EA),
                      fontSize: 10,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Color(0xFFE8E7EA),
                      size: 14.86,
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Continue Button - Updated to match design system
            SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _handleEmailSubmit();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC8DEFC),
                  foregroundColor: const Color(0xFFC8DEFC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff121417),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
          ],
        ),
      ),
    );
  }

  void _handleEmailSubmit() {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      _showSnackBar('Please enter email');
      return;
    }

    if (!_isValidEmail(email)) {
      _showSnackBar('Please enter a valid email');
      return;
    }

    // Close current bottom sheet and show verification
    Navigator.pop(context);
    LoginBottomSheets.showEmailVerificationBottomSheet(context, email);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
