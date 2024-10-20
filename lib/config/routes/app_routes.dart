import 'package:flashcard_app/config/config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flashcard_app/screens/screens.dart';

final navigationKey = GlobalKey<NavigatorState>();
final appRoutes = [
  GoRoute(
    path: RouteLocation.home,
    parentNavigatorKey: navigationKey,
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    path: RouteLocation.logIn,
    parentNavigatorKey: navigationKey,
    builder: (context, state) => const LogInScreen(),
  ),
  GoRoute(
    path: RouteLocation.signUp,
    parentNavigatorKey: navigationKey,
    builder: (context, state) => const SignUpScreen(),
  ),
  GoRoute(
    path: RouteLocation.firstLogIn,
    parentNavigatorKey: navigationKey,
    builder: (context, state) => const FirstLoginScreen(),
  ),
  GoRoute(
    path: RouteLocation.bottomNavigator,
    parentNavigatorKey: navigationKey,
    builder: (context, state) => const BottomNavigator(),
  ),
  GoRoute(
    path: RouteLocation.splash,
    parentNavigatorKey: navigationKey,
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    path: RouteLocation.flashcard,
    parentNavigatorKey: navigationKey,
    builder: (context, state) {
      final  setId = state.pathParameters['setId'];
      return FlashcardScreen(setId: setId);
    },
  ),
  GoRoute(
    path: RouteLocation.writeModeStudy,
    parentNavigatorKey: navigationKey,
    builder: (context, state) {
      final  setId = state.pathParameters['setId'];
      return WriteModeStudy(setId: setId);
    },
  ),
  GoRoute(
    path: RouteLocation.flipModeStudy,
    parentNavigatorKey: navigationKey,
    builder: (context, state) {
      final  setId = state.pathParameters['setId'];
      return FlipStudyMode(setId: setId);
    },
  ),
  GoRoute(
    path: RouteLocation.abcdModeStudy,
    parentNavigatorKey: navigationKey,
    builder: (context, state) {
      final  setId = state.pathParameters['setId'];
      return AbcdModeStudy(setId: setId);
    },
  ),
  GoRoute(
    path: RouteLocation.speedRecallModeStudy,
    parentNavigatorKey: navigationKey,
    builder: (context, state) {
      final  setId = state.pathParameters['setId'];
      return SpeedRecallModeStudy(setId: setId);
    },
  ),
];
