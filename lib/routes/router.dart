import '/resources/pages/welcome_page.dart';
import '/resources/pages/welcome_intro_page.dart';
import '/resources/pages/profile_details_page.dart';
import '/resources/pages/video_call_page.dart';
import '/resources/pages/voice_call_page.dart';
import '/resources/pages/chat_screen_page.dart';
import '/resources/pages/base_navigation_hub.dart';
import '/resources/pages/otp_email_verification_page.dart';
import '/resources/pages/otp_phone_verification_page.dart';
import '/resources/pages/sign_up_mobile_page.dart';
import '/resources/pages/sign_up_email_page.dart';
import '/resources/pages/sign_in_page.dart';
import '/resources/pages/not_found_page.dart';
import '/resources/pages/home_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

/* App Router
|--------------------------------------------------------------------------
| * [Tip] Create pages faster 🚀
| Run the below in the terminal to create new a page.
| "dart run nylo_framework:main make:page profile_page"
|
| * [Tip] Add authentication 🔑
| Run the below in the terminal to add authentication to your project.
| "dart run scaffold_ui:main auth"
|
| * [Tip] Add In-app Purchases 💳
| Run the below in the terminal to add In-app Purchases to your project.
| "dart run scaffold_ui:main iap"
|
| Learn more https://nylo.dev/docs/6.x/router
|-------------------------------------------------------------------------- */

appRouter() => nyRoutes((router) {
      router.add(HomePage.path);

      // Add your routes here ...
      // router.add(NewPage.path, transitionType: TransitionType.fade());

      // Example using grouped routes
      // router.group(() => {
      //   "route_guards": [AuthRouteGuard()],
      //   "prefix": "/dashboard"
      // }, (router) {
      //
      // });
      router.add(NotFoundPage.path).unknownRoute();
      router.add(SignInPage.path);
      router.add(SignUpEmailPage.path);
      router.add(SignUpMobilePage.path);
      router.add(OtpPhoneVerificationPage.path);
      router.add(OtpEmailVerificationPage.path);
      router.add(BaseNavigationHub.path);
      router.add(ChatScreenPage.path);
      router.add(VoiceCallPage.path);
      router.add(VideoCallPage.path);
      router.add(ProfileDetailsPage.path);
      router.add(WelcomeIntroPage.path);
      router.add(WelcomePage.path).initialRoute();
    });
