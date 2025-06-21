import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nylo_framework/nylo_framework.dart';

class ChannelsTab extends StatefulWidget {
  const ChannelsTab({super.key});

  @override
  createState() => _ChannelsTabState();
}

class _ChannelsTabState extends NyState<ChannelsTab> {
  bool _showMyChannels = true;
  List<Channel> _myChannels = [];
  List<Channel> _joinedChannels = [
    Channel(
      name: "Fast Cars Reviewers Club",
      description:
          "McLaren Artura Spider, A combination of Twin-Turbocharged V6 Petrol Engine and powerful, ultra-efficient...",
      image: "image9.png",
      hasNotification: true,
    ),
    Channel(
      name: "Fast Cars Reviewers Club",
      description:
          "McLaren Artura Spider, A combination of Twin-Turbocharged V6 Petrol Engine and powerful, ultra-efficient...",
      image: "image9.png",
      hasNotification: true,
    ),
    Channel(
      name: "Fast Cars Reviewers Club",
      description:
          "McLaren Artura Spider, A combination of Twin-Turbocharged V6 Petrol Engine and powerful, ultra-efficient...",
      image: "image9.png",
      hasNotification: true,
    ),
  ];

  final List<Contact> _contacts = [
    Contact(name: "Layla B", image: "image2.png"),
    Contact(name: "Eleanor", image: "image1.png"),
    Contact(name: "Sheilla", image: "image5.png"),
    Contact(name: "Sandra", image: "image4.png"),
    Contact(name: "Fenta", image: "image8.png"),
    Contact(name: "Arthur", image: "image6.png"),
    Contact(name: "Amanda", image: "image7.png"),
    Contact(name: "Al-Amin", image: "image3.png"),
    Contact(name: "Ahmad", image: "image10.png"),
  ];

  @override
  get init => () {};

