import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DialogCreateCard extends ConsumerStatefulWidget {
  final String? setId;
  const DialogCreateCard({super.key, required this.setId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DialogCreateCardState();
}

class _DialogCreateCardState extends ConsumerState<DialogCreateCard> {
  final supabase = Supabase.instance.client;
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  String? audioUrl;
  String? videoUrl;

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final size = context.deviceSize;
    return AlertDialog(
      actions: [
        textButton(
            context: context, text: "Hủy bỏ", onPressed: () => context.pop()),
        textButton(
          onPressed: () {
            createCard(widget.setId);
          },
          context: context,
          text: "Tạo",
        ),
      ],
      title: rowTitleDialogCreateSet(context),
      contentPadding: const EdgeInsets.all(15),
      content: SizedBox(
        height: 400,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonTextFormField(
                maxLines: 3,
                labelText: "Câu hỏi",
                icon: const Icon(Icons.abc),
                controller: questionController,
              ),
              const Gap(10),
              CommonTextFormField(
                maxLines: 3,
                labelText: "Câu trả lời",
                icon: const Icon(
                  Icons.description,
                ),
                controller: answerController,
              ),
              const Gap(15),
              _buttonPickFile(colors, pickAudioFile(), "Chọn Audio"),
              const Gap(10),
              DisplayText(
                text: audioUrl ?? "Chưa có audio nào",
                color: Colors.black,
                textAlign: TextAlign.center,
              ),
              const Gap(40),
              _buttonPickFile(colors, pickVideoFile(), "Chọn video"),
              const Gap(10),
              DisplayText(
                text: videoUrl ?? "Chưa có video nào",
                color: Colors.black,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton _buttonPickFile(
      ColorScheme colors, Future<void> function, String text) {
    return ElevatedButton(
      onPressed: () {
        function;
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          padding: const EdgeInsets.symmetric(vertical: 15)),
      child: DisplayText(text: text),
    );
  }

  void createCard(String? setId) async {
    final answer = answerController.text;
    final question = questionController.text;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      SessionService().checkSession(context);
      return;
    }

    if (setId == null) {
      AppAlerts.showFlushBar(context,
          "Lỗi: Không thể tạo thẻ vì thiếu thông tin bộ thẻ", AlertType.error);
      return;
    }

    if (answer.isNotEmpty && question.isNotEmpty) {
      final newCardDoc =
          FirebaseFirestore.instance.collection("flashcards").doc();

      final flashcardId = newCardDoc.id;
      final flashcard = Flashcards(
        flashcardId: flashcardId,
        userId: userId,
        frontContent: question,
        backContent: answer,
        audioPath: audioUrl,
        videoPath: videoUrl,
        createdAt: DateTime.now().toString(),
      );

      try {
        await ref
            .read(flashcardsProvider.notifier)
            .createCardInSet(flashcard, context, setId);
        context.pop();
        AppAlerts.showFlushBar(
            context, "Tạo thẻ thành công", AlertType.success);
      } catch (e) {
        debugPrint("Error creating flashcard: $e");
        AppAlerts.showFlushBar(context, "Lỗi khi tạo thẻ: $e", AlertType.error);
      }
    } else {
      AppAlerts.showFlushBar(
          context, "Thẻ phải có đủ mặt trước và sau", AlertType.error);
    }
  }

  Future<void> pickAudioFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        await uploadFile(file, 'audio');
      } else {
        AppAlerts.showFlushBar(
            context, "Lỗi: Không tìm thấy tệp âm thanh", AlertType.error);
      }
    } catch (e) {
      log("error pick audio: $e");
    }
  }

  Future<void> pickVideoFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      await uploadFile(file, 'video');
    } else {
      AppAlerts.showFlushBar(
          context, "Lỗi: Không tìm thấy tệp video", AlertType.error);
    }
  }

  Future<void> uploadFile(File file, String fileType) async {
    try {
      String extension =
          fileType == 'audio' ? 'mp3' : 'mp4'; // Điều chỉnh phần mở rộng
      String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_$fileType.$extension';
      Reference ref =
          FirebaseStorage.instance.ref().child('flashcards/$fileName');
      UploadTask uploadTask = ref.putFile(file);

      await uploadTask.whenComplete(() async {
        String fileUrl = await ref.getDownloadURL();
        setState(() {
          if (fileType == 'audio') {
            audioUrl = fileUrl;
          } else if (fileType == 'video') {
            videoUrl = fileUrl;
          }
        });
        log("download link: $fileUrl");
      });
    } catch (e) {
      debugPrint('Error uploading file: $e');
      AppAlerts.showFlushBar(context, "Lỗi tải tệp lên: $e", AlertType.error);
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
              text: "Tạo thẻ mới",
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
