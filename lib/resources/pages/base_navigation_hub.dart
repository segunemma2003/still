import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '../widgets/calls_tab_widget.dart';
import '../widgets/channels_tab_widget.dart';
import '../widgets/chats_tab_widget.dart';
import '../widgets/settings_tab_widget.dart';

class BaseNavigationHub extends NyStatefulWidget with BottomNavPageControls {
  static RouteView path = ("/base", (_) => BaseNavigationHub());

  BaseNavigationHub()
      : super(
            child: () => _BaseNavigationHubState(),
            stateName: path.stateName());

  /// State actions
  static NavigationHubStateActions stateActions =
      NavigationHubStateActions(path.stateName());
}

class _BaseNavigationHubState extends NavigationHub<BaseNavigationHub> {
  /// Layouts:
  /// - [NavigationHubLayout.bottomNav] Bottom navigation
  /// - [NavigationHubLayout.topNav] Top navigation
  /// - [NavigationHubLayout.journey] Journey navigation
  NavigationHubLayout? layout = NavigationHubLayout.bottomNav(
    selectedFontSize: 8,
    unselectedFontSize: 8,
    backgroundColor: const Color(0xFF1C212C), // Dark background to match design
    selectedItemColor: Color(0xFFE8E7EA), // Blue for active items
    unselectedItemColor: const Color(0xFF6E6E6E), // Gray for inactive items
    type: BottomNavigationBarType.fixed, // Ensures all tabs are visible
  );

  /// Should the state be maintained
  @override
  bool get maintainState => true;

  /// Navigation pages
  _BaseNavigationHubState()
      : super(() async {
          /// * Creating Navigation Tabs
          /// [Navigation Tabs] 'dart run nylo_framework:main make:stateful_widget chats_tab,channels_tab,calls_tab,settings_tab'
          return {
            0: NavigationTab(
              title: "Chats",
              page: ChatsTab(), // Create this widget
              icon: Stack(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    child: Image.asset(
                      'chat_outline.png', // Using image instead of icon
                      width: 18,
                      height: 18,
                    ).localAsset(),
                  ),
                  // Active indicator dot
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8E7EA), // Blue dot
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              activeIcon: Stack(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    child: Image.asset(
                      'chat_filled.png', // Using image instead of icon
                      width: 18,
                      height: 18,
                    ).localAsset(),
                  ),
                  // Active indicator dot
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8E7EA), // Blue dot
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            1: NavigationTab(
              title: "Channels",
              page: ChannelsTab(), // Create this widget
              icon: Container(
                width: 18,
                height: 18,
                child: Image.asset(
                  'channels_outline.png', // Using image instead of icon
                  width: 18,
                  height: 18,
                ).localAsset(),
              ),
              activeIcon: Container(
                width: 18,
                height: 18,
                child: Image.asset(
                  'channels_filled.png', // Using image instead of icon
                  width: 18,
                  height: 18,
                ).localAsset(),
              ),
            ),
            2: NavigationTab(
              title: "Calls",
              page: CallsTab(), // Create this widget
              icon: Container(
                width: 18,
                height: 18,
                child: Image.asset(
                  'phone_outline.png', // Using image instead of icon
                  width: 18,
                  height: 18,
                ).localAsset(),
              ),
              activeIcon: Container(
                width: 18,
                height: 18,
                child: Image.asset(
                  'phone_filled.png', // Using image instead of icon
                  width: 24,
                  height: 24,
                ).localAsset(),
              ),
            ),
            3: NavigationTab(
              title: "Settings",
              page: SettingsTab(), // Create this widget
              icon: Container(
                width: 18,
                height: 18,
                child: Image.asset(
                  'settings_outline.png', // Using image instead of icon
                  width: 18,
                  height: 18,
                ).localAsset(),
              ),
              activeIcon: Container(
                width: 18,
                height: 18,
                child: Image.asset(
                  'settings_filled.png', // Using image instead of icon
                  width: 18,
                  height: 18,
                ).localAsset(),
              ),
            ),
          };
        });

  /// Handle the tap event
  @override
  onTap(int index) {
    super.onTap(index);
    // Add any custom logic when tabs are tapped
  }
}
