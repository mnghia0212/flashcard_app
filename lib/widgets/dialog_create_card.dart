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
  final String setId;
  final Flashcards? flashcard;
  const DialogCreateCard({super.key, required this.setId, this.flashcard});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DialogCreateCardState();
}

class _DialogCreateCardState extends ConsumerState<DialogCreateCard> {
  final supabase = Supabase.instance.client;
  late TextEditingController frontContentController;
  late TextEditingController backContentController;
  String? audioFileName, audioUrl;
  String? videoFileName, videoUrl;
  File? audioFile, videoFile;

  bool get isEditing => widget.flashcard != null;

  @override
  void initState() {
    getCardValue();
    super.initState();
  }

  void getCardValue() {
    frontContentController = TextEditingController(
        text: isEditing ? widget.flashcard!.frontContent : " ");

    backContentController = TextEditingController(
        text: isEditing ? widget.flashcard!.backContent : " ");

    audioFileName = isEditing ? widget.flashcard!.audioFile : null;

    videoFileName = isEditing ? widget.flashcard!.videoFile : null;

    audioUrl = isEditing ? widget.flashcard!.audioPath : null;

    videoUrl = isEditing ? widget.flashcard!.videoPath : null;
  }

  @override
  void dispose() {
    frontContentController.dispose();
    backContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingPageProvider);
    final colors = context.colorScheme;
    final size = context.deviceSize;
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : AlertDialog(
            actions: [
              textButton(
                  context: context,
                  text: "Hủy bỏ",
                  onPressed: () => context.pop()),
              textButton(
                onPressed: () {
                  isEditing ? updateCard() : createCard(widget.setId);
                },
                context: context,
                text: isEditing ? "Lưu" : "Tạo",
              ),
            ],
            title: rowTitleDialogCreateSet(context),
            contentPadding: const EdgeInsets.all(15),
            content: _contentDialog(size, colors),
          );
  }

  void deleteAudioUrl() {
    setState(() {
      audioFileName = null;
      audioFile = null;
    });
  }

  void deleteVideoUrl() {
    setState(() {
      videoFileName = null;
      videoFile = null;
    });
  }

  void updateCard() async {
    final answer = backContentController.text.trim();
    final question = frontContentController.text.trim();

    if (answer.isNotEmpty && question.isNotEmpty) {
      ref.read(isLoadingPageProvider.notifier).state = true;

      if (audioFileName == null) {
        setState(() {
          audioUrl = null;
          audioFile = null;
        });
      } else {
        if (audioFileName != widget.flashcard!.audioFile) {
          await uploadFile(audioFile!, "audio");
        }
      }

      if (videoFileName == null) {
        setState(() {
          videoUrl = null;
          videoFile = null;
        });
      } else {
        if (videoFileName != widget.flashcard!.videoFile) {
          await uploadFile(videoFile!, "video");
        }
      }

      log("audio name: $audioFileName");
      log("audio url: $audioUrl");
      log("video name: $videoFileName");
      log("video url: $videoUrl");

      final updatedFlashcard = widget.flashcard!.copyWith(
          frontContent: question,
          backContent: answer,
          audioFile: audioFileName,
          videoFile: videoFileName,
          audioPath: audioUrl,
          videoPath: videoUrl,
          updatedAt: DateTime.now().toString());
      log("card: $updatedFlashcard");

      try {
        await ref
            .read(flashcardsProvider.notifier)
            .updateCard(updatedFlashcard)
            .then((value) {
          ref.read(isLoadingPageProvider.notifier).state = false;

          if (!mounted) {
            return;
          }

          context.pop();
          AppAlerts.showFlushBar(
              context, "Sửa thẻ thành công", AlertType.success);
        });
      } catch (e) {
        debugPrint("Error creating flashcard: $e");
        if (!mounted) {
          return;
        }
        AppAlerts.showFlushBar(context, "Lỗi khi sửa thẻ: $e", AlertType.error);
      }
    } else {
      AppAlerts.showFlushBar(
          context, "Thẻ phải có đủ mặt trước và sau", AlertType.error);
    }
  }

  void createCard(String setId) async {
    final answer = backContentController.text.trim();
    final question = frontContentController.text.trim();
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      SessionService().checkSession(context);
      return;
    }

    if (answer.isNotEmpty && question.isNotEmpty) {
      ref.read(isLoadingPageProvider.notifier).state = true;

      //upload file to storage
      List<Future<void>> uploadTasks = [];
      if (audioFileName != null) {
        uploadTasks.add(uploadFile(audioFile!, "audio"));
      }
      if (videoFileName != null) {
        uploadTasks.add(uploadFile(videoFile!, "video"));
      }
      await Future.wait(uploadTasks); 

      //create new card
      final newCardDoc =
          FirebaseFirestore.instance.collection("flashcards").doc();

      final flashcardId = newCardDoc.id;
      final flashcard = Flashcards(
        flashcardId: flashcardId,
        setId: setId,
        userId: userId,
        frontContent: question,
        backContent: answer,
        audioPath: audioUrl,
        videoPath: videoUrl,
        audioFile: audioFileName,
        videoFile: videoFileName,
        createdAt: DateTime.now().toString(),
      );

      try {
        await ref
            .read(flashcardsProvider.notifier)
            .createCardInSet(flashcard, setId)
            .then((value) {
          ref.read(isLoadingPageProvider.notifier).state = false;

          if (!mounted) {
            return;
          }

          context.pop();

          AppAlerts.showFlushBar(
              context, "Tạo thẻ thành công", AlertType.success);
        });
      } catch (e) {
        ref.read(isLoadingPageProvider.notifier).state = false;
        debugPrint("Error creating flashcard: $e");
        if (!mounted) {
          return;
        }
        AppAlerts.showFlushBar(context, "Lỗi khi tạo thẻ: $e", AlertType.error);
      }
    } else {
      AppAlerts.showFlushBar(
          context, "Thẻ phải có đủ mặt trước và sau", AlertType.error);
    }
  }

  SizedBox _contentDialog(Size size, ColorScheme colors) {
    return SizedBox(
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
              controller: frontContentController,
            ),
            const Gap(10),
            CommonTextFormField(
              maxLines: 3,
              labelText: "Câu trả lời",
              icon: const Icon(
                Icons.description,
              ),
              controller: backContentController,
            ),
            const Gap(15),
            _buttonPickFile(colors, pickAudioFile, "Chọn Audio",
                audioFileName != null, deleteAudioUrl),
            const Gap(10),
            DisplayText(
              text: audioFileName ?? "Chưa có audio",
              color: Colors.black,
              textAlign: TextAlign.center,
            ),
            const Gap(40),
            _buttonPickFile(colors, pickVideoFile, "Chọn video",
                videoFileName != null, deleteVideoUrl),
            const Gap(10),
            DisplayText(
              text: videoFileName ?? "Chưa có video",
              color: Colors.black,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Row _buttonPickFile(
      ColorScheme colors,
      Future<void> Function() pickFileFunction,
      String text,
      bool fileCondition,
      VoidCallback removeFileFunction) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              await pickFileFunction();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                padding: const EdgeInsets.symmetric(vertical: 15)),
            child: DisplayText(text: text),
          ),
        ),
        const Gap(10),
        if (fileCondition)
          OutlinedButton(
            onPressed: () => removeFileFunction(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              side: BorderSide(width: 1, color: colors.primary),
            ),
            child: const Icon(Icons.delete),
          )
      ],
    );
  }

  Future<void> pickAudioFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
      );

      if (result != null && result.files.single.path != null) {
        final fileSize = result.files.single.size;
        const maxSize = 5 * 1024 * 1024;

        if (fileSize > maxSize) {
          AppAlerts.showFlushBar(
              context,
              "Tệp âm thanh quá lớn, vui lòng chọn tệp nhỏ hơn 5MB",
              AlertType.error);
          return;
        }

        final fileName = result.files.single.name;
        final file = File(result.files.single.path!);

        setState(() {
          audioFileName = fileName.toString();
          audioFile = file;
        });
        log("audio file: $fileName");
      } else {
        AppAlerts.showFlushBar(
            context, "Không tìm thấy tệp âm thanh", AlertType.error);
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
      final fileSize = result.files.single.size;
      const maxSize = 10 * 1024 * 1024;

      if (fileSize > maxSize) {
        AppAlerts.showFlushBar(
            context,
            "Tệp video quá lớn, vui lòng chọn tệp nhỏ hơn 10MB",
            AlertType.error);
        return;
      }

      final fileName = result.files.single.name;
      File file = File(result.files.single.path!);

      setState(() {
        videoFileName = fileName.toString();
        videoFile = file;
      });
      log("video file: $fileName");
    } else {
      AppAlerts.showFlushBar(
          context, "Không tìm thấy tệp video", AlertType.error);
    }
  }

  Future<void> uploadFile(File file, String fileType) async {
    try {
      String extension = fileType == 'audio' ? 'mp3' : 'mp4';
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';
      Reference ref =
          FirebaseStorage.instance.ref().child('flashcards/$fileName');
      UploadTask uploadTask = ref.putFile(file);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        log("Upload $fileType progress: $progress%");
      });

      await uploadTask.whenComplete(() async {
        String fileUrl = await ref.getDownloadURL();
        setState(() {
          if (fileType == 'audio') {
            audioUrl = fileUrl;
            log("audioUrl: $audioUrl");
          } else if (fileType == 'video') {
            videoUrl = fileUrl;
            log("videoUrl: $videoUrl");
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
              text: isEditing ? "Cập nhật thẻ" : "Tạo thẻ mới",
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
