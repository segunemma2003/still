import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '/config/decoders.dart';
import '/app/models/user.dart';
import 'package:nylo_framework/nylo_framework.dart';

/* ApiService
| -------------------------------------------------------------------------
| Define your API endpoints
| Learn more https://nylo.dev/docs/6.x/networking
|-------------------------------------------------------------------------- */

class ApiService extends NyApiService {
  ApiService({BuildContext? buildContext})
      : super(
          buildContext,
          decoders: modelDecoders,
          // baseOptions: (BaseOptions baseOptions) {
          //   return baseOptions
          //             ..connectTimeout = Duration(seconds: 5)
          //             ..sendTimeout = Duration(seconds: 5)
          //             ..receiveTimeout = Duration(seconds: 5);
          // },
        );

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  @override
  get interceptors => {
        if (getEnv('APP_DEBUG') == true) PrettyDioLogger: PrettyDioLogger(),
        // MyCustomInterceptor: MyCustomInterceptor(),
      };

  Future fetchTestData() async {
    return await network(
      request: (request) => request.get("/endpoint-path"),
    );
  }

  /// Example to fetch the Nylo repository info from Github
  Future githubInfo() async {
    return await network(
      request: (request) =>
          request.get("https://api.github.com/repos/nylo-core/nylo"),
      cacheKey: "github_nylo_info", // Optional: Cache the response
      cacheDuration: const Duration(hours: 1),
    );
  }

  /* Helpers
  |-------------------------------------------------------------------------- */

  /* Authentication Headers
  |--------------------------------------------------------------------------
  | Set your auth headers
  | Authenticate your API requests using a bearer token or any other method
  |-------------------------------------------------------------------------- */

  @override
  Future<RequestHeaders> setAuthHeaders(RequestHeaders headers) async {
    // Always add Bearer token for all requests except auth routes
    // The auth routes will be handled by AuthApiService which overrides this method
    Map<String, dynamic>? userData = await Auth.data();
    if (userData != null && userData['accessToken'] != null) {
      headers.addBearerToken(userData['accessToken']);
    }
    return headers;
  }

  /* Should Refresh Token
  |--------------------------------------------------------------------------
  | Check if your Token should be refreshed
  | Set `false` if your API does not require a token refresh
  |-------------------------------------------------------------------------- */

  @override
  Future<bool> shouldRefreshToken() async {
    // For now, we'll return false since we don't have token expiration logic
    // You can implement token expiration checking here
    return false;
  }

  /* Refresh Token
  |--------------------------------------------------------------------------
  | If `shouldRefreshToken` returns true then this method
  | will be called to refresh your token. Save your new token to
  | local storage and then use the value in `setAuthHeaders`.
  |-------------------------------------------------------------------------- */

  @override
  refreshToken(Dio dio) async {
    // Implement token refresh logic here if needed
    // For now, we'll just logout the user
    await Auth.logout();
  }
}
