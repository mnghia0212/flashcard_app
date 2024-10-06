import 'package:firebase_core/firebase_core.dart';
import 'package:flashcard_app/app/app.dart';
import 'package:flashcard_app/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Supabase.initialize(
    url: SupabaseService.url,
    anonKey: SupabaseService.anonKey,
  );
  runApp(const ProviderScope(child: FlashcardsApp()));
}
