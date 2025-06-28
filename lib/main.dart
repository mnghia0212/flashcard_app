import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  // FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  runApp(const ProviderScope(child: FlashcardsApp()));
}

// @pragma('vm:entry-point')
// Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   log("Handling a background message: ${message.messageId}");
// }

//device token 
// fFT-JxWHQGS5W7N9EZh4w2:APA91bGs6GqHlqt89WqbDQ4GFDTjHt6JbGX7Y2EYMdfYzGqtaMCmdq2btnB0exTXQXVuHiXNf8N1IfxooPPhrXK09UuZ5xfSp36MtrtkkmmkPRUmc6f5yKU
