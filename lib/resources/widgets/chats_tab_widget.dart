import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/app/models/contact_info.dart';
import 'package:flutter_app/resources/widgets/alphabet_scroll_view_widget.dart';
import 'package:flutter_svg/svg.dart';
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
          color: Color(0xFF1B1C1D),
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
              width: 84,
              height: 4,
              decoration: BoxDecoration(
                color: Color(0xFFC4C6C8),
                borderRadius: BorderRadius.circular(2),
              ),
            ).onTap(() => Navigator.pop(context)),

            // Header
            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  const Text(
                    'New Chat',
                    style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 60), // Balance the Cancel button
                ],
              ),
            ),

            // Search bar
            Container(
              height: 50, // Increased height to accommodate the text properly
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.transparent, // Make background transparent
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade600, // Bottom border color
                    width: 1.0,
                  ),
                ),
              ),
              child: TextField(
                style: const TextStyle(color: Color(0xFFE8E7EA)),
                decoration: InputDecoration(
                  hintText: 'Search contact or username',
                  hintStyle:
                      TextStyle(color: Colors.grey.shade500, fontSize: 18),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade500,
                    size: 20,
                  ),
                  border: InputBorder.none, // Remove all default borders
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 4),

            // New Group and New Contact options
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                children: [
                  _buildOptionItem(
                    iconImage: 'group.png', // Using image instead of icon
                    title: 'New Group',
                    color: const Color(0xFF57A1FF),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    // Align with message content
                    height: 0.5,

                    color: Color(0xFF2B2A30), // Very faint line
                  ),
                  const SizedBox(height: 4),
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
                  color: Color(0xFF82808F),
                  fontSize: 16,
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
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
                  width: 16,
                  height: 16,
                  color: Color(0xFF57A1FF),
                ).localAsset(),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF57A1FF),
                fontSize: 16,
                fontWeight: FontWeight.w300,
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
            padding: EdgeInsets.fromLTRB(16, 18, 16, 8),
            child: Row(
              children: [
                // Avatar with online indicator
                Stack(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade700, // Placeholder background
                      ),
                      child: imagePath != null
                          ? ClipOval(
                              child: Image.asset(
                                imagePath,
                                width: 54,
                                height: 54,
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
                                  letterSpacing: 0.5,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
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
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
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
                        color: Color(0xff9D9C9C),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (hasUnread)
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Color(0xFF57A1FF), Color(0xFF3B69C6)]),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '12', // Your text here
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  12, // Small font size to fit in 12x12 container
                              fontWeight: FontWeight.w700,
                            ),
                          ),
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
    // List of chat items - "stillur" is now at the top
    final chatItems = [
      {
        'name': "stillur",
        'message':
            "Hey there Miriam, here are some new updates on the stillur app, to further enhance your private experience.",
        'time': "8:21",
        'isVerified': true,
        'hasUnread': true,
        'imagePath': "stillur.png",
      },
      {
        'name': "Layla B",
        'message':
            "The reviews are very good! I guess we shall see Layla, I have a good feeling about it.",
        'time': "8:21",
        'hasUnread': true,
        'imagePath': "image1.png",
      },
      {
        'name': "Ahmad",
        'message':
            "The reviews are very good! I guess we shall see Layla, I have a good feeling about it.",
        'time': "8:21",
        'isOnline': true,
        'imagePath': "image2.png",
      },
      {
        'name': "Sheilla",
        'message': "The reviews are very good.",
        'time': "8:21",
        'hasUnread': true,
        'imagePath': "image3.png",
      },
      {
        'name': "Gadia",
        'message':
            "The reviews are very good! I guess we shall see Layla, I have a good feeling about it.",
        'time': "8:21",
        'imagePath': "image4.png",
      },
      {
        'name': "Our Loving Pets",
        'message':
            "You: The reviews are very good! I guess we shall see Layla, I have a good feeling about it.",
        'time': "8:21",
        'imagePath': "image5.png",
      },
      {
        'name': "Rodriga",
        'message':
            "The reviews are very good! I guess we shall see Layla, I have a good feeling about it.",
        'time': "8:21",
        'hasUnread': true,
        'imagePath': "image10.png",
      },
      {
        'name': "Eleanor",
        'message':
            "The reviews are very good! I guess we shall see Layla, I have a good feeling about it.",
        'time': "8:21",
        'hasUnread': true,
        'imagePath': "image7.png",
      },
      {
        'name': "Layla B",
        'message':
            "The reviews are very good! I guess we shall see Layla, I have a good feeling about it.",
        'time': "8:21",
        'hasUnread': true,
        'imagePath': "image8.png",
      },
      {
        'name': "Fast Cars and Tracks",
        'message':
            "Samad: The reviews are very good! I guess we shall see Layla, I have a good feeling about it.",
        'time': "8:21",
        'hasUnread': true,
        'imagePath': "image9.png",
      },
      {
        'name': "Our Loving Pets",
        'message':
            "You: The reviews are very good! I guess we shall see Layla, I have a good feeling about it.",
        'time': "8:21",
        'imagePath': "image11.png",
      },
      {
        'name': "Rodriga",
        'message':
            "The reviews are very good! I guess we shall see Layla, I have a good feeling about it.",
        'time': "8:21",
        'hasUnread': true,
        'imagePath': "image3.png",
      },
      {
        'name': "Eleanor",
        'message':
            "The reviews are very good! I guess we shall see Layla, I have a good feeling about it.",
        'time': "8:21",
        'hasUnread': true,
        'imagePath': "image1.png",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F131B),
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(140), // Increased height for search bar
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: AppBar(
              backgroundColor: const Color(0xFF1C212C),
              elevation: 3,
              automaticallyImplyLeading: false, // Remove default back button
              flexibleSpace: SafeArea(
                child: Column(
                  children: [
                    // Top row with logo, title, and action buttons
                    Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          // Top row - Logo centered
                          // Container(
                          //   height: 10,
                          //   alignment: Alignment.topLeft,
                          //   child: Container(
                          //     width: 50,
                          //     height: 13,
                          //     child: Image.asset(
                          //       'stillurlogo.png',
                          //       width: 50,
                          //       height: 13,
                          //     ).localAsset(),
                          //   ),
                          // ),

                          // Bottom row - Edit, Chats, Icons
                          Container(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Left - Edit
                                Text(
                                  'Edit',
                                  style: TextStyle(
                                    color: Color(0xFF3498DB),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),

                                // Center - Chats
                                Text(
                                  'Chats',
                                  style: TextStyle(
                                    color: Color(0xFFE8E7EA),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),

                                // Right - Action buttons (closer together)
                                Row(
                                  children: [
                                    Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: IconButton(
                                        icon: Container(
                                          width: 20,
                                          height: 20,
                                          child: Image.asset(
                                            'add-a-photo.png',
                                            width: 20,
                                            height: 20,
                                            color: Color(0xFFE8E7EA),
                                          ).localAsset(),
                                        ),
                                        onPressed: () {},
                                        padding: EdgeInsets.zero,
                                      ),
                                    ),
                                    const SizedBox(
                                        width: 8), // Much closer spacing

                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Color.lerp(Color(0xffD0DBFF),
                                                Color(0xff5B67D1), 0.5)!
                                            .withValues(alpha: 0.5),
                                        borderRadius: BorderRadius.circular(
                                            3), // 3px border radius
                                      ),
                                      child: Center(
                                        // Center the icon within the container
                                        child: SvgPicture.asset(
                                          'public/images/plus_icon.svg',
                                          width: 11,
                                          height: 11,
                                          colorFilter: ColorFilter.mode(
                                            Color(0xffffffff), // White color
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ).onTap(() {
                                      _showNewChatBottomSheet(context);
                                    })
                                    // Container(
                                    //   width: 20,
                                    //   height: 20,
                                    //   decoration: BoxDecoration(
                                    //     color: Color.lerp(Color(0xffD0DBFF),
                                    //             Color(0xff5B67D1), 0.5)!
                                    //         .withValues(
                                    //             alpha:
                                    //                 0.5), // Your mixed blue background
                                    //   ),
                                    //   child: Image.asset(
                                    //     'plus_icon.png',
                                    //     width: 20,
                                    //     height: 20,
                                    //     color: Color(0xffffffff),
                                    //     // Remove the color property to stop tinting the icon
                                    //   ).localAsset(),

                                    //   // IconButton(
                                    //   //   icon: const Icon(
                                    //   //     Icons.add,
                                    //   //     color: Colors.white,
                                    //   //     size: 18,
                                    //   //   ),
                                    //   //   onPressed: () =>
                                    //   //       _showNewChatBottomSheet(context),
                                    //   //   padding: EdgeInsets.zero,
                                    //   // ),
                                    // ).onTap(() {
                                    //   _showNewChatBottomSheet(context);
                                    // })
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // Align with message content
                      height: 0.5,

                      color: Color(0xFF2B2A30), // Very faint line
                    ),
                    // Search bar
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 65,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F131B),
                          borderRadius:
                              BorderRadius.circular(5.0), // 5px border radius

                          // borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          style: const TextStyle(color: Color(0xFFE8E7EA)),
                          // textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey.shade500,
                              size: 16,
                            ),
                            suffixIcon: Image.asset(
                              'public/images/suffix_icon.png', // or .jpg, .jpeg, etc.
                              width: 12,
                              height: 12,
                              color: const Color(
                                  0xffE8E7EA), // This applies color filter
                            ),

                            // SvgPicture.asset(
                            //   'public/images/suffix_icon.svg',
                            //   width: 12, // optional: set desired size
                            //   height: 12,
                            //   alignment: Alignment.center,
                            //   colorFilter: ColorFilter.mode(
                            //     Color(0xffE8E7EA),
                            //     BlendMode.srcIn,
                            //   ), // optional: set desired size
                            // ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Stillur logo and Edit button row

          // Chat list
          Expanded(
            child: ListView.builder(
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
          ),
        ],
      ),
    );
  }
}
