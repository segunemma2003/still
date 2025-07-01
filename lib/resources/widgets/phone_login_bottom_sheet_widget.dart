import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/utils.dart';
import 'package:nylo_framework/nylo_framework.dart';

class PhoneLoginBottomSheet extends StatefulWidget {
  const PhoneLoginBottomSheet({super.key});

  @override
  createState() => _PhoneLoginBottomSheetState();
}

class _PhoneLoginBottomSheetState extends NyState<PhoneLoginBottomSheet> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+971';

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
    _phoneController.dispose();
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
                    'phonebottomsheet.png', // Using the specified image
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
              'Your Phone',
              style: TextStyle(
                color: Color(0xFFE8E7EA),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            // Description - Updated typography
            const Text(
              'Please confirm your country code\nand enter number',
              style: TextStyle(
                color: Color(0xFF565560),
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // Phone Input with Country Code - Updated with gradient borders
            Row(
              children: [
                // Country Code Picker with gradient border
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
                    child: CountryCodePicker(
                      onChanged: (country) {
                        setState(() {
                          _selectedCountryCode = country.dialCode!;
                        });
                      },
                      initialSelection: 'AE', // UAE as default
                      favorite: const ['+971', 'AE'],
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      textStyle: const TextStyle(
                        color: Color(0xFFE8E7EA),
                        fontSize: 14,
                      ),
                      dialogTextStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      searchStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      dialogBackgroundColor: Color(0xFFE8E7EA),
                      backgroundColor: Colors.transparent,
                      barrierColor: Colors.black54,
                      closeIcon: const Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Phone Number Input with gradient border
                Expanded(
                  child: Container(
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
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(
                          color: Color(0xFFE8E7EA),
                          fontSize: 14,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: '5X XXX XXXX',
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
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Continue Button - Updated to match design system
            SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _handlePhoneSubmit();
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

  void _handlePhoneSubmit() {
    String phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      _showSnackBar('Please enter phone number');
      return;
    }

    if (phone.length < 8) {
      _showSnackBar('Please enter a valid phone number');
      return;
    }

    String fullPhone = _selectedCountryCode + phone;

    // Close current bottom sheet and show verification
    Navigator.pop(context);
    LoginBottomSheets.showPhoneVerificationBottomSheet(context, fullPhone);
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
