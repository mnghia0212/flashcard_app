import 'package:flashcard_app/utils/extensions.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TermsPolicy extends StatelessWidget {
  const TermsPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = context.deviceSize;
    return Container(
      width: deviceSize.width,
      height: deviceSize.height * 0.5,
      decoration: const BoxDecoration(
        color: Colors.white
      ),
      child: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DisplayHeading(text: "Chính sách và Điều khoản"),
                DisplayText(
                  text: "Đây là chính sách và điều khoản",
                  textAlign: TextAlign.justify,
                  color: Colors.black,
                )
              ],
            ),
          ),

          Positioned(
            top: 7,
            right: 7,
            child: IconButton(
              onPressed:() => context.pop(), 
              icon: const Icon(Icons.close)
            ),
          )
        ],
      ),
    );
  }
}
