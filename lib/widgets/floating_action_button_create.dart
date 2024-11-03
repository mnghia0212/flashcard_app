import 'package:flashcard_app/utils/extensions.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FloatingActionButtonCreate extends ConsumerWidget {
  final Widget dialogCreate;
  const FloatingActionButtonCreate({super.key, required this.dialogCreate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colorScheme;
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: colors.primary, borderRadius: BorderRadius.circular(50)),
      child: IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return dialogCreate;
                });
          },
          icon: const Icon(
            Icons.add,
            color: Colors.white,
            size: 35,
          )),
    );
  }
}
