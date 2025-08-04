import 'package:nylo_framework/nylo_framework.dart';
import '/app/networking/auth_api_service.dart';

class LogoutEvent implements NyEvent {
  @override
  final listeners = {
    DefaultListener: DefaultListener(),
  };
}

class DefaultListener extends NyListener {
  @override
  handle(dynamic event) async {
    // Call API logout endpoint first
    try {
      AuthApiService apiService = AuthApiService();
      await apiService.logoutUser();
    } catch (e) {
      print('API logout failed: $e');
      // Continue with local logout even if API call fails
    }

    // Clear local authentication
    await Auth.logout();

    // Navigate to initial route
    routeToInitial();
  }
}
