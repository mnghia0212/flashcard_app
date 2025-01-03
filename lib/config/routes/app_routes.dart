import 'package:flashcard_app/config/config.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/widgets/widgets.dart';
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
    path: RouteLocation.profileScreen,
    parentNavigatorKey: navigationKey,
    builder: (context, state) => const ProfileScreen(),
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
    path: RouteLocation.personalInformation,
    parentNavigatorKey: navigationKey,
    builder: (context, state) {
      Users userState = state.extra as Users;
      return PersonalInformation(userState: userState);
    },
  ),
  GoRoute(
    path: RouteLocation.changePasswordScreen,
    parentNavigatorKey: navigationKey,
    builder: (context, state) {
      Users userState = state.extra as Users;
      return ChangePasswordScreen(userState: userState);
    },
  ),
  GoRoute(
    path: RouteLocation.requestSentScreen,
    parentNavigatorKey: navigationKey,
    builder: (context, state) {
      Users userState = state.extra as Users;
      return RequestSentScreen(userState: userState);
    },
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
      dynamic set = state.extra as dynamic;
      return WriteModeStudy(set: set);
    },
  ),
  GoRoute(
    path: RouteLocation.flipModeStudy,
    parentNavigatorKey: navigationKey,
    builder: (context, state) {
      dynamic set = state.extra as dynamic;
      return FlipStudyMode(set: set);
    },
  ),
  GoRoute(
    path: RouteLocation.abcdModeStudy,
    parentNavigatorKey: navigationKey,
    builder: (context, state) {
      dynamic set = state.extra as dynamic;
      return AbcdModeStudy(set: set);
    },
  ),
  // GoRoute(
  //   path: RouteLocation.speedRecallModeStudy,
  //   parentNavigatorKey: navigationKey,
  //   builder: (context, state) {
  //     dynamic set = state.extra as dynamic;
  //     return SpeedRecallModeStudy(set: set);
  //   },
  // ),

  GoRoute(
      path: RouteLocation.endTestSessionScreen,
      parentNavigatorKey: navigationKey,
      builder: (context, state) {
        final rightAnswerCount = state.pathParameters['rightAnswerCount'];
        final wrongAnswerCount = state.pathParameters['wrongAnswerCount'];
        return EndTestSessionScreen(
            rightAnswerCount: rightAnswerCount,
            wrongAnswerCount: wrongAnswerCount);
      }),

  GoRoute(
    path: RouteLocation.endStudySessionScreen,
    parentNavigatorKey: navigationKey,
    builder: (context, state) {
      dynamic set = state.extra as dynamic;
      final studyMode = state.pathParameters['studyMode'];
      return EndStudySessionScreen(set: set, studyMode: studyMode);
    },
  ),

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
      Groups group = state.extra as Groups;
      return StudyGroupScreen(
        group: group
      );
    },
  ),
];
