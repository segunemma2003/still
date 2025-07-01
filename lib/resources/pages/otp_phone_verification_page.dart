import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nylo_framework/nylo_framework.dart';

class OtpPhoneVerificationPage extends NyStatefulWidget {
  static RouteView path =
      ("/otp-phone-verification", (_) => OtpPhoneVerificationPage());

  OtpPhoneVerificationPage({super.key})
      : super(child: () => _OtpPhoneVerificationPageState());
}

class _OtpPhoneVerificationPageState extends NyPage<OtpPhoneVerificationPage> {
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  String phoneNumber =
      '+971 57 884 3323'; // This should be passed from previous page

  // Gradient colors for consistent styling (matching other pages)
  static const List<Color> _gradientColors = [
    Color(0xFF1F1F1F), // 30% #1F1F1F
    Color(0xB2919191), // 70% #919191B2
  ];

  @override
  get init => () {
        // Initialize any required data here
        // You can get the phone number from route arguments
        // phoneNumber = widget.data ?? '+971 57 884 3323';
      };

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
  Widget view(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1D1E20),
              Color(0xFF000714),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),

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
                            'verify.png', // You can change this to your desired image
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
                      'Enter Code',
                      style: TextStyle(
                        color: Color(0xFFE8E7EA),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    // Description - Updated typography
                    Text(
                      'We just sent you an SMS verification code to\n$phoneNumber',
                      style: const TextStyle(
                        color: Color(0xFF565560),
                        fontSize: 14,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 60),

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
                              color:
                                  const Color(0xFF1D1E20), // Background color
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

                                // Check if all fields are filled
                                _checkIfComplete();
                              },
                              onTap: () {
                                _controllers[index].selection =
                                    TextSelection.fromPosition(
                                  TextPosition(
                                      offset: _controllers[index].text.length),
                                );
                              },
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 40),

                    // Resend Code - Updated to match design system
                    Center(
                      child: TextButton(
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
                    ),

                    const SizedBox(height: 150),

                    // Continue Button - Updated to match design system
                    SizedBox(
                      height: 48,
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _checkIfComplete() {
    bool allFilled =
        _controllers.every((controller) => controller.text.isNotEmpty);
    if (allFilled) {
      // Auto verify when all fields are filled
      Future.delayed(const Duration(milliseconds: 200), () {
        _verifyCode();
      });
    }
  }

  void _verifyCode() {
    String code = _controllers.map((controller) => controller.text).join();

    if (code.length != 4) {
      _showSnackBar('Please enter the complete verification code');
      return;
    }

    // Add your verification logic here
    print('Verification code: $code');
    print('Phone number: $phoneNumber');

    // Example: Navigate to success page or home
    // Navigator.pushReplacementNamed(context, '/home');

    _showSnackBar('Code verified successfully!', isError: false);
  }

  void _resendCode() {
    // Clear all fields
    for (var controller in _controllers) {
      controller.clear();
    }

    // Focus first field
    _focusNodes[0].requestFocus();

    // Add your resend logic here
    print('Resending code to: $phoneNumber');

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
