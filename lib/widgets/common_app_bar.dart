import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isCenterTitle;

  const CommonAppBar({
    super.key,
    required this.title,
    this.isCenterTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: DisplayText(text: title, fontWeight: FontWeight.bold, color: Colors.black,),
      centerTitle: isCenterTitle,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
