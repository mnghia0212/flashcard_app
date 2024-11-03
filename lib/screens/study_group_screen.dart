import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudyGroupScreen extends ConsumerWidget {
  final String? groupId;
  const StudyGroupScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userIdProvider);

    if (userId == null) {
      return const CircularProgressIndicator();
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: DisplayTitle(text: groupId ?? "Error group id"),
            bottom: const TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3,
                tabs: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.message, size: 25),
                  ),
                  Icon(Icons.group, size: 25),
                  Icon(Icons.notifications, size: 25),
                ]),
          ),
          body: TabBarView(children: [
            DiscussTab(groupId: groupId, userId: userId),

            const Icon(
              Icons.group,
              size: 100,
            ),

            const Icon(
              Icons.notifications,
              size: 100,
            ),
          ])),
    );
  }
}
