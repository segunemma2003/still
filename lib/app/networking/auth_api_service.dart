import 'package:flutter/material.dart';
import '/config/decoders.dart';
import '/app/models/user.dart';
import 'package:nylo_framework/nylo_framework.dart';

class AuthApiService extends NyApiService {
  AuthApiService({BuildContext? buildContext})
      : super(buildContext, decoders: modelDecoders);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  @override
  Future<RequestHeaders> setAuthHeaders(RequestHeaders headers) async {
    // AuthApiService handles authentication routes, so we don't add Bearer tokens
    // This prevents authentication requests from including expired or invalid tokens
    return headers;
  }

  /// Register a new user
  Future<Map<String, dynamic>> registerUser({
    required String email,
    required String username,
    required String password,
  }) async {
    Map<String, dynamic>? result = await network<Map<String, dynamic>>(
      request: (request) => request.post("/auth/register", data: {
        "email": email,
        "username": username,
        "password": password,
        "otp": "123456"
      }),
      handleSuccess: (Response response) {
        dynamic data = response.data;
        return {
          "success": true,
          "user": User.fromJson(data),
        };
      },
      handleFailure: (DioError dioError) {
        print('Registration failed: ${dioError.message}');

        // Handle specific error responses
        if (dioError.response?.data != null) {
          dynamic errorData = dioError.response!.data;
          String message = errorData['message'] ?? 'Registration failed';

          if (message == "Email already in use.") {
            return {
              "success": false,
              "error": "email_exists",
              "message":
                  "Email already in use. Please use a different email address.",
            };
          } else if (message == "Validation error") {
            return {
              "success": false,
              "error": "username_exists",
              "message":
                  "Username already taken. Please choose a different username.",
            };
          } else {
            return {
              "success": false,
              "error": "general",
              "message": message,
            };
          }
        }

        return {
          "success": false,
          "error": "network",
          "message":
              "Network error. Please check your connection and try again.",
        };
      },
    );

    return result ??
        {
          "success": false,
          "error": "unknown",
          "message": "An unknown error occurred.",
        };
  }

  /// Verify OTP code
  Future<bool?> verifyOtp({
    required String email,
    required String otp,
  }) async {
    return await network<bool>(
      request: (request) => request.post("/auth/verify-otp", data: {
        "email": email,
        "otp": otp,
      }),
      handleSuccess: (Response response) {
        dynamic data = response.data;
        return data['success'] == true || data['verified'] == true;
      },
      handleFailure: (DioError dioError) {
        print('OTP verification failed: ${dioError.message}');
        return false;
      },
    );
  }

  /// Login user
  Future<User?> loginUser({
    String? username,
    String? password,
    String? email,
    String? otp,
    String? phone,
  }) async {
    return await network<User>(
      request: (request) => request.post("/auth/login", data: {
        "username": username,
        "password": password,
        "email": email,
        "otp": otp,
        "phone": phone,
      }),
      handleSuccess: (Response response) {
        dynamic data = response.data;
        return User.fromJson(data);
      },
      handleFailure: (DioError dioError) {
        print('Login failed: ${dioError.message}');
        return null;
      },
    );
  }

  /// Logout user (requires authentication)
  Future<bool?> logoutUser() async {
    return await network<bool>(
      request: (request) => request.post("/auth/logout"),
      handleSuccess: (Response response) {
        return true;
      },
      handleFailure: (DioError dioError) {
        print('Logout failed: ${dioError.message}');
        return false;
      },
    );
  }
}
