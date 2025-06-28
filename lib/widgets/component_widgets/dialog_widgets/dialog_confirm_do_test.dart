import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/data/datasource/tests/tests.dart';
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

  Widget _buildContentDialog() {
    return Column(
      children: [
        SizedBox(
          height: 400,
          child: FutureBuilder<List<TestCards>>(
            future: TestCardDatasource().getCardsToTest(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: DisplayText(
                    text: "Lỗi khi tải bộ thẻ",
                    color: Colors.black,
                  ),
                );
              } else if (!snapshot.hasData) {
                return const Center(
                    child: DisplayText(
                  text: "Chưa có thẻ nào cần kiểm tra",
                  color: Colors.black,
                ));
              } else {
                final testCards = snapshot.data;
                return ListView.separated(
                  itemCount: testCards!.length,
                  itemBuilder: (context, index) {
                    final testCard = testCards[index];
                    return ListTile(
                      title: DisplayText(
                        text: testCard.frontSide,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      subtitle: DisplayText(
                        text: testCard.backSide,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Gap(10);
                  },
                );
              }
            },
          ),
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
