import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DialogDeleteGroupMember extends ConsumerWidget {
  final String memberId;
  const DialogDeleteGroupMember({super.key, required this.memberId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingPageProvider);
    final colors = context.colorScheme;
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : AlertDialog(
            title: DisplayText(
              text:
                  "Bạn có chắc muốn xóa thành viên này ra khỏi nhóm chứ ?",
              color: colors.primary,
              fontWeight: FontWeight.bold,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const DisplayText(
                  text: "Hủy",
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () async {
                  ref.watch(isLoadingPageProvider.notifier).state = true;

                  await GroupDatasource().deleteMember(memberId)
                      .then((value) {
                    ref.watch(isLoadingPageProvider.notifier).state = false;
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                    AppAlerts.showFlushBar(
                      context,
                      "Xóa thành viên nhóm thành công",
                      AlertType.success,
                    );
                  });
                },
                child: const DisplayText(
                  text: "Xóa",
                  color: Colors.black,
                ),
              ),
            ],
          );
  }
}
