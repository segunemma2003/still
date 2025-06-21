import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/resources/pages/video_call_page.dart';
import 'package:flutter_app/resources/pages/voice_call_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

class ChatScreenPage extends NyStatefulWidget {
  static RouteView path = ("/chat-screen", (_) => ChatScreenPage());

  ChatScreenPage({super.key}) : super(child: () => _ChatScreenPageState());
}

class _ChatScreenPageState extends NyPage<ChatScreenPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showMediaPicker = false;
  bool _isPlaying = false;
  bool _hasText = false;

  List<Message> messages = [
    Message(
      text: "Hello",
      time: "20:56",
      isSent: true,
      isDelivered: true,
    ),
    Message(
      text: "Hi,\nWelcome to stillur Chat App",
      time: "20:57",
      isSent: false,
    ),
    Message(
      text: "Thank you",
      time: "21:16",
      isSent: true,
      isDelivered: true,
    ),
    Message(
      text:
          "Stillur is a privacy-first encrypted chat application. Your messages are always private and secure.",
      time: "21:20",
      isSent: false,
    ),
    Message(
      text: "",
      time: "21:36",
      isSent: true,
      isDelivered: true,
      isAudio: true,
      audioDuration: "0:15",
    ),
    Message(
      text: "Chat app where you can truly escape.",
      time: "21:22",
      isSent: false,
    ),
    Message(
      text:
          "End-to-end encryption keeps your chats safe and unseen, not even we can read them.",
      time: "21:56",
      isSent: false,
    ),
  ];

  @override
  get init => () {
        print("Init method called"); // Debug
        _messageController.addListener(_onTextChanged);
      };

  @override
  void initState() {
    super.initState();
    print("initState called"); // Debug
    _messageController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    bool hasText = _messageController.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleMediaPicker() {
    setState(() {
      _showMediaPicker = !_showMediaPicker;
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add(Message(
          text: _messageController.text.trim(),
          time:
              "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}",
          isSent: true,
          isDelivered: false,
        ));
      });
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessage(Message message) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      child: Row(
        mainAxisAlignment:
            message.isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isSent) const SizedBox(width: 10),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isSent
                    ? const Color(0xFF3498DB)
                    : const Color(0xFF404040),
                borderRadius: message.isSent
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(4),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(18),
                      ),
              ),
              child: message.isAudio
                  ? _buildAudioMessage(message)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message.text.isNotEmpty)
                          Text(
                            message.text,
                            style: const TextStyle(
                              color: Color(0xFFE8E7EA),
                              fontSize: 12,
                            ),
                          ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              message.time,
                              style: TextStyle(
                                color: Color(0xFFE8E7EA).withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                            if (message.isSent) ...[
                              const SizedBox(width: 4),
                              Container(
                                width: 16,
                                height: 16,
                                child: Image.asset(
                                  message.isDelivered
                                      ? 'double_check.png'
                                      : 'single_check.png',
                                  width: 16,
                                  height: 16,
                                  color: message.isDelivered
                                      ? const Color(0xFF00BCD4)
                                      : Color(0xFFE8E7EA).withOpacity(0.7),
                                ).localAsset(),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
            ),
          ),
          if (message.isSent) const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildAudioMessage(Message message) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isPlaying = !_isPlaying;
            });
            HapticFeedback.lightImpact();
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFE8E7EA),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: const Color(0xFF3498DB),
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            children: [
              // Audio waveform
              Container(
                height: 20,
                child: Row(
                  children: List.generate(20, (index) {
                    double height = [
                      0.3,
                      0.7,
                      0.5,
                      0.9,
                      0.4,
                      0.8,
                      0.6,
                      0.3,
                      0.7,
                      0.5,
                      0.9,
                      0.4,
                      0.8,
                      0.6,
                      0.3,
                      0.7,
                      0.5,
                      0.9,
                      0.4,
                      0.8
                    ][index];
                    return Container(
                      width: 2,
                      height: 20 * height,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        color: Color(0xFFE8E7EA).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    message.audioDuration ?? "0:00",
                    style: TextStyle(
                      color: Color(0xFFE8E7EA).withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        message.time,
                        style: TextStyle(
                          color: Color(0xFFE8E7EA).withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      if (message.isSent) ...[
                        const SizedBox(width: 4),
                        Container(
                          width: 16,
                          height: 16,
                          child: Image.asset(
                            message.isDelivered
                                ? 'double_check.png'
                                : 'single_check.png',
                            width: 16,
                            height: 16,
                            color: message.isDelivered
                                ? const Color(0xFF00BCD4)
                                : Color(0xFFE8E7EA).withOpacity(0.7),
                          ).localAsset(),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMediaPicker() {
    return Container(
      height: 300,
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
      child: Column(
        children: [
          // Clickable Handle bar area
          GestureDetector(
            onTap: () => _toggleMediaPicker(),
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

          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => _toggleMediaPicker(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Color(0xFF007AFF),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Text(
                  'Recent',
                  style: TextStyle(
                    color: Color(0xFFE8E7EA),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Manage',
                    style: TextStyle(
                      color: Color(0xFF007AFF),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Photo grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 1,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'image${(index % 11) + 1}.png',
                      fit: BoxFit.cover,
                    ).localAsset(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      body: Container(
        // Full screen background image
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('chatBackround.png').localAsset(),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // AppBar with semi-transparent background
            Container(
              color: Color(0xFF1C212C).withOpacity(0.9),
              child: SafeArea(
                bottom: false,
                child: Container(
                  height: kToolbarHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(
                            'back_arrow.png',
                            width: 24,
                            height: 24,
                            color: Color(0xFFE8E7EA),
                          ).localAsset(),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade700,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'image2.png',
                            fit: BoxFit.cover,
                          ).localAsset(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Ahmad',
                              style: const TextStyle(
                                color: Color(0xFFE8E7EA),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2ECC71),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Online',
                                  style: TextStyle(
                                    color: Color(0xFF2ECC71),
                                    fontSize: 8,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Container(
                          width: 22,
                          height: 22,
                          child: Image.asset(
                            'video_call.png',
                            width: 22,
                            height: 22,
                            color: Color(0xFFE8E7EA),
                          ).localAsset(),
                        ),
                        onPressed: () {
                          routeTo(VideoCallPage.path);
                        },
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                      ),
                      IconButton(
                        icon: Container(
                          width: 22,
                          height: 22,
                          child: Image.asset(
                            'voice_call.png',
                            width: 22,
                            height: 22,
                            color: Color(0xFFE8E7EA),
                          ).localAsset(),
                        ),
                        onPressed: () {
                          routeTo(VoiceCallPage.path);
                        },
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ),

            // Chat content with semi-transparent overlay
            Expanded(
              child: Stack(
                children: [
                  Column(
                    children: [
                      // Today header
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Today',
                            style: TextStyle(
                              color: Color(0xFFE8E7EA),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),

                      // Messages
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return _buildMessage(messages[index]);
                          },
                        ),
                      ),

                      // Input area
                      if (!_showMediaPicker)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xFF0F131B).withOpacity(0.9),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: _toggleMediaPicker,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF404040),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    'add.png',
                                    width: 20,
                                    height: 20,
                                    color: Color(0xFFE8E7EA),
                                  ).localAsset(),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF404040),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: TextField(
                                    controller: _messageController,
                                    style: const TextStyle(
                                        color: Color(0xFFE8E7EA)),
                                    decoration: const InputDecoration(
                                      hintText: 'Type a message...',
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                    ),
                                    onSubmitted: (_) => _sendMessage(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Conditionally show send button when typing, otherwise show mic and camera
                              if (_hasText)
                                GestureDetector(
                                  onTap: _sendMessage,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF3498DB),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.send,
                                      color: Color(0xFFE8E7EA),
                                      size: 20,
                                    ),
                                  ),
                                )
                              else ...[
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF404040),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.mic,
                                      color: Color(0xFFE8E7EA),
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  // onTap: _toggleMediaPicker,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF404040),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera,
                                      color: Color(0xFFE8E7EA),
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                    ],
                  ),

                  // Media picker overlay
                  if (_showMediaPicker)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: _buildMediaPicker(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final String time;
  final bool isSent;
  final bool isDelivered;
  final bool isAudio;
  final String? audioDuration;

  Message({
    required this.text,
    required this.time,
    required this.isSent,
    this.isDelivered = false,
    this.isAudio = false,
    this.audioDuration,
  });
}
