import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DialogJoinGroup extends ConsumerStatefulWidget {
  const DialogJoinGroup({super.key});

  @override
  ConsumerState<DialogJoinGroup> createState() => _DialogJoinGroupState();
}

class _DialogJoinGroupState extends ConsumerState<DialogJoinGroup> {
  final supabase = Supabase.instance.client;
  final TextEditingController groupIdController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? errorMsg;

  @override
  void dispose() {
    groupIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = context.deviceSize;
    final isLoading = ref.watch(isLoadingPageProvider);
    return AlertDialog(
      actions: [
        textButton(
            context: context,
            text: "Hủy bỏ",
            onPressed: () {
              context.pop();
            }),
        isLoading
            ? const CircularProgressIndicator()
            : textButton(
                context: context,
                text: "Tham gia",
                onPressed: () {
                  joinGroup();
                }),
      ],
      title: rowTitleDialogCreateSet(context),
      contentPadding: const EdgeInsets.all(15),
      content: Form(
        key: formKey,
        child: SizedBox(
          width: size.width,
          height: 100,
          child: CommonTextFormField(
            labelText: "Mã nhóm",
            icon: const Icon(Icons.abc),
            controller: groupIdController,
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return "Mã nhóm trống";
              }
              return null;
            },
            // validator: ,
          ),
        ),
      ),
    );
  }

  void joinGroup() async {
    final groupId = groupIdController.text.trim();
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      SessionService().checkSession(context);
      return;
    }

    if (formKey.currentState!.validate()) {
      ref.read(isLoadingPageProvider.notifier).state = true;
      final result = await RequestDatasource().requestJoinGroup(groupId);

      setState(() {
        errorMsg = result;
      });

      if (errorMsg != null) {
        ref.read(isLoadingPageProvider.notifier).state = false;
        AppAlerts.showFlushBar(context, "$errorMsg", AlertType.error);
      } else {
        final newRequest =
            FirebaseFirestore.instance.collection("requests").doc();
        final newRequestId = newRequest.id;

        final request = Requests(
            requestId: newRequestId,
            groupId: groupId,
            userId: userId,
            requestedAt: DateTime.now().toString());

        RequestDatasource().sendRequest(request).then((value) {
          ref.read(isLoadingPageProvider.notifier).state = false;
          groupIdController.clear();
          AppAlerts.showFlushBar(
              context, "Đã gửi yêu cầu tham gia nhóm", AlertType.success);
        });
      }
    }
  }

  TextButton textButton(
      {required BuildContext context,
      required String text,
      required Function() onPressed}) {
    return TextButton(
        onPressed: onPressed,
        child: DisplayText(
          text: text,
          color: context.colorScheme.primary,
        ));
  }

  Row rowTitleDialogCreateSet(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.folder),
            const Gap(5),
            DisplayText(
              text: "Tham gia nhóm",
              fontWeight: FontWeight.bold,
              color: context.colorScheme.primary,
            ),
          ],
        ),
        IconButton(
            onPressed: () => context.pop(), icon: const Icon(Icons.close))
      ],
    );
  }
}
