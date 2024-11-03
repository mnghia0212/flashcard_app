import 'package:flashcard_app/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlashcardsApp extends ConsumerWidget {
  const FlashcardsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routesConfig = ref.watch(routesProvider);
    return MaterialApp.router(
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      routerConfig: routesConfig,
    );
  }
}
