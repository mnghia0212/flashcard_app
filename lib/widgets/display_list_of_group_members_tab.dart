import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class DisplayListOfGroupMembersTab extends ConsumerWidget {
  final String groupId;
  const DisplayListOfGroupMembersTab({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupMembersAsync = ref.watch(groupMembersStreamProvider(groupId));
    return groupMembersAsync.when(
      data: (groupMembers) => groupMembers.isEmpty
        ? const Center(
          child: DisplayTitle(text: "Thành viên trống"),
        )
        : _listViewGroupMember(groupMembers),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _listViewGroupMember(List<GroupMembers> groupMembers) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: groupMembers.length,
      itemBuilder: (context, index) {
        final groupMember = groupMembers[index];
        return Container(
          color: Colors.red,
          padding:  const EdgeInsets.all(10),
            child: ListTile(
          leading: const CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/images/ava2.jpg'),
          ),
          title: const DisplayText(text: "hehe",color:  Colors.black, fontWeight: FontWeight.bold,),
          subtitle: DisplayText(text: groupMember.joinedAt, color: Colors.black, fontSize: 15,),
        ));
      },
      separatorBuilder: (context, index) {
        return const Gap(15);
      },
    );
  }
}
