import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CommentScreen extends StatelessWidget {
  final String? setId;
  const CommentScreen({super.key, required this.setId});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommonAppBar(title: "Bình luận"),
      
    );
  }
}
