import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/config/theme/app_colors.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final String? setId;
  const CommentScreen({super.key, required this.setId});

  @override
  ConsumerState<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final commentController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentAsync = ref.watch(commentStreamProvider(widget.setId!));
    final userState = ref.watch(userProvider);
    final userStateId = userState.user!.userId;
    final colors = context.colorScheme;

    if (userState.user == null) {
      const DisplayText(
        text: "Đã có lỗi xảy ra khi lấy dữ liệu",
        color: Colors.black,
        fontWeight: FontWeight.bold,
      );
    }

    return Scaffold(
      appBar: const CommonAppBar(title: "Bình luận"),
      body: commentAsync.when(
        data: (comments) => _commentFrame(comments, userStateId, colors),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  void sendComment(String userStateId) async {
    final comment = commentController.text;
    final firestore = FirebaseFirestore.instance;

    if (formKey.currentState!.validate()) {
      ref.read(isLoadingPageProvider.notifier).state = true;
      final newCommentDoc = firestore.collection("comments").doc();
      final newCommentId = newCommentDoc.id;

      final newComment = Comments(
          commentId: newCommentId,
          userId: userStateId,
          setId: widget.setId!,
          text: comment,
          commentedAt: DateTime.now().toString());

      await CommentDatasource().sendComment(newComment).then((value) {
        commentController.clear();
        ref.watch(isLoadingPageProvider.notifier).state = false;
        AppAlerts.showFlushBar(
            context, "Gửi bình luận thành công", AlertType.success);
      });
    }
  }

  Widget _commentFrame(
      List<Comments> comments, String userStateId, ColorScheme colors) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: _listViewComment(comments, userStateId),
            ),
            _rowCommentSection(userStateId, colors)
          ],
        ),
      ),
    );
  }

  Widget _rowCommentSection(String userStateId, ColorScheme colors) {
    final isLoading = ref.watch(isLoadingPageProvider);
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/images/ava2.jpg'),
        ),
        const Gap(5),
        Expanded(
          child: CommonTextFormField(
            controller: commentController,
            labelText: "Bình luận",
            icon: const Icon(Icons.comment),
            validator: (String? value) {
              String comment = value!.trim();
              if (comment.isEmpty) {
                return "Bình luận trống";
              }
              return null;
            },
          ),
        ),
        const Gap(5),
        IconButton(
            onPressed: () => sendComment(userStateId),
            icon: isLoading
                ? CircularProgressIndicator(
                    color: colors.primary,
                  )
                : const Icon(Icons.arrow_circle_right_outlined, size: 35),
            color: colors.primary),
      ],
    );
  }

  Widget _listViewComment(List<Comments> comments, String userStateId) {
    return comments.isEmpty
        ? const Center(
            child: DisplayText(
              text: "Chưa có bình luận nào",
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          )
        : ListView.separated(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];

              return ListTile(
                leading: const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/ava2.jpg'),
                ),
                title: GenericFutureBuilder<Users?>(
                  future: UserDatasource().getUser(comment.userId), 
                  onSuccess: (data) {
                    return DisplayTitle(
                      text: data?.userName ?? "Người dùng không xác định",
                      color: AppColors.textPrimary,
                    );
                  }
                ),
                subtitle: DisplayText(
                  text: comment.text,
                  color: Colors.black,
                ),
                trailing: comment.userId == userStateId
                    ? _buildPopUpMenuButton(context)
                    : const SizedBox.shrink(),
              );
            },
            separatorBuilder: (context, index) {
              return const Gap(15);
            },
          );
  }

  PopupMenuButton<String> _buildPopUpMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      // onSelected: (value) {
      //   if (value == 'delete') {
      //     showDialogDeleteSet(context, flashcardSet);
      //   } else if (value == 'edit') {
      //     showDialogUpdateSet(context, flashcardSet);
      //   } else {
      //     return;
      //   }
      // },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: DisplayText(text: "Sửa", color: Colors.black),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: DisplayText(text: "Xóa", color: Colors.black),
        ),
        const PopupMenuItem(
          value: 'share',
          child: DisplayText(text: "Chia sẻ", color: Colors.black),
        ),
      ],
    );
  }
}
