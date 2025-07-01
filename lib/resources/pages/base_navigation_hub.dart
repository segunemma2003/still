import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    selectedFontSize: 13,
    unselectedFontSize: 13,
    backgroundColor: Colors.transparent, // Keep transparent
    selectedItemColor: Color(0xFFE8E7EA), // Blue for active items
    unselectedItemColor: const Color(0xFF6E6E6E), // Gray for inactive items
    type: BottomNavigationBarType.fixed, // Ensures all tabs are visible
    elevation: 0, // Remove default elevation
  );

  /// Should the state be maintained
  @override
  bool get maintainState => true;

  /// Override bottomNavBuilder to add blur effect and proper spacing
  @override
  Widget bottomNavBuilder(
      BuildContext context, Widget body, Widget? bottomNavigationBar) {
    return Scaffold(
      body: body,
      extendBody: true, // Allow body to extend behind bottom nav
      bottomNavigationBar: Container(
        height: 90,
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black
                    .withOpacity(0.4), // Semi-transparent background
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                    width: 0.5,
                  ),
                ),
              ),
              // Add padding to create proper spacing from top
              padding: EdgeInsets.only(top: 2, bottom: 0),
              child: bottomNavigationBar,
            ),
          ),
        ),
      ),
    );
  }

  /// Navigation pages
  _BaseNavigationHubState()
      : super(() async {
          /// * Creating Navigation Tabs
          /// [Navigation Tabs] 'dart run nylo_framework:main make:stateful_widget chats_tab,channels_tab,calls_tab,settings_tab'
          return {
            0: NavigationTab(
              title: "Chats",
              page: ChatsTab(), // Create this widget
              icon: Container(
                padding: EdgeInsets.only(top: 2),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SvgPicture.asset(
                      'public/images/chat_icon.svg',
                      colorFilter: ColorFilter.mode(
                        Color(0xff6E6E6E),
                        BlendMode.srcIn,
                      ),
                      width: 19,
                      height: 19,
                    ),
                    // Custom Badge
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        constraints: BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF57A1FF), Color(0xFF3B69C6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Center(
                          child: Text(
                            '15',
                            style: TextStyle(
                              color: Color(0xFFFBFBFC),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              activeIcon: Container(
                padding: EdgeInsets.only(top: 2),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SvgPicture.asset(
                      'public/images/chat_tab.svg',
                      width: 19,
                      height: 19,
                      colorFilter: ColorFilter.mode(
                        Color(0xFFFBFBFC),
                        BlendMode.srcIn,
                      ),
                    ),
                    // Custom Badge for active state
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        constraints: BoxConstraints(
                          minWidth: 18, // Reduced from 18
                          minHeight: 18, // Reduced from 18
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF57A1FF), Color(0xFF3B69C6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Center(
                          child: Text(
                            '15',
                            style: TextStyle(
                              color: Color(0xFFFBFBFC),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            1: NavigationTab(
              title: "Channels",
              page: ChannelsTab(), // Create this widget
              icon: Container(
                child: SvgPicture.asset(
                  'public/images/channel_tab.svg',
                  width: 19,
                  height: 19,
                  colorFilter: ColorFilter.mode(
                    Color(0xff6E6E6E),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              activeIcon: Container(
                child: SvgPicture.asset(
                  'public/images/channel_tab.svg',
                  width: 19,
                  height: 19,
                  colorFilter: ColorFilter.mode(
                    Color(0xffFBFBFC),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            2: NavigationTab(
              title: "Calls",
              page: CallsTab(), // Create this widget
              icon: Container(
                child: SvgPicture.asset(
                  'public/images/call.svg',
                  width: 19,
                  height: 19,
                  colorFilter: ColorFilter.mode(
                    Color(0xff6E6E6E),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              activeIcon: Container(
                child: SvgPicture.asset(
                  'public/images/call.svg',
                  width: 19,
                  height: 19,
                  colorFilter: ColorFilter.mode(
                    Color(0xffFBFBFC),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            3: NavigationTab(
              title: "Settings",
              page: SettingsTab(), // Create this widget
              icon: Container(
                child: SvgPicture.asset(
                  'public/images/setting.svg',
                  width: 19,
                  height: 19,
                  colorFilter: ColorFilter.mode(
                    Color(0xff6E6E6E),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              activeIcon: Container(
                child: SvgPicture.asset(
                  'public/images/setting.svg',
                  width: 19,
                  height: 19,
                  colorFilter: ColorFilter.mode(
                    Color(0xffFBFBFC),
                    BlendMode.srcIn,
                  ),
                ),
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
