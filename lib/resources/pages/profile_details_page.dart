import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class ProfileDetailsPage extends NyStatefulWidget {
  static RouteView path = ("/profile-details", (_) => ProfileDetailsPage());

  ProfileDetailsPage({super.key})
      : super(child: () => _ProfileDetailsPageState());
}

class _ProfileDetailsPageState extends NyPage<ProfileDetailsPage> {
  int _selectedTab = 0; // 0: Media, 1: Files, 2: Links

  final List<String> _mediaImages = [
    'image1.png',
    'image2.png',
    'image3.png',
    'image4.png',
    'image5.png',
    'image6.png',
    'image7.png',
    'image8.png',
    'image9.png',
    'image10.png',
    'image11.png',
    'image1.png',
  ];

  @override
  get init => () {};

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F131B),
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            _buildHeader(),

            // Profile Info Section
            _buildProfileInfo(),

            // Action Buttons
            _buildActionButtons(),

            // About Section (when not showing media)
            if (_selectedTab != 0) _buildAboutSection(),

            // Media Tabs
            _buildMediaTabs(),

            // Content based on selected tab
            Expanded(
              child: _buildTabContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFFE8E7EA),
              size: 14,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Profile Image
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                'image2.png', // Layla B's profile image
                fit: BoxFit.cover,
              ).localAsset(),
            ),
          ),

          const SizedBox(height: 16),

          // Name
          const Text(
            'Layla B',
            style: TextStyle(
              color: Color(0xFFE8E7EA),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          // Last Seen
          Text(
            'Last seen 3 hours ago',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 48, vertical: 20), // Reduced vertical padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Call Button
          _buildActionButton(
            icon: Icons.call,
            onTap: () {
              // Make voice call
              Navigator.pushNamed(context, "/voice-call");
            },
          ),

          // Video Call Button
          _buildActionButton(
            icon: Icons.videocam,
            onTap: () {
              // Make video call
              Navigator.pushNamed(context, "/video-call");
            },
          ),

          // Search Button
          _buildActionButton(
            icon: Icons.search,
            onTap: () {
              // Search in chat
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF1C212C),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: Color(0xFFE8E7EA),
          size: 14,
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 24, vertical: 16), // Reduced padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About Layla B',
            style: TextStyle(
              color: Color(0xFFE8E7EA),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            "I'm a software engineer passionate about building secure and private communication tools.",
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 14,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 16), // Reduced spacing

          // Username
          _buildInfoItem('Username', 'Layla baby'),

          const SizedBox(height: 12), // Reduced spacing

          // Phone Number
          _buildInfoItem('Phone Number', '+971 57 7563 263'),

          const SizedBox(height: 12), // Reduced spacing

          // Email
          _buildInfoItem('Email', 'laylabmoney@stillur.com'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFE8E7EA),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMediaTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 24, vertical: 12), // Reduced vertical padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTab('Media', 0), // Left
          _buildTab('Files', 1), // Center
          _buildTab('Links', 2), // Right
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final bool isSelected = _selectedTab == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isSelected ? Color(0xFFE8E7EA) : Colors.grey.shade500,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
          // Underline for active tab
          Container(
            height: 2,
            width: title.length * 8.0, // Dynamic width based on text length
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFFE8E7EA) : Colors.transparent,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildMediaGrid();
      case 1:
        return _buildFilesContent();
      case 2:
        return _buildLinksContent();
      default:
        return Container();
    }
  }

  Widget _buildMediaGrid() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 8), // Reduced padding
      child: GridView.builder(
        physics: const BouncingScrollPhysics(), // Better scroll physics
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 3, // Slightly reduced spacing
          mainAxisSpacing: 3, // Slightly reduced spacing
          childAspectRatio: 1,
        ),
        itemCount: 9, // Placeholder count
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(Icons.image, color: Colors.grey, size: 20),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilesContent() {
    return const Center(
      child: Text(
        'No files shared',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildLinksContent() {
    return const Center(
      child: Text(
        'No links shared',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
    );
  }
}
