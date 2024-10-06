import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/auth/auth.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String? firestoreUserName;
  String? firestoreEmail;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        if (userDoc.exists) {
          setState(() {
            firestoreUserName = userDoc['userName'];
            firestoreEmail = userDoc['email'];
          });
        }
      }
    } catch (e) {
      log("Error fetching user data from Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
        onPressed: () {
          signOut();

          
        },
        child: const Text("Sign out"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hiển thị email từ Supabase auth
            DisplayHeading(
                text: "Email auth: ${supabase.auth.currentUser?.email}"),

            // Hiển thị email từ Firestore
            DisplayHeading(text: "Email db: ${firestoreEmail ?? 'Loading...'}"),

            // Hiển thị username từ Firestore
            DisplayHeading(
                text: "Username: ${firestoreUserName ?? 'Loading...'}"),
          ],
        ),
      ),
    );
  }

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      ref.read(userProvider.notifier).clearUser(ref);
      context.push('/firstLogin');
      log("Success sign out");
    } on AuthException catch (e) {
      log("Sign out error: $e");
    }
  }
}
