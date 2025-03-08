import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class FutureBuilderGetUser extends StatelessWidget {
  final String userId;
  const FutureBuilderGetUser({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<Users?>(
      future: UserDatasource().getUser(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: DisplayText(
              text: "Lỗi khi tải tên người dùng",
              color: Colors.black,
            ),
          );
        } else if (!snapshot.hasData) {
          return const Center(
              child: DisplayText(
            text: "Lỗi khi tải tên người dùng",
            color: Colors.black,
          ));
        } else {
          final String userName = snapshot.data!.userName;

          return DisplayText(
            text: userName,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          );
        }
      },
    );
  }
}
