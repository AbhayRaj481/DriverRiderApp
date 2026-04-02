part of '../core_lib.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: RoutesName.initial,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutesName.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutesName.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RoutesName.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: RoutesName.phoneNumber,
        builder: (context, state) => const PhoneNumberScreen(),
      ),
      GoRoute(
        path: RoutesName.otp,
        builder: (context, state) => OTPVerificationScreen(verificationId: '${state.extra}',),
      ),
    ],
  );
}
