import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserNotifier extends StateNotifier<UserState> {
  final UserRepositories _repository;

  UserNotifier(this._repository) : super(const UserState.initial()) {
    getUser(); // Gọi hàm getUser khi khởi tạo
  }

  Future<void> createUser(Users user) async {
    try {
      await _repository.createUser(user);
      getUser();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void getUser() async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      
      if (session != null) {
        final userId = session.user.id;
        final user = await _repository.getUser(userId);
        state = state.copyWith(user: user);
      } else {
        debugPrint("No valid session or user found.");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void updateUser(Users user) {
    state = state.copyWith(user: user); 
  }

  void clearUser(WidgetRef ref) {
    state = const UserState.initial(); 
    ref.read(userIdProvider.notifier).state = null;
  }
}
