import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class ProfileDetailsPage extends NyStatefulWidget {
  static RouteView path = ("/profile-details", (_) => ProfileDetailsPage());

  ProfileDetailsPage({super.key})
      : super(child: () => _ProfileDetailsPageState());
}

class _ProfileDetailsPageState extends NyPage<ProfileDetailsPage> {
  int _selectedTab = 0; // 0: Media, 1: Files, 2: Links
  final ScrollController _scrollController = ScrollController();
  bool _showCollapsedHeader = false;

  final List<String> _mediaImages = [
    'image40.jpg',
    'image50.jpg',
    'image60.jpg'
  ];

  @override
  get init => () {
        _scrollController.addListener(_onScroll);
      };

  void _onScroll() {
    final showCollapsed = _scrollController.offset > 200;
    if (showCollapsed != _showCollapsedHeader) {
      setState(() {
        _showCollapsedHeader = showCollapsed;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F131B),
      body: SafeArea(
        child: Column(
          children: [
            // Dynamic Header
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _showCollapsedHeader ? 60 : 0,
              child:
                  _showCollapsedHeader ? _buildCollapsedHeader() : Container(),
            ),

            // Main Content with ScrollView
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Profile Info Section
                    _buildProfileInfo(),

                    // Action Buttons
                    _buildActionButtons(),

                    // About Section (always visible)
                    _buildAboutSection(),

                    // Media Tabs
                    _buildMediaTabs(),

                    // Content based on selected tab
                    _buildTabContent(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsedHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF0F131B),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF1C212C),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFFE8E7EA),
              size: 16,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Layla B',
            style: TextStyle(
              color: Color(0xFFE8E7EA),
              fontSize: 18,
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.w400,
              height: 21 / 18,
              letterSpacing: 0,
            ),
          ),
          const Spacer(),
          Text(
            _getTabCount(),
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.w400,
              height: 21 / 14,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }

  String _getTabCount() {
    switch (_selectedTab) {
      case 0:
        return '20 media';
      case 1:
        return '8 files';
      case 2:
        return '10 links';
      default:
        return '';
    }
  }

  Widget _buildProfileInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
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
              fontSize: 20,
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.w400,
              height: 21 / 20,
              letterSpacing: 0,
            ),
          ),

          const SizedBox(height: 4),

          // Last Seen
          Text(
            'Last seen 3 hours ago',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.w400,
              height: 21 / 14,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 32),
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
        child: Icon(
          icon,
          color: const Color(0xFFE8E7EA),
          size: 24,
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About Layla B',
            style: TextStyle(
              color: Color(0xFFE8E7EA),
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: 'PlusJakartaSans',
              height: 21 / 16,
              letterSpacing: 0,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            "I'm a software engineer passionate about building secure and private communication tools.",
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 14,
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.w400,
              height: 21 / 14,
              letterSpacing: 0,
            ),
          ),

          const SizedBox(height: 16),

          // Username
          _buildInfoItem('Username', 'Layla baby'),

          const SizedBox(height: 12),

          // Phone Number
          _buildInfoItem('Phone Number', '+971 57 7563 263'),

          const SizedBox(height: 12),

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
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.w400,
            height: 21 / 12,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFE8E7EA),
            fontSize: 14,
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.w400,
            height: 21 / 14,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildMediaTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTab('Media', 0),
          _buildTab('Files', 1),
          _buildTab('Links', 2),
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
              color:
                  isSelected ? const Color(0xFFE8E7EA) : Colors.grey.shade500,
              fontSize: 14,
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.w400,
              height: 21 / 14,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 4),
          // Underline for active tab
          Container(
            height: 2,
            width: title.length * 8.0,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFE8E7EA) : Colors.transparent,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          childAspectRatio: 1,
        ),
        itemCount: 20,
        itemBuilder: (context, index) {
          return Container(
            child: Image.asset(
              _mediaImages[index % _mediaImages.length],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ).localAsset(),
          );
        },
      ),
    );
  }

  Widget _buildFilesContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          _buildFileItem(
              'Image.png', '2.6 MB', 'mar 3, 2025 at 12:46', Icons.image),
          _buildFileItem('Stillur.zip', '2.6 MB', 'mar 3, 2025 at 12:46',
              Icons.folder_zip),
          _buildFileItem('Stillur.xlsx', '2.6 MB', 'mar 3, 2025 at 12:46',
              Icons.table_chart),
          _buildFileItem('Stillur.pdf', '2.6 MB', 'mar 3, 2025 at 12:46',
              Icons.picture_as_pdf),
          _buildFileItem(
              'Stillur.zip', '2.6 MB', 'mar 3, 2025 at 12:46', Icons.folder_zip,
              showDownload: true),
          _buildFileItem('Stillur.xlsx', '2.6 MB', 'mar 3, 2025 at 12:46',
              Icons.table_chart,
              showDownload: true),
          _buildFileItem('Stillur.pdf', '2.6 MB', 'mar 3, 2025 at 12:46',
              Icons.picture_as_pdf,
              showDownload: true),
          _buildFileItem(
              'Stillur.zip', '2.6 MB', 'mar 3, 2025 at 12:46', Icons.folder_zip,
              showDownload: true),
        ],
      ),
    );
  }

  Widget _buildFileItem(
      String fileName, String fileSize, String date, IconData icon,
      {bool showDownload = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C212C),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: Colors.grey.shade300,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(
                    color: Color(0xFFE8E7EA),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$fileSize • $date',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (showDownload)
            Icon(
              Icons.download,
              color: Colors.grey.shade400,
              size: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildLinksContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          _buildLinkItem(
              'Google',
              'Real-time meetings by Google. Using your browser, share your video, desktop, and presentations with teammates and customers...',
              'https://meet.google.com/landing'),
          _buildLinkItem(
              'Google',
              'Real-time meetings by Google. Using your browser, share your video, desktop, and presentations with teammates and customers...',
              'https://meet.google.com/landing'),
          _buildLinkItem(
              'Google',
              'Real-time meetings by Google. Using your browser, share your video, desktop, and presentations with teammates and customers...',
              'https://meet.google.com/landing'),
          _buildLinkItem(
              'Google',
              'Real-time meetings by Google. Using your browser, share your video, desktop, and presentations with teammates and customers...',
              'https://meet.google.com/landing'),
          _buildMonthSeparator('July 2025'),
          _buildLinkItem(
              'Google',
              'Real-time meetings by Google. Using your browser, share your video, desktop, and presentations with teammates and customers...',
              'https://meet.google.com/landing'),
          _buildLinkItem(
              'Google',
              'Real-time meetings by Google. Using your browser, share your video, desktop, and presentations with teammates and customers...',
              'https://meet.google.com/landing'),
          _buildLinkItem(
              'Google',
              'Real-time meetings by Google. Using your browser, share your video, desktop, and presentations with teammates and customers...',
              'https://meet.google.com/landing'),
          _buildLinkItem(
              'Google',
              'Real-time meetings by Google. Using your browser, share your video, desktop, and presentations with teammates and customers...',
              'https://meet.google.com/landing'),
          _buildMonthSeparator('June 2025'),
          _buildLinkItem(
              'Google',
              'Real-time meetings by Google. Using your browser, share your video, desktop, and presentations with teammates and customers...',
              'https://meet.google.com/landing'),
        ],
      ),
    );
  }

  Widget _buildLinkItem(String title, String description, String url) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C212C),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.shade600,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.videocam,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFE8E7EA),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  url,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSeparator(String month) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey.shade700,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              month,
              style: const TextStyle(
                color: Color(0xFFE8E7EA),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
