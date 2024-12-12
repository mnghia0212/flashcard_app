import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class DialogCancelStudySession extends StatelessWidget {
  const DialogCancelStudySession({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return AlertDialog(
      title: DisplayText(
        text: "Bạn đang trong phiên học. Bạn muốn quay về chứ ?",
        color: colors.primary,
        fontWeight: FontWeight.bold,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const DisplayText(
            text: "Không",
            color: Colors.black,
          ),
        ),
        TextButton(
          onPressed: () => context.go('/bottomNavigator'),
          child: const DisplayText(
            text: "Có",
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
