import 'package:flashcard_app/widgets/display_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SessionService {
  final supabase = Supabase.instance.client;

  Future<void> checkSession(BuildContext context) async {
    final session = supabase.auth.currentSession;

    if (session == null) {
      showSessionExpiredDialog(context);
    } else {
      print("Session accept, userId: ${session.user.id}");
    }
  }

  void showSessionExpiredDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,  
      builder: (BuildContext context) {
        return AlertDialog(
          title: const DisplayText(
            text: "Phiên đăng nhập đã hết hạn",
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          content: const DisplayText(
            text: "Vui lòng đăng nhập lại",
            color: Colors.black,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();  
                context.go('/firstLogin');   
              },
            ),
          ],
        );
      },
    );
  }
}
