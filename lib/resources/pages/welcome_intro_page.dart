import 'package:flutter/material.dart';
import 'package:flutter_app/resources/pages/welcome_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

class WelcomeIntroPage extends NyStatefulWidget {
  static RouteView path = ("/welcome-intro", (_) => WelcomeIntroPage());

  WelcomeIntroPage({super.key}) : super(child: () => _WelcomeIntroPageState());
}

class _WelcomeIntroPageState extends NyPage<WelcomeIntroPage> {
  @override
  get init => () {};

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('onboardfullscreen.png').localAsset(),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top spacer to push content to bottom half
              Expanded(
                flex: 1,
                child: Container(),
              ),

              // Bottom content section - covers exactly half the screen
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Welcome title
                      const Text(
                        'Welcome to Stillur',
                        style: TextStyle(
                          color: Color(0xFFE8E7EA),
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      // Description text
                      Text(
                        'Stillur is a privacy-first encrypted chat application. Your messages are always private and secure.',
                        style: TextStyle(
                          color: Colors.grey.shade300,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      // Get Started button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to next screen
                            // Navigator.pushReplacementNamed(context, "/main");
                            routeTo(WelcomePage.path);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                                0xFFB8C5D6), // Light blue/grey color
                            foregroundColor: Color(0xFFC8DEFC), // Dark text
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: const Text(
                            'Get Started',
                            style: TextStyle(
                              color: Color(0xFF121417),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32), // Bottom spacing
                    ],
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