  void _showCreateChannelFlow() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CreateChannelStep1(),
    );
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F131B),
      body: Column(
        children: [
          // Top section with Stillur branding and tabs
          Container(
            padding:
                const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
            child: Column(
              children: [
                // Stillur branding row
                Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          child: Image.asset('stillur.png').localAsset(),
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'stillur',
                          style: TextStyle(
                            color: Color(0xFFE8E7EA),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.search, color: Color(0xFFE8E7EA)),
                      onPressed: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Tabs row
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showMyChannels = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          border: _showMyChannels
                              ? const Border(
                                  bottom: BorderSide(
                                      color: Color(0xFFE8E7EA), width: 2))
                              : null,
                        ),
                        child: Text(
                          'My Channels',
                          style: TextStyle(
                            color: _showMyChannels
                                ? Color(0xFFE8E7EA)
                                : Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 32),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showMyChannels = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          border: !_showMyChannels
                              ? const Border(
                                  bottom: BorderSide(
                                      color: Color(0xFFE8E7EA), width: 2))
                              : null,
                        ),
                        child: Text(
                          'Joined Channels',
                          style: TextStyle(
                            color: !_showMyChannels
                                ? Color(0xFFE8E7EA)
                                : Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content area
          Expanded(
            child: _showMyChannels
                ? _buildMyChannelsView()
                : _buildJoinedChannelsView(),
          ),
        ],
      ),
    );
  }

  Widget _buildMyChannelsView() {
    if (_myChannels.isEmpty) {
      return Column(
        children: [
          // Empty state content first
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Folder image placeholder
                Container(
                  width: 200,
                  height: 120,
                  child: Image.asset(
                    'channel.png', // Replace with your actual image
                    fit: BoxFit.contain,
                  ).localAsset(),
                ),

                const SizedBox(height: 32),

                const Text(
                  'Be a part of a Private Channels',
                  style: TextStyle(
                    color: Color(0xFFE8E7EA),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Your created or joined channels will\nshow up here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF8E9297),
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 40),

                // Create My Channel button moved below the text
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _showCreateChannelFlow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C212C),
                      foregroundColor: Color(0xFFE8E7EA),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 14),
                        SizedBox(width: 8),
                        Text('Create My Channel',
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return _buildChannelsList(_myChannels);
    }
  }

  Widget _buildJoinedChannelsView() {
    return Column(
      children: [
        // Create My Channel button
        Container(
          margin: const EdgeInsets.all(16),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _showCreateChannelFlow,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1C212C),
              foregroundColor: Color(0xFFE8E7EA),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 14),
                SizedBox(width: 8),
                Text('Create My Channel', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
        Expanded(child: _buildChannelsList(_joinedChannels)),
      ],
    );
  }

  Widget _buildChannelsList(List<Channel> channels) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: channels.length,
      itemBuilder: (context, index) {
        final channel = channels[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1C212C),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade700,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    channel.image,
                    fit: BoxFit.cover,
                  ).localAsset(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      channel.name,
                      style: const TextStyle(
                        color: Color(0xFFE8E7EA),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      channel.description,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (channel.hasNotification)
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3498DB),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _CreateChannelStep1() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
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
                    style: TextStyle(color: Color(0xFFE8E7EA), fontSize: 16),
                  ),
                ),
                const Text(
                  'Create Channel',
                  style: TextStyle(
                    color: Color(0xFFE8E7EA),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 60),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Camera icon and Channel Name on same row
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFF3498DB), width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Color(0xFF3498DB),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: nameController,
                          style: const TextStyle(color: Color(0xFFE8E7EA)),
                          decoration: InputDecoration(
                            hintText: 'Channel Name',
                            hintStyle: TextStyle(
                                color: Colors.grey.shade400, fontSize: 12),
                            filled: true,
                            fillColor: const Color(0xFF0F131B),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Description field
                  TextField(
                    controller: descriptionController,
                    style: const TextStyle(color: Color(0xFFE8E7EA)),
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      hintStyle:
                          TextStyle(color: Colors.grey.shade400, fontSize: 12),
                      filled: true,
                      fillColor: const Color(0xFF0F131B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'You can provide an optional description for your channel',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),

                  const Spacer(),

                  // Next button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showChannelTypeSettings(
                            nameController.text, descriptionController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3498DB),
                        foregroundColor: Color(0xFFE8E7EA),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showChannelTypeSettings(String channelName, String description) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _ChannelTypeScreen(channelName, description),
      ),
    );
  }

  Widget _ChannelTypeScreen(String channelName, String description) {
    bool isPrivate = true;
    bool restrictContent = false;

    return StatefulBuilder(
      builder: (context, setModalState) {
        return Scaffold(
          backgroundColor: Color(0xFF0F131B),
          appBar: AppBar(
            backgroundColor: Color(0xFF0F131B),
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFE8E7EA)),
            ),
            title: const Text(
              'Channel Type',
              style: TextStyle(
                color: Color(0xFFE8E7EA),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showContactSelection();
                },
                child: const Text(
                  'Next',
                  style: TextStyle(color: Color(0xFF3498DB), fontSize: 16),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Public option
                  GestureDetector(
                    onTap: () {
                      setModalState(() {
                        isPrivate = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Color(0xFFE8E7EA), width: 2),
                              color: !isPrivate
                                  ? const Color(0xFF3498DB)
                                  : Colors.transparent,
                            ),
                            child: !isPrivate
                                ? const Icon(Icons.circle,
                                    color: Color(0xFFE8E7EA), size: 12)
                                : null,
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Public',
                            style: TextStyle(
                                color: Color(0xFFE8E7EA), fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Private option
                  GestureDetector(
                    onTap: () {
                      setModalState(() {
                        isPrivate = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Color(0xFFE8E7EA), width: 2),
                              color: isPrivate
                                  ? const Color(0xFF3498DB)
                                  : Colors.transparent,
                            ),
                            child: isPrivate
                                ? const Icon(Icons.circle,
                                    color: Color(0xFFE8E7EA), size: 12)
                                : null,
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Private',
                            style: TextStyle(
                                color: Color(0xFFE8E7EA), fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (isPrivate) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Private channel can only be joined via link',
                      style:
                          TextStyle(color: Colors.grey.shade400, fontSize: 12),
                    ),

                    const SizedBox(height: 32),

                    // Invite Link section
                    Text(
                      'INVITE LINK',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C212C),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              's.me/+CGHSDhdkgjudkj',
                              style: TextStyle(
                                  color: Colors.grey.shade300, fontSize: 14),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                            },
                            child: const Icon(Icons.more_horiz,
                                color: Color(0xFFE8E7EA)),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3498DB),
                          foregroundColor: Color(0xFFE8E7EA),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Share Link',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'People can join channel by following this link.\nYou can revoke the link at any time.',
                      style:
                          TextStyle(color: Colors.grey.shade400, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    // Saving and Copying Content section
                    Text(
                      'SAVING AND COPYING CONTENT',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Restrict Saving Content',
                          style:
                              TextStyle(color: Color(0xFFE8E7EA), fontSize: 16),
                        ),
                        Switch(
                          value: restrictContent,
                          onChanged: (value) {
                            setModalState(() {
                              restrictContent = value;
                            });
                          },
                          activeColor: const Color(0xFF3498DB),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Subscribe will be able to copy, save and forward\ncontent from this channel',
                      style:
                          TextStyle(color: Colors.grey.shade400, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showContactSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ContactSelection(),
    );
  }

  Widget _ContactSelection() {
    List<Contact> selectedContacts = [];

    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
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
                        style:
                            TextStyle(color: Color(0xFFE8E7EA), fontSize: 16),
                      ),
                    ),
                    const Text(
                      'Contact',
                      style: TextStyle(
                        color: Color(0xFFE8E7EA),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 60),
                  ],
                ),
              ),

              // Search bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F131B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey, size: 14),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Color(0xFFE8E7EA)),
                        decoration: InputDecoration(
                          hintText: 'Search contact or username',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Recent contacts row
              Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final contact = _contacts[index];
                    return Container(
                      margin: const EdgeInsets.only(right: 16),
                      child: Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade700,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                contact.image,
                                fit: BoxFit.cover,
                              ).localAsset(),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            contact.name,
                            style: const TextStyle(
                              color: Color(0xFFE8E7EA),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Invite link
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F131B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3498DB),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.content_copy,
                        color: Color(0xFFE8E7EA),
                        size: 12,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      's.me/+CGHSDhdkgjudkj',
                      style: TextStyle(color: Color(0xFF3498DB), fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Frequently Contacted section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Frequently Contacted',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Contacts list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _contacts.length,
                  itemBuilder: (context, index) {
                    final contact = _contacts[index];
                    final isSelected = selectedContacts.contains(contact);

                    return GestureDetector(
                      onTap: () {
                        setModalState(() {
                          if (isSelected) {
                            selectedContacts.remove(contact);
                          } else {
                            selectedContacts.add(contact);
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade700,
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  contact.image,
                                  fit: BoxFit.cover,
                                ).localAsset(),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                contact.name,
                                style: const TextStyle(
                                  color: Color(0xFFE8E7EA),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade600),
                                color: isSelected
                                    ? const Color(0xFF3498DB)
                                    : Colors.transparent,
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check,
                                      color: Color(0xFFE8E7EA), size: 14)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Send button
              Container(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Complete channel creation
                      Navigator.pop(context);
                      setState(() {
                        _myChannels.add(Channel(
                          name: "New Channel",
                          description: "Channel description...",
                          image: "image9.png",
                          hasNotification: false,
                        ));
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3498DB),
                      foregroundColor: Color(0xFFE8E7EA),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Send',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.send, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Channel {
  final String name;
  final String description;
  final String image;
  final bool hasNotification;

  Channel({
    required this.name,
    required this.description,
    required this.image,
    this.hasNotification = false,
  });
}

class Contact {
  final String name;
  final String image;

  Contact({
    required this.name,
    required this.image,
  });
}
