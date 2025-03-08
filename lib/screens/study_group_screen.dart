import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudyGroupScreen extends ConsumerWidget {
  final Groups? group;
  const StudyGroupScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userIdProvider);
    final userName = ref.watch(userProvider).user?.userName;
    final isAdmin = group!.createdBy == userId ? true : false;

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
      length: isAdmin ? 4 : 3,
      child: Scaffold(
          appBar: AppBar(
            title: DisplayText(
              text: group!.groupName,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            bottom: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3,
                tabs: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.question_answer, size: 25),
                  ),
                  const Icon(Icons.group, size: 25),
                  if(isAdmin) const Icon(Icons.message),
                  const Icon(Icons.settings, size: 25),
                ]),
          ),
          body: TabBarView(children: [
            DiscussTab(
                groupId: group!.groupId, userId: userId, userName: userName),
            DisplayListOfGroupMembersTab(groupId: group!.groupId, createdBy: group!.createdBy),
           
            if(isAdmin) RequestJoinGroupTab(groupId: group!.groupId,),
            StudyGroupSettings(groupId: group!.groupId)
          ])),
    );
  }
}
