import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/future_builder_get_user.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class RequestJoinGroupTab extends ConsumerWidget {
  final String? groupId;
  const RequestJoinGroupTab({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestAsync = ref.watch(requestsStreamProvider);
    final isLoading = ref.watch(isLoadingPageProvider);
    final sizes = context.deviceSize;
    return isLoading
        ? const CircularProgressIndicator()
        : requestAsync.when(
            data: (requests) => requests.isEmpty
                ? const Center(
                    child: DisplayText(
                      text: "Không có yêu cầu nào",
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : SizedBox(
                    height: sizes.height,
                    width: sizes.width,
                    child: _listViewRequests(requests, context, ref)),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          );
  }

  void deleteRequest(
      String requestId, BuildContext context, WidgetRef ref) async {
    ref.read(isLoadingPageProvider.notifier).state = true;
    await RequestDatasource().deleteRequest(requestId).then((value) {
      ref.read(isLoadingPageProvider.notifier).state = false;
      AppAlerts.showFlushBar(
          context, "Đã xóa yêu cầu tham gia nhóm", AlertType.success);
    });
  }

  void acceptRequest(
      Requests request, BuildContext context, WidgetRef ref) async {
    ref.read(isLoadingPageProvider.notifier).state = true;
    final newMemberDoc =
        FirebaseFirestore.instance.collection("groupMembers").doc();
    final newMemberId = newMemberDoc.id;
    final newMember = GroupMembers(
        groupMemberId: newMemberId,
        groupId: request.groupId,
        userId: request.userId,
        joinedAt: DateTime.now().toString(),
        isAdmin: false);

    await GroupDatasource().joinGroup(newMember).then((value) async {
      await RequestDatasource().deleteRequest(request.requestId);
      ref.read(isLoadingPageProvider.notifier).state = false;
      AppAlerts.showFlushBar(
          context, "Đã duyệt yêu cầu tham gia nhóm", AlertType.success);
    });
  }

  Widget _listViewRequests(
      List<Requests> requests, BuildContext context, WidgetRef ref) {
    final groupRequests =
        requests.where((request) => request.groupId == groupId);
    return ListView.separated(
      padding: const EdgeInsets.all(10),
      physics: const BouncingScrollPhysics(),
      itemCount: groupRequests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return ShadowBoxContainer(
          height: 80,
          child: ListTile(
            leading: const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/ava2.jpg'),
            ),
            title: FutureBuilderGetUser(userId: request.userId),
            subtitle: DisplayText(
              text: Helpers.stringToDateTime(request.requestedAt),
              color: Colors.black,
              fontSize: 13,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAnswerButton(() => acceptRequest(request, context, ref),
                    Icons.check, Colors.green),
                const Gap(5),
                _buildAnswerButton(
                    () => deleteRequest(request.requestId, context, ref),
                    Icons.close,
                    Colors.red)
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Gap(15);
      },
    );
  }

  Widget _buildAnswerButton(
      VoidCallback onPressed, IconData icon, Color color) {
    return SizedBox(
      width: 55,
      height: 35,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: color.withOpacity(0.8),
          // side: BorderSide(width: 1, color: color)
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 12,
        ),
      ),
    );
  }
}
