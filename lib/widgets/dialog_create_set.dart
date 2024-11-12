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

class DialogCreateSet extends ConsumerStatefulWidget {
  final FlashcardSets? flashcardSet;
  const DialogCreateSet({super.key, this.flashcardSet});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DialogCreateSetState();
}

class _DialogCreateSetState extends ConsumerState<DialogCreateSet> {
  final supabase = Supabase.instance.client;
  late TextEditingController setNameController;
  late TextEditingController setDesController;

  bool get isEditing => widget.flashcardSet != null;

  @override
  void initState() {
    super.initState();

    setNameController = TextEditingController(
      text: isEditing ? widget.flashcardSet?.title : '',
    );
    setDesController = TextEditingController(
      text: isEditing ? widget.flashcardSet?.description : '',
    );
  }

  @override
  void dispose() {
    setNameController.dispose();
    setDesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingPageProvider);
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : AlertDialog(
            actions: [
              textButton(
                  context: context,
                  text: "Hủy bỏ",
                  onPressed: () {
                    context.pop();
                  }),
              textButton(
                  context: context,
                  text: isEditing ? "Lưu" : "Tạo",
                  onPressed: () {
                    isEditing ? updateCardSet() : createCardSet();
                  }),
            ],
            title: rowTitleDialogCreateSet(context),
            contentPadding: const EdgeInsets.all(15),
            content: SizedBox(
              height: 180,
              child: Column(
                children: [
                  CommonTextFormField(
                    labelText: "Tên bộ thẻ",
                    icon: const Icon(Icons.abc),
                    controller: setNameController,
                  ),
                  const Gap(10),
                  CommonTextFormField(
                    maxLines: 3,
                    labelText: "Mô tả",
                    icon: const Icon(
                      Icons.description,
                    ),
                    controller: setDesController,
                  ),
                ],
              ),
            ),
          );
  }

  void createCardSet() async {
    final setName = setNameController.text.trim();
    final setDes = setDesController.text.trim();
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      SessionService().checkSession(context);
      return;
    }

    if (setName.isNotEmpty) {
      ref.watch(isLoadingPageProvider.notifier).state = true;

      final newSetDoc =
          FirebaseFirestore.instance.collection('flashcardSets').doc();
      final setId = newSetDoc.id;

      final flashcardSet = FlashcardSets(
        setId: setId,
        userId: userId,
        title: setName,
        description: setDes,
        isFavorite: false,
        isDefault: false,
        createdAt: DateTime.now().toString(),
      );

      await ref
          .read(flashcardSetsProvider.notifier)
          .createFlashcardSet(flashcardSet, context)
          .then((value) {
        if (!mounted) {
          return;
        }
        ref.watch(isLoadingPageProvider.notifier).state = false;
        context.pop();
        AppAlerts.showFlushBar(
            context, "Tạo bộ thẻ thành công", AlertType.success);
      }).catchError((error) {
        if (!mounted) {
          return;
        }
        AppAlerts.showFlushBar(context, "Đã có lỗi xảy ra", AlertType.error);
      });
    } else {
      AppAlerts.showFlushBar(context, "Bộ thẻ phải có tên", AlertType.error);
    }
  }

  void updateCardSet() async {
    final setName = setNameController.text.trim();
    final setDes = setDesController.text.trim();

    if (setName.isNotEmpty && widget.flashcardSet != null) {
      ref.watch(isLoadingPageProvider.notifier).state = true;

      final updatedFlashcardSet = widget.flashcardSet!.copyWith(
        title: setName,
        description: setDes,
        updatedAt: DateTime.now().toString(),
      );

      await ref
          .read(flashcardSetsProvider.notifier)
          .updateSet(updatedFlashcardSet, context)
          .then((value) {
        if (!mounted) {
          return;
        }
       ref.watch(isLoadingPageProvider.notifier).state = false;
        context.pop();
        AppAlerts.showFlushBar(
            context, "Sửa bộ thẻ thành công", AlertType.success);
      }).catchError((error) {
        if (!mounted) {
          return;
        }
        AppAlerts.showFlushBar(context, "Đã có lỗi xảy ra", AlertType.error);
      });
    } else {
      AppAlerts.showFlushBar(context, "Bộ thẻ phải có tên", AlertType.error);
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
              text: isEditing ? "Sửa bộ thẻ" : "Bộ thẻ mới",
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
