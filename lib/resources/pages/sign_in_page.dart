import 'package:flutter/material.dart';
import 'package:flutter_app/resources/pages/base_navigation_hub.dart';
import 'package:flutter_app/resources/pages/sign_up_email_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

// Import the bottom sheets
import '../../app/utils.dart';

class SignInPage extends NyStatefulWidget {
  static RouteView path = ("/sign-in", (_) => SignInPage());

  SignInPage({super.key}) : super(child: () => _SignInPageState());
}

class _SignInPageState extends NyPage<SignInPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // Gradient colors for consistent styling
  static const List<Color> _gradientColors = [
    // / 70% #919191B2
    Color(0xFF1F1F1F), // 30% #1F1F1F
    Color(0xB2919191),
  ];

  @override
  get init => () {
        // Initialize any required data here
      };

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
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
                        const SizedBox(height: 30),

                        // Logo - Using image instead of icon
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
                                'signin.png',
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                              ).localAsset(),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Title
                        const Text(
                          'Login to Your Account',
                          style: TextStyle(
                            color: Color(0xFFE8E7EA),
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 60),

                        // Add padding to accommodate the label
                        const SizedBox(height: 8),
                        // Username Field with gradient border
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
                              color:
                                  const Color(0xFF1D1E20), // Background color
                            ),
                            child: Stack(
                              clipBehavior:
                                  Clip.none, // Allow label to extend outside
                              children: [
                                TextField(
                                  controller: _usernameController,
                                  style:
                                      const TextStyle(color: Color(0xFFE8E7EA)),
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    labelText: 'Username',
                                    labelStyle: const TextStyle(
                                      fontSize: 8,
                                      color: Colors
                                          .transparent, // Hide the original label
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior
                                        .never, // Disable floating
                                    hintText: 'Enter a username',
                                    hintStyle: const TextStyle(
                                      color: Color(0xFFE8E7EA),
                                      fontSize: 10,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                                // Manually positioned label (consistent across screens)
                                Positioned(
                                  top:
                                      -6, // Adjusted position for better visibility
                                  left: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    color: const Color(
                                        0xFF1D1E20), // Match background
                                    child: const Text(
                                      'Username',
                                      style: TextStyle(
                                        color: Color(0xFFE8E7EA),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Password Field with gradient border and consistent label positioning
                        Container(
                          height: 49,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
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
                            child: Stack(
                              clipBehavior:
                                  Clip.none, // Allow label to extend outside
                              children: [
                                TextField(
                                  controller: _passwordController,
                                  obscureText: !_isPasswordVisible,
                                  style:
                                      const TextStyle(color: Color(0xFFE8E7EA)),
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: const TextStyle(
                                      fontSize: 8,
                                      color: Colors
                                          .transparent, // Hide the original label
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior
                                        .never, // Disable floating
                                    hintText: 'Enter password',
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
                                      size: 14.86,
                                      Icons.lock_outline,
                                      color: Color(0xFFE8E7EA),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: Color(0xFFE8E7EA),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible =
                                              !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                // Manually positioned label (consistent with username field)
                                Positioned(
                                  top:
                                      -6, // Adjusted position for better visibility
                                  left: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    color: const Color(
                                        0xFF1D1E20), // Match background
                                    child: const Text(
                                      'Password',
                                      style: TextStyle(
                                        color: Color(0xFFE8E7EA),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Handle forgot password
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Color(0xFF007AFF),
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Continue Button
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle login
                              _handleLogin();
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

                        const SizedBox(height: 40),

                        // Divider with gradient line
                        Row(
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
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Or login with',
                                style: TextStyle(
                                  color: Color(0xFF565560),
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
                        ),

                        const SizedBox(height: 24),

                        // Email and Mobile buttons with gradient borders
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 48,
                                child: Container(
                                  margin:
                                      const EdgeInsets.all(1), // Border width
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                    color: const Color(
                                        0xFF40474E33), // Background color
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        LoginBottomSheets.showEmailBottomSheet(
                                            context);
                                      },
                                      child: const Center(
                                        child: Text(
                                          'Email',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFFE8E7EA),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                height: 48,
                                child: Container(
                                  margin:
                                      const EdgeInsets.all(1), // Border width
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                    color: const Color(
                                        0xFF40474E33), // Background color
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        LoginBottomSheets.showPhoneBottomSheet(
                                            context);
                                      },
                                      child: const Center(
                                        child: Text(
                                          'Mobile',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFFE8E7EA),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // Sign Up Link
                        Center(
                          child: TextButton(
                            onPressed: () {
                              routeTo(SignUpEmailPage.path);
                              // Navigate to sign up page
                            },
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFE8E7EA),
                                ),
                                children: [
                                  TextSpan(text: 'New here? '),
                                  TextSpan(
                                    text: 'Sign Up Instead',
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

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }

  void _handleLogin() {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty) {
      _showSnackBar('Please enter username');
      return;
    }

    if (password.isEmpty) {
      _showSnackBar('Please enter password');
      return;
    }

    // Add your login logic here
    print('Username: $username');
    print('Password: $password');

    // Example: Navigate to home page after successful login
    // Navigator.pushReplacementNamed(context, '/home');
    routeTo(BaseNavigationHub.path);
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
