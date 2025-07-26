import 'package:flashcard_app/data/datasource/datasource.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.read(userIdProvider);

    if (userId == null) {
      return const Center(
        child: Text('Please log in to access the home screen.'),
      );
    }

    final uncompletedNewbieMissions = getUncompletedNewbieMissions(ref, userId);

    return Scaffold(
      body: Container(
            child: Column(
              children: data.isNotEmpty
                ? 
                // Display UI for uncompleted newbie missions
                : 
                // Display UI for completed newbie missions
                
            ),
          );
    );
  }

  List<String> getUncompletedNewbieMissions(WidgetRef ref, String userId) {
    final user = ref.read(userProvider).user;
    if (user == null) {
      return ['No user data available'];
    }

    final uncompletedMissions = user.newbieMissions.entries
        .where((entry) => entry.value == false)
        .map((entry) => entry.key)
        .toList();
    return uncompletedMissions;
  }
}