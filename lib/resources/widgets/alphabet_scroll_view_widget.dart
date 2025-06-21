// AlphabetScrollView Widget
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '../../app/models/contact_info.dart';

class AlphabetScrollView extends StatefulWidget {
  final List<ContactInfo> contactList;
  final Function(ContactInfo)? onContactTap;

  const AlphabetScrollView({
    super.key,
    required this.contactList,
    this.onContactTap,
  });

  @override
  createState() => _AlphabetScrollViewState();
}

class _AlphabetScrollViewState extends NyState<AlphabetScrollView> {
  final ScrollController _scrollController = ScrollController();
  String _currentIndex = 'A';
  late List<String> _alphabetList;
  Map<String, double> _letterPositions = {};

  @override
  get init => () {
        _initializeData();
      };

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeData() {
    _alphabetList = _getAlphabetList();
    _calculateLetterPositions();
    _scrollController.addListener(_onScroll);
  }

  List<String> _getAlphabetList() {
    Set<String> letters = {};
    for (var contact in widget.contactList) {
      if (contact.tagIndex != null) {
        letters.add(contact.tagIndex!);
      }
    }
    List<String> sortedLetters = letters.toList()..sort();
    return sortedLetters;
  }

  void _calculateLetterPositions() {
    double position = 0;
    String currentLetter = '';

    for (int i = 0; i < widget.contactList.length; i++) {
      String? letter = widget.contactList[i].tagIndex;
      if (letter != null && letter != currentLetter) {
        _letterPositions[letter] = position;
        currentLetter = letter;
        position += 40; // Header height
      }
      position += 56; // Item height
    }
  }

  void _onScroll() {
    double offset = _scrollController.offset;
    String newIndex = _alphabetList.isNotEmpty ? _alphabetList.first : 'A';

    for (String letter in _alphabetList.reversed) {
      if (_letterPositions[letter] != null &&
          offset >= _letterPositions[letter]!) {
        newIndex = letter;
        break;
      }
    }

    if (newIndex != _currentIndex) {
      setState(() {
        _currentIndex = newIndex;
      });
    }
  }

  void _scrollToLetter(String letter) {
    HapticFeedback.lightImpact();

    if (_letterPositions[letter] != null) {
      _scrollController.animateTo(
        _letterPositions[letter]!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildContactItem(ContactInfo contact) {
    return GestureDetector(
      onTap: () {
        if (widget.onContactTap != null) {
          widget.onContactTap!(contact);
        }
      },
      child: Column(
        children: [
          // Section header
          if (contact.isShowSuspension == true)
            Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              color: const Color(0xFF34495E),
              child: Text(
                contact.tagIndex ?? '',
                style: const TextStyle(
                  color: Color(0xFFE8E7EA),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          // Contact item
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade700,
                  ),
                  child: contact.imagePath != null
                      ? ClipOval(
                          child: Image.asset(
                            contact.imagePath!,
                            width: 36,
                            height: 36,
                            fit: BoxFit.cover,
                          ).localAsset(),
                        )
                      : Icon(
                          Icons.person,
                          color: Colors.grey.shade500,
                          size: 20,
                        ),
                ),
                const SizedBox(width: 16),
                // Name
                Expanded(
                  child: Text(
                    contact.name ?? 'Unknown',
                    style: const TextStyle(
                      color: Color(0xFFE8E7EA),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget view(BuildContext context) {
    if (widget.contactList.isEmpty) {
      return const Center(
        child: Text(
          'No contacts found',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      );
    }

    return Stack(
      children: [
        // Contact list
        ListView.builder(
          controller: _scrollController,
          itemCount: widget.contactList.length,
          itemBuilder: (context, index) {
            return _buildContactItem(widget.contactList[index]);
          },
        ),

        // Alphabet index
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: 24,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _alphabetList.map((letter) {
                bool isActive = letter == _currentIndex;
                return GestureDetector(
                  onTap: () => _scrollToLetter(letter),
                  child: Container(
                    height: 16,
                    alignment: Alignment.center,
                    child: Text(
                      letter,
                      style: TextStyle(
                        color: isActive
                            ? const Color(0xFF3498DB)
                            : Colors.grey.shade500,
                        fontSize: 11,
                        fontWeight:
                            isActive ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
