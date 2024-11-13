import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class DialogConfirmDoTest extends StatelessWidget {
  const DialogConfirmDoTest({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        actions: [
          _textButton(
            context: context,
            text: "Hủy bỏ",
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          _textButton(
            context: context,
            text: "Bắt đầu",
            onPressed: () => context.push('/testMode'),
          ),
        ],
        title: _buildTitleDialog(context),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        content: _buildContentDialog());
  }

  Column _buildContentDialog() {
    return const Column(
        children: [
          DisplayText(
            text: "Lưu ý khi làm kiểm tra",
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          Gap(10),
          DisplayText(
            text:
                "- Khi bắt đầu làm bài kiểm tra, hệ thống sẽ chọ ngẫu nhiên 30 câu từ kiến thức các bộ thẻ có sẵn",
            color: Colors.black,
          ),
          Gap(10),
          DisplayText(
            text: "- Học sinh có 20 phút để hoàn thành 30 câu đó",
            color: Colors.black,
          ),
          Gap(10),
          DisplayText(
            text:
                "- Trong lúc làm bài, học sinh không được thoát khỏi phiên làm bài hoặc khỏi ứng dụng",
            color: Colors.black,
          ),
        ],
      );
  }

  Row _buildTitleDialog(BuildContext context) {
    return Row(
        children: [
          const DisplayText(
            text: "Bài kiểm tra ngẫu nhiên",
            color: Colors.black,
          ),
          const Spacer(),
          IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close))
        ],
      );
  }

  TextButton _textButton(
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
}
