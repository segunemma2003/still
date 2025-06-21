import 'package:flutter/material.dart';
import 'package:flutter_app/resources/pages/sign_in_page.dart';
import 'package:flutter_app/resources/pages/sign_up_email_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

class WelcomePage extends NyStatefulWidget {
  static RouteView path = ("/welcome", (_) => WelcomePage());

  WelcomePage({super.key}) : super(child: () => _WelcomePageState());
}

class _WelcomePageState extends NyPage<WelcomePage> {
  @override
  get init => () {};

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('backgroundimage.png').localAsset(),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top spacer to push content to the same position
              Expanded(
                flex: 3,
                child: Container(), // Empty spacer instead of logo
              ),

              // Bottom content section - keeping exactly the same
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10), // Top spacing

                        // Welcome title
                        const Text(
                          'Welcome to Stillur',
                          style: TextStyle(
                            color: Color(0xFFE8E7EA),
                            fontSize: 24, // Slightly smaller
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 8), // Reduced spacing

                        // Description text
                        Text(
                          'Stillur is a privacy-first encrypted chat application. Your messages are always private and secure.',
                          style: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: 16, // Slightly smaller
                            height: 1.4, // Reduced line height
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 28), // Reduced spacing

                        // Login button
                        SizedBox(
                          width: double.infinity,
                          height: 48, // Slightly smaller
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to login screen
                              routeTo(SignInPage.path);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                  0xFFB8C5D6), // Light blue/grey color
                              foregroundColor: Color(0xFFC8DEFC), // Dark text
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Color(0xFF121417),
                                // No need for fontFamily - it's now global!
                                fontSize: 17, // Slightly smaller
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12), // Reduced spacing

                        // Sign Up button
                        SizedBox(
                          width: double.infinity,
                          height: 48, // Slightly smaller
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to sign up screen
                              routeTo(SignUpEmailPage.path);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                  0xFFB8C5D6), // Light blue/grey color
                              foregroundColor: Color(0xFFC8DEFC), // Dark text
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Color(0xFF121417),
                                // No need for fontFamily - it's now global!
                                fontSize: 16, // Slightly smaller
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20), // Reduced bottom spacing
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
