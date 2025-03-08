import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/future_builder_get_user.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class DisplayListOfGroupMembersTab extends ConsumerWidget {
  final String groupId;
  final String createdBy;
  const DisplayListOfGroupMembersTab({super.key, required this.groupId, required this.createdBy});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupMembersAsync = ref.watch(groupMembersStreamProvider(groupId));
    final colors = context.colorScheme;

    return groupMembersAsync.when(
      data: (groupMembers) => groupMembers.isEmpty
          ? const Center(
              child: DisplayTitle(text: "Thành viên trống"),
            )
          : _listViewGroupMember(groupMembers, colors),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _listViewGroupMember(
      List<GroupMembers> groupMembers, ColorScheme colors) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: groupMembers.length,
      itemBuilder: (context, index) {
        final groupMember = groupMembers[index];
        return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: colors.primaryContainer,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16)),
            child: ListTile(
                leading: const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/ava2.jpg'),
                ),
                title: FutureBuilderGetUser(userId: groupMember.userId),
                subtitle: DisplayText(
                  text: Helpers.stringToDateTime(groupMember.joinedAt),
                  color: Colors.black,
                  fontSize: 15,
                ),
                trailing: groupMember.userId == createdBy
                    ? const Icon(Icons.star, size: 25)
                    : PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'delete') {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return DialogDeleteGroupMember(
                                  memberId: groupMember.groupMemberId,
                                );
                              },
                            );
                          } else {
                            return;
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'delete',
                            child:
                                DisplayText(text: "Xóa", color: Colors.black),
                          ),
                        ],
                      )));
      },
      separatorBuilder: (context, index) {
        return const Gap(15);
      },
    );
  }
}
