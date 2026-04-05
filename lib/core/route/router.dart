part of '../core_lib.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: RoutesName.initial,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutesName.loginScreen,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutesName.homeScreen,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RoutesName.signupScreen,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: RoutesName.phoneNumberScreen,
        builder: (context, state) => const PhoneNumberScreen(),
      ),
      GoRoute(
        path: RoutesName.otpScreen,
        builder: (context, state) => OTPVerificationScreen(verificationId: '${state.extra}',),
      ),
      GoRoute(
        path: RoutesName.riderMapScreen,
        builder: (context, state) => const RiderMapScreen(),
      ),
      GoRoute(
        path: RoutesName.chooseLocationByMapScreen,
        builder: (context, state) => const ChooseLocationByMapScreen(),
      ),
    ],
  );
}
