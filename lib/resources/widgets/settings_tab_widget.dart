import 'package:flutter/material.dart';
import 'package:flutter_app/app/networking/chat_api_service.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:image_picker/image_picker.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  createState() => _SettingsTabState();
}
  String get baseUrl => getEnv('API_BASE_URL');

 

class _SettingsTabState extends NyState<SettingsTab> {
  bool _hiddenProfile = false;
  String _username = "Alim Salim";
  String? _phoneNumber = "+971577563263";
  String? _userAvatar; 
  int _imageKey = 0;

  String? _email = "Alim Salim"; // Placeholder for user's full name
  String defaultAvatar = "image6.png";

  @override
  get init => () async {
        final userData = await Auth.data();
        print("User data: $userData");
        if (userData != null) {
          
          setState(() {
            _username = userData['username'];
            _phoneNumber = userData['phone'];
            _userAvatar = userData['avatar']; // Default avatar
            _email = userData['email']; // Default full
            // _hiddenProfile = userData['hiddenProfile'] ?? false;
          });
        }
      };


   void _pickMedia() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
         final resp = await ChatApiService().uploadAvatarImage(pickedFile.path);
          
          if (resp != null && resp.url != null) {
            _imageKey++;
            setState(() {
              _imageKey++;
            });
            
          }
    } 
  }

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
                    // Profile Image with hover and pick media
                    
                    GestureDetector(
                      onTap: _pickMedia,

                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: (_userAvatar != null && _userAvatar != defaultAvatar)
                                ? Image.network(
                                    '${baseUrl}$_userAvatar?refresh=$_imageKey',
                                    key: ValueKey(_imageKey),
                                  fit: BoxFit.cover,
                                  width: 80,
                                  height: 80,
                                )
                                : Image.asset(
                                  defaultAvatar,
                                  fit: BoxFit.cover,
                                  width: 80,
                                  height: 80,
                                ).localAsset(),
                            ),
                            ),
                          
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickMedia,

                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFF57A1FF),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(2),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          )

                        ],
                      ),
                    ),
                   
                                
                    const SizedBox(height: 16),

                    // User Name
                    Text(
                      "@" + _username,
                      style: TextStyle(
                        color: Color(0xFFE8E7EA),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Phone Number and Username
                    Text(
                      '${_phoneNumber ?? _email} | $_username',
                      style: TextStyle(
                        color: Color(0xFF8E9297),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
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
          // First Group - Main Settings
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1C212C),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Profile Details
                _buildSettingsItem(
                  // icon: Icons.person_outline,
                  imagePath: "profile_icon.png",
                  title: 'Profile Details',
                  onTap: () {
                    // routeTo(ProfileDetailsPage.path);
                  },
                  showDivider: true,
                ),

                // Security
                _buildSettingsItem(
                  // icon: Icons.security_outlined,
                  imagePath: "security_icon.png",
                  title: 'Security',
                  onTap: () {
                    // Navigate to security settings
                  },
                  showDivider: true,
                ),

                // Chats
                _buildSettingsItem(
                  // icon: Icons.chat_bubble_outline,
                  imagePath: "chat_icon.png",
                  title: 'Chats',
                  onTap: () {
                    // Navigate to chat settings
                  },
                  showDivider: true,
                ),

                // Notifications
                _buildSettingsItem(
                  // icon: Icons.notifications_outlined,
                  imagePath: "notification_icon.png",
                  title: 'Notifications',
                  onTap: () {
                    // Navigate to notification settings
                  },
                  showDivider: false,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Hidden Profile Toggle - Separate Section
          _buildHiddenProfileToggle(),

          const SizedBox(height: 16),

          // Second Group - Additional Settings
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1C212C),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Subscription
                _buildSettingsItem(
                  // icon: Icons.star_outline,
                  imagePath: "subscription_icon.png",
                  title: 'Subscription',
                  onTap: () {
                    // Navigate to subscription
                  },
                  showDivider: true,
                ),

                // Help and Feedback
                _buildSettingsItem(
                  // icon: Icons.help_outline,
                  imagePath: "feedback_icon.png",
                  title: 'Help and feedback',
                  onTap: () {
                    // Navigate to help
                  },
                  showDivider: true,
                ),

                // Share Stillur
                _buildSettingsItem(
                  // icon: Icons.share_outlined,
                  imagePath: "share_icon.png",
                  title: 'Share Stillur',
                  onTap: () {
                    // Share app
                  },
                  showDivider: false,
                ),
                _buildSettingsItem(
                  // icon: Icons.share_outlined,
                  imagePath: "share_icon.png",
                  title: 'Log Out',
                  textColor: Colors.red,
                  onTap: () async {
                    await Auth.logout();
                    await routeToAuthenticatedRoute();
                    // Log out user
                  },
                  showDivider: false,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    IconData? icon,
    String? imagePath,
    required String title,
    required VoidCallback onTap,
    bool showDivider = false,
    Color? textColor,
  }) {
    assert(icon != null || imagePath != null,
        'Either icon or imagePath must be provided');
    assert(!(icon != null && imagePath != null),
        'Cannot provide both icon and imagePath');

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  // Display either icon or image
                  if (icon != null)
                    Icon(
                      icon,
                      color: Color(0xFF57A1FF),
                      size: 20,
                    )
                  else if (imagePath != null)
                    Container(
                      width: 20,
                      height: 20,
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                      ).localAsset(),
                    ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: textColor ?? Color(0xFFE8E7EA),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF8E9297),
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Container(
            margin: const EdgeInsets.only(left: 52),
            height: 1,
            color: Color(0xFF2B2A30),
          ),
      ],
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
              // const Icon(
              //   Icons.lock_outline,
              //   color: Color(0xFF57A1FF),
              //   size: 20,
              // ),
              Image.asset(
                "lock_icon.png",
                width: 20,
                height: 20,
              ).localAsset(),
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
                inactiveThumbColor: Colors.grey.shade400,
                inactiveTrackColor: Colors.grey.shade700,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Text(
              'Hide your profile details so others cannot see them.',
              style: TextStyle(
                color: Color(0xFF8E9297),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
