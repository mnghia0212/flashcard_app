import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        context.go('/bottomNavigator');  
      } else {
        context.go('/firstLogin');
      }
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),  // Loading icon
      ),
    );
  }
}