import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'dart:async';

class VideoCallPage extends NyStatefulWidget {
  static RouteView path = ("/video-call", (_) => VideoCallPage());

  VideoCallPage({super.key}) : super(child: () => _VideoCallPageState());
}

class _VideoCallPageState extends NyPage<VideoCallPage>
    with TickerProviderStateMixin {
  bool _isMuted = false;
  bool _isCameraOn = true;
  bool _isVideoOn = true;

  // Call timer
  Timer? _timer;
  int _seconds = 45; // Start with some time for demo

  // Call participants - modify this list to test different layouts
  List<VideoParticipant> _participants = [
    VideoParticipant(
      name: "Fenta",
      image: "female.jpg",
      isSelf: false,
      isMuted: false,
    ),
    VideoParticipant(
      name: "You",
      image: "male.jpg",
      isSelf: true,
      isMuted: false,
    ),
    // Add more participants to test group call
    // VideoParticipant(name: "Layla", image: "image2.png"),
    // VideoParticipant(name: "Doctor", image: "image10.png"),
    // VideoParticipant(name: "Ahmad", image: "image11.png"),
  ];

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  get init => () {
        _fadeController = AnimationController(
          duration: const Duration(milliseconds: 300),
          vsync: this,
        );

        _fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _fadeController,
          curve: Curves.easeInOut,
        ));

        _fadeController.forward();
        _startTimer();
      };

  @override
  void dispose() {
    _timer?.cancel();
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
    int minutes = _seconds ~/ 60;
    int secs = _seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  String _getParticipantNames() {
    List<String> names =
        _participants.where((p) => !p.isSelf).map((p) => p.name).toList();

    if (names.length <= 2) {
      return names.join(" & ");
    } else {
      return "${names.take(2).join(", ")} & ${names.length - 2} others";
    }
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Stack(
            children: [
              // Video content
              _buildVideoContent(),

              // Top header
              _buildTopHeader(),

              // Bottom controls
              _buildBottomControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          children: [
            // Minimize button
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Color(0xFF1C212C).withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.remove,
                color: Color(0xFFE8E7EA),
                size: 20,
              ),
            ),

            Expanded(
              child: Column(
                children: [
                  Text(
                    _getParticipantNames(),
                    style: const TextStyle(
                      color: Color(0xFFE8E7EA),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatDuration(),
                    style: const TextStyle(
                      color: Color(0xFFE8E7EA),
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Participants count (for group calls)
            if (_participants.length > 2)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF1C212C).withOpacity(0.8),
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
                      "${_participants.length}",
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
      ),
    );
  }

  Widget _buildVideoContent() {
    if (_participants.length == 1) {
      // Single participant (self only)
      return _buildSingleVideoView();
    } else if (_participants.length == 2) {
      // Two participants - main video with picture-in-picture
      return _buildDualVideoView();
    } else {
      // Group call (3+ participants)
      return _buildGroupVideoView();
    }
  }

  Widget _buildSingleVideoView() {
    final mainParticipant = _participants.first;

    return Stack(
      children: [
        // Main video feed
        Container(
          width: double.infinity,
          height: double.infinity,
          child: ClipRRect(
            child: Image.asset(
              mainParticipant.image,
              fit: BoxFit.cover,
            ).localAsset(),
          ),
        ),

        // Self preview (small window in corner)
        if (!mainParticipant.isSelf)
          Positioned(
            top: 80,
            right: 16,
            child: Container(
              width: 120,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFFE8E7EA), width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "image6.png", // Self image
                  fit: BoxFit.cover,
                ).localAsset(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDualVideoView() {
    final otherParticipant = _participants.firstWhere((p) => !p.isSelf);
    final selfParticipant = _participants.firstWhere((p) => p.isSelf);

    return Stack(
      children: [
        // Main video feed (other participant)
        Container(
          width: double.infinity,
          height: double.infinity,
          child: ClipRRect(
            child: Image.asset(
              otherParticipant.image,
              fit: BoxFit.cover,
            ).localAsset(),
          ),
        ),

        // Picture-in-picture for self (bottom right corner)
        Positioned(
          bottom: 120, // Above the control buttons
          right: 16,
          child: Container(
            width: 120,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFF3498DB), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                selfParticipant.image,
                fit: BoxFit.cover,
              ).localAsset(),
            ),
          ),
        ),

        // Participant name overlay for main video
        Positioned(
          top: 80,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFF1C212C).withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              otherParticipant.name,
              style: const TextStyle(
                color: Color(0xFFE8E7EA),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        // Self label on picture-in-picture
        Positioned(
          bottom: 125,
          right: 21,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Color(0xFF3498DB),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              "You",
              style: TextStyle(
                color: Color(0xFFE8E7EA),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGroupVideoView() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(8, 80, 8, 120),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 0.75,
      ),
      itemCount: _participants.length,
      itemBuilder: (context, index) {
        final participant = _participants[index];
        return _buildParticipantVideo(participant);
      },
    );
  }

  Widget _buildParticipantVideo(VideoParticipant participant) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: participant.isSelf
            ? Border.all(color: const Color(0xFF3498DB), width: 2)
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            // Video feed
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                participant.image,
                fit: BoxFit.cover,
              ).localAsset(),
            ),

            // Participant info overlay
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF1C212C).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        participant.name,
                        style: const TextStyle(
                          color: Color(0xFFE8E7EA),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (participant.isMuted)
                      const Icon(
                        Icons.mic_off,
                        color: Colors.red,
                        size: 14,
                      ),
                  ],
                ),
              ),
            ),

            // Speaking indicator for main speaker (optional)
            if (participant.name == "Fenta") // Example: highlight main speaker
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFF1C212C).withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      participant.image,
                      fit: BoxFit.cover,
                    ).localAsset(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Camera switch button
            _buildControlButton(
              icon: Icons.flip_camera_ios,
              label: "Camera",
              isActive: false,
              onTap: () {
                HapticFeedback.lightImpact();
              },
            ),

            // Video toggle button
            _buildControlButton(
              icon: _isVideoOn ? Icons.videocam : Icons.videocam_off,
              label: "Video",
              isActive: !_isVideoOn,
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
                      : Color(0xFF1C212C).withOpacity(0.6),
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

class VideoParticipant {
  final String name;
  final String image;
  final bool isSelf;
  final bool isMuted;

  VideoParticipant({
    required this.name,
    required this.image,
    this.isSelf = false,
    this.isMuted = false,
  });
}
