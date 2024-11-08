import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudyGroupScreen extends ConsumerWidget {
  final String? groupId;
  final String? groupName;
  const StudyGroupScreen({super.key, required this.groupId, required this.groupName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userIdProvider);
    final userName = ref.watch(userProvider).user?.userName;

    if (userId == null || userName == null) {
      return const Center(
        child: DisplayText(
          text: "Lỗi khi tải nhóm học",
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }

    return DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: AppBar(
            title: DisplayText(
              text: groupName ?? "Error group name",
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
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
                  Icon(Icons.settings, size: 25),
                ]),
          ),
          body: TabBarView(children: [
            DiscussTab(groupId: groupId!, userId: userId, userName: userName),
            const Icon(
              Icons.group,
              size: 100,
            ),
            const Icon(
              Icons.notifications,
              size: 100,
            ),
            StudyGroupSettings(groupId: groupId!)
          ])),
    );
  }
}
