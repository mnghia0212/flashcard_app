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
    path: RouteLocation.testMode,
    parentNavigatorKey: navigationKey,
    builder: (context, state) => const TestMode(),
  ),
  GoRoute(
    path: RouteLocation.flashcard,
    parentNavigatorKey: navigationKey,
    builder: (context, state) {
      final setId = state.pathParameters['setId'];
      final setName = state.pathParameters['setName'];
      return FlashcardScreen(setId: setId, setName: setName);
    },
  ),
  GoRoute(
    path: RouteLocation.writeModeStudy,
    parentNavigatorKey: navigationKey,
    builder: (context, state) {
      final setId = state.pathParameters['setId'];
      final setName = state.pathParameters['setName'];
      return WriteModeStudy(setId: setId, setName: setName);
    },
  ),
  GoRoute(
    path: RouteLocation.flipModeStudy,
    parentNavigatorKey: navigationKey,
    builder: (context, state) {
      final setId = state.pathParameters['setId'];
      final setName = state.pathParameters['setName'];
      return FlipStudyMode(setId: setId, setName: setName);
    },
  ),
  GoRoute(
    path: RouteLocation.abcdModeStudy,
    parentNavigatorKey: navigationKey,
    builder: (context, state) {
      final setId = state.pathParameters['setId'];
      final setName = state.pathParameters['setName'];
      return AbcdModeStudy(setId: setId, setName: setName);
    },
  ),
  GoRoute(
    path: RouteLocation.speedRecallModeStudy,
    parentNavigatorKey: navigationKey,
    builder: (context, state) {
      final setId = state.pathParameters['setId'];
      final setName = state.pathParameters['setName'];
      return SpeedRecallModeStudy(setId: setId, setName: setName);
    },
  ),
  GoRoute(
      path: RouteLocation.endStudySessionScreen,
      parentNavigatorKey: navigationKey,
      builder: (context, state) {
        final rightAnswerCount = state.pathParameters['rightAnswerCount'];
        final wrongAnswerCount = state.pathParameters['wrongAnswerCount'];
        return EndStudySessionScreen(
            rightAnswerCount: rightAnswerCount,
            wrongAnswerCount: wrongAnswerCount);
      }),
  GoRoute(
    path: RouteLocation.defaultFlashcardsScreen,
    parentNavigatorKey: navigationKey,
    builder: (context, state) {
      final setId = state.pathParameters['setId'];
      final setName = state.pathParameters['setName'];
      return DefaultFlashcardsScreen(setId: setId, setName: setName);
    },
  ),
  GoRoute(
    path: RouteLocation.studyGroupScreen,
    parentNavigatorKey: navigationKey,
    builder: (context, state) {
      final groupId = state.pathParameters['groupId'];
      final groupName = state.pathParameters['groupName'];
      return StudyGroupScreen(groupId: groupId, groupName: groupName,);
    },
  ),
];
