import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class DisplayListOfGroups extends ConsumerWidget {
  const DisplayListOfGroups({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupAsync = ref.watch(groupStreamProvider);

    return groupAsync.when(
      data: (groups) => groups.isEmpty
          ? const EmptyContainer(
              emptyType: EmptyType.group,
            )
          : _listViewCardSets(groups, ref),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  ListView _listViewCardSets(List<Groups> groups, WidgetRef ref) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groups.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final group = groups[index];
        return _inkWellListTile(context, group);
      },
      separatorBuilder: (context, index) {
        return const Gap(10);
      },
    );
  }

  InkWell _inkWellListTile(BuildContext context, Groups group) {
    return InkWell(
      onTap: () => context.push("/studyGroupScreen/${group.groupId}"),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 2),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: _streamListTile(group)),
    );
  }

  ListTile _streamListTile(Groups group) {
    return ListTile(
      title: DisplayText(
        text: group.groupName,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      subtitle: const DisplayText(
        text: "uoc j do an nay duoc A",
        color: Colors.black,
        fontSize: 16,
      ),
      leading: Image.asset("assets/images/groups.png"),
      trailing: const Icon(Icons.more_vert),
    );
  }
}
