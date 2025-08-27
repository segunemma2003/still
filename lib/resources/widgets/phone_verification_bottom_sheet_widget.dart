import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/app/models/user.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/networking/auth_api_service.dart';

class PhoneVerificationBottomSheet extends StatefulWidget {
  final String phone;

  const PhoneVerificationBottomSheet({super.key, required this.phone});

  @override
  State<PhoneVerificationBottomSheet> createState() =>
      _PhoneVerificationBottomSheetState();
}

class _PhoneVerificationBottomSheetState
    extends State<PhoneVerificationBottomSheet>
    with HasApiService<AuthApiService> {
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  // Gradient colors for consistent styling (matching other pages)
  static const List<Color> _gradientColors = [
    Color(0xFF1F1F1F), // 30% #1F1F1F
    Color(0xB2919191), // 70% #919191B2
  ];

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
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

            // Logo - Using image instead of icon (consistent with other pages)

            // Title - Updated to match design system typography
            const Text(
              'Let\'s Verify your phone',
              style: TextStyle(
                color: Color(0xFFE8E7EA),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            // Description - Updated typography
            const Text(
              'We\'ve sent a 4-digit code to your phone.\nIt will auto verify once entered.',
              style: TextStyle(
                color: Color(0xFF565560),
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // OTP Input Fields - Updated with gradient borders
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return Container(
                  width: 60,
                  height: 60,
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
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFE8E7EA),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }

                        _checkIfComplete();
                      },
                      onTap: () {
                        _controllers[index].selection =
                            TextSelection.fromPosition(
                          TextPosition(offset: _controllers[index].text.length),
                        );
                      },
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 40),

            // Resend Code - Updated to match design system
            TextButton(
              onPressed: () {
                _resendCode();
              },
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFE8E7EA),
                  ),
                  children: [
                    TextSpan(text: 'Didn\'t receive any code? '),
                    TextSpan(
                      text: 'Resend',
                      style: TextStyle(
                        color: Color(0xFF007AFF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Continue Button - Added for consistency with design system
            SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _verifyCode();
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

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _checkIfComplete() {
    bool allFilled =
        _controllers.every((controller) => controller.text.isNotEmpty);
    if (allFilled) {
      Future.delayed(const Duration(milliseconds: 200), () {
        _verifyCode();
      });
    }
  }

  Future<void> _verifyCode() async {
    String code = _controllers.map((controller) => controller.text).join();

    if (code.length != 4) {
      _showSnackBar('Please enter the complete verification code');
      return;
    }

    print('Phone verification code: $code for ${widget.phone}');
    var apiService = AuthApiService();
    User? user = await apiService.loginUser(
      phone: widget.phone,
      otp: code,
    );
    if (user == null || user.accessToken == null) {
      _showSnackBar('Invalid verification code. Please try again.');
      return;
    }
    await Auth.authenticate(data: user.toJson());
    _showSnackBar('Login successful!', isError: false);
    Future.delayed(const Duration(seconds: 1), () {
      routeToAuthenticatedRoute();
    });
    // Close bottom sheet and navigate to home or success
    // Navigator.pop(context);
    // _showSnackBar('Code verified successfully!', isError: false);
    // Add your navigation logic here
  }

  void _resendCode() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();

    print('Resending code to: ${widget.phone}');
    _showSnackBar('Verification code sent!', isError: false);
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
