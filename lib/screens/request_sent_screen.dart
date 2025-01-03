import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class RequestSentScreen extends ConsumerWidget {
  final Users? userState;
  const RequestSentScreen({super.key, required this.userState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (userState == null) {
      return const Center(
        child: DisplayText(
          text: "Lỗi khi tải dữ liệu",
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    final userId = userState!.userId;
    final isLoading = ref.watch(isLoadingPageProvider);
    final requestAsync = ref.watch(requestsStreamProvider);

    return Scaffold(
      appBar: const CommonAppBar(title: "Yêu cầu đã gửi"),
      body: isLoading
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
                  : _listViewRequests(userId, requests, context, ref),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
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

  Widget _listViewRequests(String userId, List<Requests> requests,
      BuildContext context, WidgetRef ref) {
    final groupRequests = requests.where((request) => request.userId == userId);
    return ListView.separated(
      itemCount: groupRequests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return SizedBox(
          height: 80,
          width: 200,
          child: ListTile(
            leading: const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/ava2.jpg'),
            ),
            title: 
            FutureBuilder<String?>(
              future: GroupDatasource().getGroup(request.groupId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: DisplayText(
                      text: "Lỗi khi tải nhóm",
                      color: Colors.black,
                    ),
                  );
                } else if (!snapshot.hasData) {
                  return const Center(
                      child: DisplayText(
                    text: "Lỗi khi tải nhóm",
                    color: Colors.black,
                  ));
                } else {
                  final String groupName = snapshot.data!;
                  return DisplayText(
                    text: "nhóm: $groupName",
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  );
                }
              },
            ),
            subtitle: DisplayText(
              text: request.requestedAt,
            ),
            trailing: _buildAnswerButton(
                () => deleteRequest(request.requestId, context, ref),
                Icons.delete,
                Colors.black12),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Gap(15);
      },
    );
  }

  ElevatedButton _buildAnswerButton(
      VoidCallback onPressed, IconData icon, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: color.withOpacity(0.3),
          side: BorderSide(width: 1, color: color)),
      child: Icon(
        icon,
        color: Colors.white,
        size: 10,
      ),
    );
  }
}
