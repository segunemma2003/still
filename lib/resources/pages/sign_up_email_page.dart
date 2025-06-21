import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class SignUpEmailPage extends NyStatefulWidget {
  static RouteView path = ("/sign-up-email", (_) => SignUpEmailPage());

  SignUpEmailPage({super.key}) : super(child: () => _SignUpEmailPageState());
}

class _SignUpEmailPageState extends NyPage<SignUpEmailPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Gradient colors for consistent styling (matching SignInPage)
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
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool obscureText = false,
    bool hasVisibilityToggle = false,
    bool? isPasswordVisible,
    VoidCallback? onVisibilityToggle,
    Widget? prefixIcon,
    TextInputType? keyboardType,
  }) {
    return Container(
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
        child: Stack(
          clipBehavior: Clip.none, // Allow label to extend outside
          children: [
            TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              style: const TextStyle(color: Color(0xFFE8E7EA)),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(
                  fontSize: 8,
                  color: Colors.transparent, // Hide the original label
                ),
                floatingLabelBehavior:
                    FloatingLabelBehavior.never, // Disable floating
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Color(0xFFE8E7EA),
                  fontSize: 10,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                prefixIcon: prefixIcon,
                suffixIcon: hasVisibilityToggle
                    ? IconButton(
                        icon: Icon(
                          isPasswordVisible == true
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Color(0xFFE8E7EA),
                        ),
                        onPressed: onVisibilityToggle,
                      )
                    : null,
              ),
            ),
            // Manually positioned label (consistent with SignInPage)
            Positioned(
              top: -6, // Adjusted position for better visibility
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                color: const Color(0xFF1D1E20), // Match background
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFFE8E7EA),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

                    // Logo - Using image instead of icon (consistent with SignInPage)
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
                            'signup.png', // You can change this to your desired image
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                          ).localAsset(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Title - Updated to match sign-in typography
                    const Text(
                      'Sign Up with Email',
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

                    // Username Field
                    _buildCustomTextField(
                      controller: _usernameController,
                      label: 'Username',
                      hint: 'Enter a username',
                    ),

                    const SizedBox(height: 24),

                    // Email Field
                    _buildCustomTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 24),

                    // Password Field
                    _buildCustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Create Password',
                      obscureText: !_isPasswordVisible,
                      hasVisibilityToggle: true,
                      isPasswordVisible: _isPasswordVisible,
                      onVisibilityToggle: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Color(0xFFE8E7EA),
                        size: 14.86,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Confirm Password Field
                    _buildCustomTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      hint: 'Re-Enter Password',
                      obscureText: !_isConfirmPasswordVisible,
                      hasVisibilityToggle: true,
                      isPasswordVisible: _isConfirmPasswordVisible,
                      onVisibilityToggle: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Color(0xFFE8E7EA),
                        size: 14.86,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Continue Button - Updated to match sign-in styling
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle signup
                          _handleSignUp();
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

                    // Divider with gradient line (matching SignInPage)
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
                            'Or Sign up with',
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

                    // Mobile Button - Updated to match sign-in styling
                    Container(
                      height: 48,
                      child: Container(
                        margin: const EdgeInsets.all(1), // Border width
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          color: const Color(0xFF40474E33), // Background color
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              // Navigate to mobile signup
                              Navigator.pushNamed(context, '/sign-up-mobile');
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

                    const SizedBox(height: 40),

                    // Login Link - Updated to match sign-in styling
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Navigate to login page
                          Navigator.pushNamed(context, '/sign-in');
                        },
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFE8E7EA),
                            ),
                            children: [
                              TextSpan(text: 'Already have an Account? '),
                              TextSpan(
                                text: 'Login Instead',
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
        ),
      ),
    );
  }

  void _handleSignUp() {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty) {
      _showSnackBar('Please enter username');
      return;
    }

    if (email.isEmpty) {
      _showSnackBar('Please enter email');
      return;
    }

    if (!_isValidEmail(email)) {
      _showSnackBar('Please enter a valid email');
      return;
    }

    if (password.isEmpty) {
      _showSnackBar('Please enter password');
      return;
    }

    if (password.length < 6) {
      _showSnackBar('Password must be at least 6 characters');
      return;
    }

    if (confirmPassword.isEmpty) {
      _showSnackBar('Please confirm password');
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar('Passwords do not match');
      return;
    }

    // Add your signup logic here
    print('Username: $username');
    print('Email: $email');
    print('Password: $password');

    // Example: Navigate to verification page or home
    // Navigator.pushReplacementNamed(context, '/verification');
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
