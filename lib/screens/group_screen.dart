import 'package:flashcard_app/utils/extensions.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Scaffold(
      floatingActionButton: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: colors.primary, borderRadius: BorderRadius.circular(50)),
        child: IconButton(
            onPressed: () {
              
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 35,
            )),
      ),
      body: const Center(
        child: EmptyContainer(emptyType: EmptyType.group),
      ),
    );
  }
}
