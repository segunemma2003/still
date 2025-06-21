import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/app/models/contact_info.dart';
import 'package:flutter_app/resources/widgets/alphabet_scroll_view_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '../pages/chat_screen_page.dart';

class ChatsTab extends StatefulWidget {
  const ChatsTab({super.key});

  @override
  createState() => _ChatsTabState();
}

class _ChatsTabState extends NyState<ChatsTab> {
  List<ContactInfo> contactList = [];

  @override
  get init => () {
        _initContactList();
      };

  void _initContactList() {
    contactList = [
      ContactInfo.create(
          name: "Eleanor", imagePath: "image7.png", tagIndex: "E"),
      ContactInfo.create(
          name: "Layla B", imagePath: "image1.png", tagIndex: "L"),
      ContactInfo.create(name: "Gadia", imagePath: "image4.png", tagIndex: "G"),
      ContactInfo.create(
          name: "Arthur", imagePath: "image2.png", tagIndex: "A"),
      ContactInfo.create(
          name: "Amanda", imagePath: "image3.png", tagIndex: "A"),
      ContactInfo.create(
          name: "Al-Amin", imagePath: "image5.png", tagIndex: "A"),
      ContactInfo.create(name: "Ahmad", imagePath: "image2.png", tagIndex: "A"),
      ContactInfo.create(
          name: "Arafat", imagePath: "image10.png", tagIndex: "A"),
      ContactInfo.create(
          name: "Aljandro", imagePath: "image11.png", tagIndex: "A"),
      ContactInfo.create(
          name: "Alberto", imagePath: "image1.png", tagIndex: "A"),
      ContactInfo.create(name: "Ben", imagePath: "image3.png", tagIndex: "B"),
      ContactInfo.create(name: "Brian", imagePath: "image4.png", tagIndex: "B"),
      ContactInfo.create(
          name: "Carlos", imagePath: "image5.png", tagIndex: "C"),
      ContactInfo.create(name: "Chris", imagePath: "image7.png", tagIndex: "C"),
      ContactInfo.create(name: "David", imagePath: "image8.png", tagIndex: "D"),
      ContactInfo.create(
          name: "Daniel", imagePath: "image9.png", tagIndex: "D"),
      ContactInfo.create(
          name: "Frank", imagePath: "image10.png", tagIndex: "F"),
      ContactInfo.create(
          name: "George", imagePath: "image11.png", tagIndex: "G"),
    ];

    // Sort the list with null safety
    contactList.sort((a, b) {
      String nameA = a.name ?? '';
      String nameB = b.name ?? '';
      return nameA.compareTo(nameB);
    });

    // Add section headers
    _handleSectionHeaders();
  }

  void _handleSectionHeaders() {
    String currentTag = "";
    for (int i = 0; i < contactList.length; i++) {
      String? contactName = contactList[i].name;
      if (contactName != null && contactName.isNotEmpty) {
        String tag = contactName[0].toUpperCase();
        if (tag != currentTag) {
          contactList[i].tagIndex = tag;
          contactList[i].isShowSuspension = true;
          currentTag = tag;
        } else {
          contactList[i].isShowSuspension = false;
        }
      } else {
        // Handle contacts with null or empty names
        contactList[i].tagIndex = "#";
        contactList[i].isShowSuspension = false;
      }
    }
  }

