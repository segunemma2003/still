import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'dart:async';

class VoiceCallPage extends NyStatefulWidget {
  static RouteView path = ("/voice-call", (_) => VoiceCallPage());

  VoiceCallPage({super.key}) : super(child: () => _VoiceCallPageState());
}

class _VoiceCallPageState extends NyPage<VoiceCallPage>
    with TickerProviderStateMixin {
  CallState _callState = CallState.ringing;
  bool _isMuted = false;
  bool _isSpeaker = false;
  bool _isVideoOn = false;

  // Call data - you can pass this as parameters
  CallType _callType =
      CallType.single; // Change to CallType.group for group calls

  // Single call data
  String _contactName = "Layla B";
  String _contactImage = "image2.png";

  // Group call data
  String _groupName = "Our Loving Pets";
  String _groupImage = "image9.png";
  List<CallParticipant> _participants = [
    CallParticipant(name: "You", image: "image6.png", isSelf: true),
    CallParticipant(name: "Layla B", image: "image2.png"),
    CallParticipant(name: "Layla B", image: "image2.png"),
    CallParticipant(name: "Layla B", image: "image2.png"),
    CallParticipant(name: "Layla B", image: "image2.png"),
    CallParticipant(name: "Layla B", image: "image2.png"),
  ];

  // Call timer
  Timer? _timer;
  int _seconds = 0;

  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  get init => () {
        // Initialize animations
        _pulseController = AnimationController(
          duration: const Duration(milliseconds: 1000),
          vsync: this,
        );

        _fadeController = AnimationController(
          duration: const Duration(milliseconds: 800),
          vsync: this,
        );

        _pulseAnimation = Tween<double>(
          begin: 1.0,
          end: 1.2,
        ).animate(CurvedAnimation(
          parent: _pulseController,
          curve: Curves.easeInOut,
        ));

        _fadeAnimation = Tween<double>(
          begin: 0.5,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _fadeController,
          curve: Curves.easeInOut,
        ));

        // Start animations for ringing state
        if (_callState == CallState.ringing) {
          _pulseController.repeat(reverse: true);
          _fadeController.repeat(reverse: true);
        }

        // Start call timer when connected
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            _callState = CallState.connected;
          });
          // Stop ringing animations
          _pulseController.stop();
          _fadeController.stop();
          _pulseController.reset();
          _fadeController.reset();
          _startTimer();
        });
      };

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  String _formatDuration() {
    int hours = _seconds ~/ 3600;
    int minutes = (_seconds % 3600) ~/ 60;
    int secs = _seconds % 60;

    if (hours > 0) {
      return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
    } else {
      return "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
    }
  }

  String _getCallStatusText() {
    switch (_callState) {
      case CallState.ringing:
        return _callType == CallType.group ? "Calling Group..." : "Ringing...";
      case CallState.connected:
        return _formatDuration();
    }
  }

  Widget _buildAnimatedTimer() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Text(
        _getCallStatusText(),
        key: ValueKey(_callState),
        style: TextStyle(
          color: _callState == CallState.connected
              ? Color(0xFFE8E7EA)
              : Colors.grey.shade400,
          fontSize: 16,
          fontWeight: _callState == CallState.connected
              ? FontWeight.w600
              : FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F131B),
      body: SafeArea(
        child: Column(
          children: [
            // Status bar and header
            _buildHeader(),

            // Main call content
            Expanded(
              child: _callType == CallType.single
                  ? _buildSingleCallContent()
                  : _buildGroupCallContent(),
            ),

            // Control buttons
            _buildControlButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    if (_callType == CallType.group && _callState == CallState.connected) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  _groupImage,
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
                    _groupName,
                    style: const TextStyle(
                      color: Color(0xFFE8E7EA),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      _getCallStatusText(),
                      key: ValueKey(_callState),
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                        fontWeight: _callState == CallState.connected
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFFE8E7EA).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.people,
                    color: Color(0xFFE8E7EA),
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${_participants.length} Joined",
                    style: const TextStyle(
                      color: Color(0xFFE8E7EA),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  Widget _buildSingleCallContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Profile image with pulsating animation
        AnimatedBuilder(
          animation: _callState == CallState.ringing
              ? _pulseAnimation
              : AlwaysStoppedAnimation(1.0),
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: _callState == CallState.ringing
                      ? [
                          BoxShadow(
                            color: Color(0xFFE8E7EA).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ]
                      : [],
                ),
                child: ClipOval(
                  child: Image.asset(
                    _contactImage,
                    fit: BoxFit.cover,
                  ).localAsset(),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 32),

        // Contact name
        Text(
          _contactName,
          style: const TextStyle(
            color: Color(0xFFE8E7EA),
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        // Call status with animated timer
        _callState == CallState.ringing
            ? AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Text(
                      _getCallStatusText(),
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              )
            : _buildAnimatedTimer(),
      ],
    );
  }

  Widget _buildGroupCallContent() {
    if (_callState == CallState.ringing) {
      // Show main caller during ringing state
      String mainCaller = "Fenta"; // This could be dynamic
      String mainCallerImage = "image8.png";

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Group info at top
          Text(
            "Fenta, Layla B & Ahmad", // Dynamic group member names
            style: const TextStyle(
              color: Color(0xFFE8E7EA),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "02:12:33", // Call duration or time
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 60),

          // Main caller with pulsating animation
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFE8E7EA).withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      mainCallerImage,
                      fit: BoxFit.cover,
                    ).localAsset(),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          Text(
            mainCaller,
            style: const TextStyle(
              color: Color(0xFFE8E7EA),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Text(
                  "Ringing...",
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 16,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 60),

          // Small participant avatars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSmallAvatar("image2.png", "Layla B"),
              const SizedBox(width: 24),
              _buildSmallAvatar("image6.png", "You", isSelf: true),
            ],
          ),
        ],
      );
    } else {
      // Show participant grid during connected state
      return Column(
        children: [
          const SizedBox(height: 40),

          // Participants grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: _participants.length,
              itemBuilder: (context, index) {
                final participant = _participants[index];
                return _buildParticipantCard(participant);
              },
            ),
          ),

          // Page indicators if needed
          if (_participants.length > 6)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: index == 0 ? Color(0xFFE8E7EA) : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),

          const SizedBox(height: 20),
        ],
      );
    }
  }

  Widget _buildSmallAvatar(String image, String name, {bool isSelf = false}) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: isSelf
                ? Border.all(color: const Color(0xFF3498DB), width: 2)
                : null,
          ),
          child: ClipOval(
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ).localAsset(),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            color: Color(0xFFE8E7EA),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantCard(CallParticipant participant) {
    return Container(
      decoration: BoxDecoration(
        color: participant.isSelf
            ? const Color(0xFF3498DB).withOpacity(0.3)
            : const Color(0xFF1C212C),
        borderRadius: BorderRadius.circular(12),
        border: participant.isSelf
            ? Border.all(color: const Color(0xFF3498DB), width: 2)
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                participant.image,
                fit: BoxFit.cover,
              ).localAsset(),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            participant.name,
            style: const TextStyle(
              color: Color(0xFFE8E7EA),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Speaker button
          _buildControlButton(
            icon: _isSpeaker ? Icons.volume_up : Icons.volume_down,
            label: "Speaker",
            isActive: _isSpeaker,
            onTap: () {
              setState(() {
                _isSpeaker = !_isSpeaker;
              });
              HapticFeedback.lightImpact();
            },
          ),

          // Video button
          _buildControlButton(
            icon: _isVideoOn ? Icons.videocam : Icons.videocam_off,
            label: "Video",
            isActive: _isVideoOn,
            onTap: () {
              setState(() {
                _isVideoOn = !_isVideoOn;
              });
              HapticFeedback.lightImpact();
            },
          ),

          // Mute button
          _buildControlButton(
            icon: _isMuted ? Icons.mic_off : Icons.mic,
            label: "Mute",
            isActive: _isMuted,
            onTap: () {
              setState(() {
                _isMuted = !_isMuted;
              });
              HapticFeedback.lightImpact();
            },
          ),

          // End call button
          _buildControlButton(
            icon: Icons.call_end,
            label: "End Call",
            isActive: false,
            isEndCall: true,
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    bool isEndCall = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isEndCall
                  ? const Color(0xFFE74C3C)
                  : isActive
                      ? const Color(0xFF3498DB)
                      : Color(0xFFE8E7EA).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Color(0xFFE8E7EA),
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFE8E7EA),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

enum CallState { ringing, connected }

enum CallType { single, group }

class CallParticipant {
  final String name;
  final String image;
  final bool isSelf;

  CallParticipant({
    required this.name,
    required this.image,
    this.isSelf = false,
  });
}
