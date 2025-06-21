import 'package:flutter/material.dart';
import 'package:flutter_app/resources/pages/profile_details_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  createState() => _SettingsTabState();
}

class _SettingsTabState extends NyState<SettingsTab> {
  bool _hiddenProfile = false;

  @override
  get init => () {};

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F131B),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // User Profile Section
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Profile Image
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'image6.png', // User's profile image
                          fit: BoxFit.cover,
                        ).localAsset(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // User Name
                    const Text(
                      'Alim Salim',
                      style: TextStyle(
                        color: Color(0xFFE8E7EA),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Phone Number and Username
                    Text(
                      '+971577563263 | GhostRider24',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Settings Options
              _buildSettingsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Profile Details
          _buildSettingsItem(
            icon: Icons.person_outline,
            title: 'Profile Details',
            onTap: () {
              // Navigate to profile details
              routeTo(ProfileDetailsPage.path);
            },
          ),

          // Security
          _buildSettingsItem(
            icon: Icons.security_outlined,
            title: 'Security',
            onTap: () {
              // Navigate to security settings
            },
          ),

          // Chats
          _buildSettingsItem(
            icon: Icons.chat_bubble_outline,
            title: 'Chats',
            onTap: () {
              // Navigate to chat settings
            },
          ),

          // Notifications
          _buildSettingsItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            onTap: () {
              // Navigate to notification settings
            },
          ),

          const SizedBox(height: 16),

          // Hidden Profile Toggle
          _buildHiddenProfileToggle(),

          const SizedBox(height: 16),

          // Subscription
          _buildSettingsItem(
            icon: Icons.star_outline,
            title: 'Subscription',
            onTap: () {
              // Navigate to subscription
            },
          ),

          // Help and Feedback
          _buildSettingsItem(
            icon: Icons.help_outline,
            title: 'Help and feedback',
            onTap: () {
              // Navigate to help
            },
          ),

          // Share Stillur
          _buildSettingsItem(
            icon: Icons.share_outlined,
            title: 'Share Stillur',
            onTap: () {
              // Share app
            },
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Color(0xFFE8E7EA),
                  size: 12,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFFE8E7EA),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHiddenProfileToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C212C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lock_outline,
                color: Color(0xFFE8E7EA),
                size: 24,
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Hidden Profile',
                  style: TextStyle(
                    color: Color(0xFFE8E7EA),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Switch(
                value: _hiddenProfile,
                onChanged: (value) {
                  setState(() {
                    _hiddenProfile = value;
                  });
                },
                activeColor: const Color(0xFF3498DB),
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey.shade600,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Text(
              'Hide your profile details so others cannot see them.',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