  void _showNewChatBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Color(0xFF1C212C),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Color(0xFFE8E7EA), fontSize: 12),
                    ),
                  ),
                  const Text(
                    'New Chat',
                    style: TextStyle(
                      color: Color(0xFFE8E7EA),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 60), // Balance the Cancel button
                ],
              ),
            ),

            // Search bar
            Container(
              height: 14,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F131B),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                style: const TextStyle(color: Color(0xFFE8E7EA)),
                decoration: InputDecoration(
                  hintText: 'Search contact or username',
                  hintStyle:
                      TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(
                      'search.png', // Using image instead of icon
                      width: 16,
                      height: 16,
                      color: Colors.grey.shade500,
                    ).localAsset(),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // New Group and New Contact options
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildOptionItem(
                    iconImage: 'group.png', // Using image instead of icon
                    title: 'New Group',
                    color: const Color(0xFF3498DB),
                  ),
                  const SizedBox(height: 8),
                  _buildOptionItem(
                    iconImage: 'person-add.png', // Using image instead of icon
                    title: 'New Contact',
                    color: const Color(0xFF3498DB),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Recently Contacted header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: Text(
                'Recently Contacted',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Contact list with custom alphabet scroll
            Expanded(
              child: AlphabetScrollView(
                contactList: contactList,
                onContactTap: (contact) {
                  // Handle contact selection
                  Navigator.pop(context);
                  // Navigate to chat screen with selected contact
                  routeTo('/chat-screen', data: {
                    'contact': contact,
                    'userName': contact.name ?? 'Unknown User',
                    'userImage': contact.imagePath,
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem({
    required String iconImage,
    required String title,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        // Handle option tap
        HapticFeedback.lightImpact();
        if (title == 'New Group') {
          // Handle new group creation
          Navigator.pop(context);
          // Add your new group logic here
        } else if (title == 'New Contact') {
          // Handle new contact creation
          Navigator.pop(context);
          // Add your new contact logic here
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  iconImage,
                  width: 13,
                  height: 13,
                  color: Color(0xFFE8E7EA),
                ).localAsset(),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFE8E7EA),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatItem({
    required String name,
    required String message,
    required String time,
    bool isVerified = false,
    bool hasUnread = false,
    bool isOnline = false,
    String? imagePath, // Optional image path
    bool isLastItem = false, // To control whether to show line demarcation
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Navigate to chat screen
            routeTo(ChatScreenPage.path, data: {
              'userName': name,
              'userImage': imagePath,
              'isOnline': isOnline,
              'isVerified': isVerified,
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Avatar with online indicator
                Stack(
                  children: [
                    Container(
                      width: 47,
                      height: 47,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade700, // Placeholder background
                      ),
                      child: imagePath != null
                          ? ClipOval(
                              child: Image.asset(
                                imagePath,
                                width: 47,
                                height: 47,
                                fit: BoxFit.cover,
                              ).localAsset(),
                            )
                          : Icon(
                              Icons.person,
                              color: Colors.grey.shade500,
                              size: 24,
                            ),
                    ),
                    if (isOnline)
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(
                                0xFF2ECC71), // Green online indicator
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xFF1C212C),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),

                // Message content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              name,
                              style: const TextStyle(
                                color: Color(0xFFE8E7EA),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isVerified) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified,
                              color: Color(0xFF3498DB),
                              size: 16,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 8,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Time and unread indicator
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (hasUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF3498DB),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Faint line demarcation (only if not the last item)
        if (!isLastItem)
          Container(
            margin:
                const EdgeInsets.only(left: 76), // Align with message content
            height: 0.5,
            color: Colors.grey.shade800.withOpacity(0.3), // Very faint line
          ),
      ],
    );
  }

  @override
  Widget view(BuildContext context) {
    // List of chat items
    final chatItems = [
      {
        'name': "stillur",
        'message':
            "Hey there Miriam, here are some new updates on the stillur app, to further enhance your private experience.",
        'time': "8:24",
        'isVerified': true,
        'hasUnread': true,
        'imagePath': "stillur.png",
      },
      {
        'name': "Layla B",
        'message':
            "The reviews are very good! I guess we shall see Layla, I have a good feeling about it.",
        'time': "8:24",
        'hasUnread': true,
        'imagePath': "image1.png",
      },
      {
        'name': "Ahmad",
        'message':
            "The reviews are very good! I guess we shall see Layla, I have a good feeling about it.",
        'time': "8:24",
        'isOnline': true,
        'imagePath': "image2.png",
      },
      {
        'name': "Sheilla",
        'message': "The reviews are very good.",
        'time': "8:24",
        'hasUnread': true,
        'imagePath': "image3.png",
      },
      {
        'name': "Gadia",
        'message':
            "The reviews are very good! I guess we shall see Layla, I have a good feeling about it.",
        'time': "8:24",
        'imagePath': "image4.png",
      },
      {
        'name': "Our Loving Pets",
        'message':
            "You: The reviews are very good! I guess we shall see Layla, I have a good feeling about it.",
        'time': "8:24",
        'imagePath': "image5.png",
      },
      {
        'name': "Rodriga",
        'message':
            "The reviews are very good! I guess we shall see Layla, I have a good feeling about it.",
        'time': "8:24",
        'hasUnread': true,
        'imagePath': "image10.png",
      },
      {
        'name': "Eleanor",
        'message':
            "The reviews are very good! I guess we shall see Layla, I have a good feeling about it.",
        'time': "8:24",
        'hasUnread': true,
        'imagePath': "image7.png",
      },
      {
        'name': "Layla B",
        'message':
            "The reviews are very good! I guess we shall see Layla, I have a good feeling about it.",
        'time': "8:24",
        'hasUnread': true,
        'imagePath': "image8.png",
      },
      {
        'name': "Fast Cars and Tracks",
        'message':
            "Simple: The reviews are very good! I guess we shall see Layla, I have a good feeling about it.",
        'time': "8:24",
        'hasUnread': true,
        'imagePath': "image9.png",
      },
      {
        'name': "Our Loving Pets",
        'message':
            "You: The reviews are very good! I guess we shall see Layla, I have a good feeling about it.",
        'time': "8:24",
        'imagePath': "image11.png",
      },
      {
        'name': "Rodriga",
        'message':
            "The reviews are very good! I guess we shall see Layla, I have a good feeling about it.",
        'time': "8:24",
        'hasUnread': true,
        'imagePath': "image3.png",
      },
      {
        'name': "Eleanor",
        'message':
            "The reviews are very good! I guess we shall see Layla, I have a good feeling about it.",
        'time': "8:24",
        'hasUnread': true,
        'imagePath': "image1.png",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F131B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C212C),
        elevation: 3,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            width: 16,
            height: 16,
            child: Image.asset(
              'add-a-photo.png', // Using image instead of icon
              width: 16,
              height: 16,
              color: Color(0xFFE8E7EA), // Tint the image
            ).localAsset(),
          ),
          onPressed: () {},
        ),
        title: Text(
          'Chats',
          style: TextStyle(
            color: Color(0xFFE8E7EA),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            iconSize: 16,
            icon: const Icon(Icons.search, color: Color(0xFFE8E7EA)),
            onPressed: () {},
          ),
          IconButton(
            iconSize: 16,
            icon: const Icon(Icons.add, color: Color(0xFFE8E7EA)),
            onPressed: () => _showNewChatBottomSheet(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: chatItems.length,
        itemBuilder: (context, index) {
          final item = chatItems[index];
          final isLastItem = index == chatItems.length - 1;

          return _buildChatItem(
            name: item['name'] as String,
            message: item['message'] as String,
            time: item['time'] as String,
            isVerified: item['isVerified'] as bool? ?? false,
            hasUnread: item['hasUnread'] as bool? ?? false,
            isOnline: item['isOnline'] as bool? ?? false,
            imagePath: item['imagePath'] as String?,
            isLastItem: isLastItem,
          );
        },
      ),
    );
  }
}
