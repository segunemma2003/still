import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'api_service.dart';

class ContactApiService extends ApiService {
  ContactApiService({BuildContext? buildContext})
      : super(buildContext: buildContext);

  /// Check which contacts are registered on the platform
  Future<List<Map<String, dynamic>>> checkContacts(
      List<String> phoneNumbers) async {
    try {
      // Check if user is authenticated
      Map<String, dynamic>? userData = await Auth.data();
      if (userData == null || userData['accessToken'] == null) {
        print('User not authenticated for contact check');
        throw Exception('User not authenticated');
      }

      final response = await network(
        request: (request) => request.post(
          "/chat/check",
          data: {
            "contacts": phoneNumbers,
          },
        ),
      );

      if (response != null && response is List) {
        return List<Map<String, dynamic>>.from(response);
      }

      return [];
    } catch (e) {
      print('Error checking contacts: $e');
      // Return empty list on error so contacts still show up
      return [];
    }
  }
}
