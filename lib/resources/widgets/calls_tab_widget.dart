import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class CallsTab extends StatefulWidget {
  const CallsTab({super.key});

  @override
  createState() => _CallsTabState();
}

class _CallsTabState extends NyState<CallsTab> {
  bool _showHistory = false;

  // Sample data
  final List<Contact> _contacts = [
    Contact(name: "Eleanor", image: "image1.png", isOnline: true),
    Contact(name: "Layla B", image: "image2.png", isOnline: false),
    Contact(name: "Gadia", image: "image3.png", isOnline: true),
    Contact(name: "Sandra", image: "image4.png", isOnline: false),
    Contact(name: "Sheilla", image: "image5.png", isOnline: true),
    Contact(name: "Ahmed", image: "image6.png", isOnline: false),
    Contact(name: "Rodriga", image: "image7.png", isOnline: true),
    Contact(name: "Fenta", image: "image8.png", isOnline: false),
  ];

  final List<CallHistory> _callHistory = [
    CallHistory(
      contact: Contact(name: "Eleanor", image: "image1.png"),
      time: "08:24PM",
      type: CallType.incoming,
      duration: "10 minutes 3 minutes",
    ),
    CallHistory(
      contact: Contact(name: "Layla B", image: "image2.png"),
      time: "11:23AM",
      type: CallType.outgoing,
      duration: "20 outgoing minutes",
      count: 2,
    ),
    CallHistory(
      contact: Contact(name: "Sheilla", image: "image5.png"),
      time: "09:23AM",
      type: CallType.incoming,
      duration: "10 incoming 6 minutes",
    ),
    CallHistory(
      contact: Contact(name: "Fast Cars and tracks", image: "image9.png"),
      time: "Yesterday",
      type: CallType.missed,
      duration: "Missed",
    ),
    CallHistory(
      contact: Contact(name: "Gadia", image: "image3.png"),
      time: "Yesterday",
      type: CallType.missed,
      duration: "Missed",
    ),
    CallHistory(
      contact: Contact(name: "Sandra", image: "image4.png"),
      time: "Yesterday",
      type: CallType.outgoing,
      duration: "3 outgoing minutes",
      count: 4,
    ),
  ];

  @override
  get init => () {};

  void _showNewCallBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildNewCallBottomSheet(),
    );
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F131B),
      appBar: AppBar(
        backgroundColor: Color(0xFF1C212C),
        elevation: 0,
        title: const Text(
          'Calls',
          style: TextStyle(
            color: Color(0xFFE8E7EA),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_showHistory)
            TextButton(
              onPressed: () {
                setState(() {
                  _showHistory = false;
                });
              },
              child: const Text(
                'Back',
                style: TextStyle(color: Color(0xFFE8E7EA)),
              ),
            ),
        ],
      ),
      body: _showHistory ? _buildCallHistory() : _buildMainCallsView(),
    );
  }

  Widget _buildMainCallsView() {
    return Column(
      children: [
        // Make private calls section
        Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(
                Icons.phone,
                size: 40,
                color: Color(0xFF6C7B7F),
              ),
              const SizedBox(height: 24),
              const Text(
                'Make private calls',
                style: TextStyle(
                  color: Color(0xFFE8E7EA),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your recent voice and video calls will\nappear here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF8E9297),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _showNewCallBottomSheet,
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
                      Text('Start Call', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Make your first call now section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Make your first call now',
                      style: TextStyle(
                        color: Color(0xFFE8E7EA),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showHistory = true;
                        });
                      },
                      child: const Text(
                        'History',
                        style: TextStyle(color: Color(0xFF3498DB)),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _contacts.length,
                  itemBuilder: (context, index) {
                    final contact = _contacts[index];
                    return _buildContactItem(contact);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem(Contact contact) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 48,
                height: 48,
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
              if (contact.isOnline)
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2ECC71),
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFF0F131B), width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              contact.name,
              style: const TextStyle(
                color: Color(0xFFE8E7EA),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.call,
              color: Color(0xFFE8E7EA),
              size: 22,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.videocam,
              color: Color(0xFFE8E7EA),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            'Call History',
            style: TextStyle(
              color: Color(0xFFE8E7EA),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _callHistory.length,
            itemBuilder: (context, index) {
              final call = _callHistory[index];
              return _buildCallHistoryItem(call);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCallHistoryItem(CallHistory call) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade700,
            ),
            child: ClipOval(
              child: Image.asset(
                call.contact.image,
                fit: BoxFit.cover,
              ).localAsset(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      call.contact.name,
                      style: const TextStyle(
                        color: Color(0xFFE8E7EA),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (call.count != null) ...[
                      const SizedBox(width: 4),
                      Text(
                        '(${call.count})',
                        style: const TextStyle(
                          color: Color(0xFFE8E7EA),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      _getCallIcon(call.type),
                      size: 14,
                      color: _getCallColor(call.type),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      call.duration,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                call.time,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              const Icon(
                Icons.info_outline,
                color: Colors.grey,
                size: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewCallBottomSheet() {
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
                  'New Call',
                  style: TextStyle(
                    color: Color(0xFFE8E7EA),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 60), // Balance the cancel button
              ],
            ),
          ),

          // Search bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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

          const SizedBox(height: 20),

          // Create New Call Link
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3498DB),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.link,
                    color: Color(0xFFE8E7EA),
                    size: 14,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Create New Call Link',
                  style: TextStyle(
                    color: Color(0xFF3498DB),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
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
                return Container(
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
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade600),
                        ),
                        child: const Icon(
                          Icons.phone,
                          color: Color(0xFFE8E7EA),
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Bottom buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Video Call button
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F131B),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.videocam,
                            color: Color(0xFFE8E7EA), size: 14),
                        SizedBox(width: 8),
                        Text(
                          'Video Call',
                          style:
                              TextStyle(color: Color(0xFFE8E7EA), fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Call button
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3498DB),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.call, color: Color(0xFFE8E7EA), size: 14),
                        SizedBox(width: 8),
                        Text(
                          'Call',
                          style:
                              TextStyle(color: Color(0xFFE8E7EA), fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCallIcon(CallType type) {
    switch (type) {
      case CallType.incoming:
        return Icons.call_received;
      case CallType.outgoing:
        return Icons.call_made;
      case CallType.missed:
        return Icons.call_received;
    }
  }

  Color _getCallColor(CallType type) {
    switch (type) {
      case CallType.incoming:
        return const Color(0xFF2ECC71);
      case CallType.outgoing:
        return Colors.grey;
      case CallType.missed:
        return const Color(0xFFE74C3C);
    }
  }
}

class Contact {
  final String name;
  final String image;
  final bool isOnline;

  Contact({
    required this.name,
    required this.image,
    this.isOnline = false,
  });
}

class CallHistory {
  final Contact contact;
  final String time;
  final CallType type;
  final String duration;
  final int? count;

  CallHistory({
    required this.contact,
    required this.time,
    required this.type,
    required this.duration,
    this.count,
  });
}

enum CallType { incoming, outgoing, missed }
