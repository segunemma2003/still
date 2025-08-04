# Authentication Flow Implementation

This document describes the authentication flow implemented in the Stillur Flutter app using Nylo 6.x framework.

## Overview

The authentication flow consists of three main steps:
1. **Registration** - User signs up with email, username, and password
2. **OTP Verification** - User verifies their email with a 4-digit code
3. **Login** - User logs in with email and password

## API Endpoints

### Registration
- **URL**: `POST /auth/register`
- **Parameters**:
  ```json
  {
    "email": "ttech7633@gmail.com",
    "username": "mover",
    "password": "Asdfgh12@"
  }
  ```
- **Response**:
  ```json
  {
    "id": 2,
    "username": "movers",
    "email": "ttech633@gmail.com"
  }
  ```
- **Error Responses**:
  - Email exists: `{"message": "Email already in use."}`
  - Username exists: `{"message": "Validation error"}`

### OTP Verification
- **URL**: `POST /auth/verify-otp`
- **Parameters**:
  ```json
  {
    "email": "ttech633@gmail.com",
    "otp": "1234"
  }
  ```
- **Response**: Returns success status for valid OTP

### Login
- **URL**: `POST /auth/login`
- **Parameters**:
  ```json
  {
    "email": "ttech633@gmail.com",
    "password": "Asdfgh12@"
  }
  ```
- **Response**:
  ```json
  {
    "id": 2,
    "username": "movers",
    "email": "ttech633@gmail.com",
    "phone": null,
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwidXNlcm5hbWUiOiJtb3ZlcnMiLCJlbWFpbCI6InR0ZWNoNjMzQGdtYWlsLmNvbSIsInBob25lIjpudWxsLCJpYXQiOjE3NTM1MDI1MDJ9.lThXDwCy5e19A_s9D1EkEXQqIX8IJ0S2PN4IQFS2-bo"
  }
  ```

### Logout
- **URL**: `POST /auth/logout`
- **Headers**: `Authorization: Bearer <accessToken>`
- **Response**: Success status

## Implementation Details

### Files Modified/Created

1. **User Model** (`lib/app/models/user.dart`)
   - Updated to include `id`, `username`, `email`, `phone`, and `accessToken`
   - Added `isAuthenticated` helper method

2. **AuthApiService** (`lib/app/networking/auth_api_service.dart`)
   - Created new API service for authentication endpoints
   - Includes registration, OTP verification, login, and logout methods
   - Overrides `setAuthHeaders` to exclude Bearer tokens for auth routes
   - Handles specific error responses for registration conflicts

3. **API Service** (`lib/app/networking/api_service.dart`)
   - Added authentication headers support for all non-auth routes
   - Automatically includes Bearer token from stored user data
   - Excludes authentication routes from Bearer token requirement

4. **Sign Up Page** (`lib/resources/pages/sign_up_email_page.dart`)
   - Updated to use AuthApiService for registration
   - Added loading states and error handling
   - Uses `routeTo()` helper to navigate to OTP verification
   - Passes email data to next page
   - Handles specific error messages for email/username conflicts

5. **OTP Verification Page** (`lib/resources/pages/otp_email_verification_page.dart`)
   - Updated to receive email from route data using `data()` helper
   - Added API integration for OTP verification
   - Uses `routeTo()` with `NavigationType.pushAndForgetAll` to navigate to login

6. **Sign In Page** (`lib/resources/pages/sign_in_page.dart`)
   - Changed username field to email field
   - Updated to use AuthApiService for login
   - Implements Nylo authentication with `Auth.authenticate()`
   - Uses `routeToAuthenticatedRoute()` to navigate to main app

7. **Logout Event** (`lib/app/events/logout_event.dart`)
   - Updated to call API logout endpoint before clearing local auth
   - Ensures server-side logout even if local logout fails

8. **Router** (`lib/routes/router.dart`)
   - Set up SignInPage as initial route
   - Set up BaseNavigationHubWrapperPage as authenticated route

### Authentication Flow

1. **User Registration**:
   - User fills out registration form (email, username, password)
   - App calls `/auth/register` endpoint (no Bearer token)
   - On success, navigates to OTP verification page using `routeTo()`
   - On error, shows specific message for email/username conflicts

2. **Email Verification**:
   - User enters 4-digit OTP code
   - App calls `/auth/verify-otp` endpoint (no Bearer token)
   - On success, navigates to login page using `routeTo()` with `pushAndForgetAll`

3. **User Login**:
   - User enters email and password
   - App calls `/auth/login` endpoint (no Bearer token)
   - On success, user is authenticated using `Auth.authenticate()`
   - Navigates to authenticated route using `routeToAuthenticatedRoute()`

4. **API Requests After Login**:
   - All subsequent API requests automatically include Bearer token
   - Token is retrieved from stored user data
   - Authentication routes are excluded from Bearer token requirement

5. **User Logout**:
   - App calls `/auth/logout` endpoint with Bearer token
   - Clears local authentication data
   - Navigates back to initial route

### Bearer Token Implementation

The app implements automatic Bearer token authentication:

- **Automatic Inclusion**: All API requests (except auth routes) include `Authorization: Bearer <token>` header
- **Token Storage**: Access token is stored locally using Nylo's `Auth.authenticate()`
- **Route Exclusion**: Authentication routes (`/auth/register`, `/auth/login`, `/auth/verify-otp`) don't include Bearer tokens
- **Logout Handling**: Logout API call includes Bearer token for server-side session cleanup

### Navigation Implementation

The app uses Nylo's navigation helpers throughout:

- **`routeTo()`** - For standard navigation between pages
- **`routeToAuthenticatedRoute()`** - For navigation to authenticated pages
- **`NavigationType.pushAndForgetAll`** - For clearing navigation stack
- **`data()`** - For receiving data from previous pages

### Environment Configuration

The app uses the existing `.env` file for API configuration:
```
API_BASE_URL="https://your-api-endpoint.com"
```

## Usage

1. Start the app (opens to Sign In page)
2. Navigate to Sign Up page
3. Fill in registration details
4. Complete OTP verification
5. Login with email and password
6. Access the main app (BaseNavigationHub)
7. All API calls automatically include Bearer token
8. Logout clears both server and local authentication

## Security Notes

- Passwords are sent in plain text (should be hashed on the server)
- Tokens are stored locally using Nylo's Auth system
- API calls include authentication headers for protected endpoints
- Authentication routes are excluded from Bearer token requirement
- Logout ensures both server and client-side session cleanup

## Next Steps

1. Implement proper token expiration handling
2. Add password hashing on the client side
3. Implement proper error handling for different API response codes
4. Add biometric authentication support
5. Implement "Remember Me" functionality
6. Add token refresh mechanism 