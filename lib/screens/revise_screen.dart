
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ReviseScreen extends ConsumerWidget {
  const ReviseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hãy chọn chế độ học ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(
              height: 500,
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [
                  _buildStudyModeCard(
                    context,
                    title: "Thông thường",
                    description: "Lật thẻ để ôn tập",
                    pathImage: 'lib/assets/images/regular_study_mode.png',
                    onTap: () {},
                  ),
                  _buildStudyModeCard(
                    context,
                    title: "Kết hợp",
                    description: "Kết hợp các bộ thẻ",
                    pathImage: 'lib/assets/images/combination_study_mode.png',
                    onTap: () {},
                  ),
                  _buildStudyModeCard(
                    context,
                    title: "Viết",
                    description: "Tự tay nhập kết quả",
                    pathImage: 'lib/assets/images/write_study_mode.png',
                    onTap: () {
                      showDialogWriteMode(context, ref);
                    },
                  ),
                  _buildStudyModeCard(
                    context,
                    title: "ABCD",
                    description: "Chọn đáp án đúng",
                    pathImage:
                        'lib/assets/images/multiple_choice_study_mode.png',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const Spacer(),
            const DisplayText(
              text: "Chúc bạn học tập thật tốt !",
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }

  Future<void> showDialogWriteMode(BuildContext context, WidgetRef ref) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final flashcardSetsState = ref.watch(flashcardSetsProvider);
            final selectedSet =
                ref.watch(flashcardSetsProvider).selectedFlashcardSet;

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
                  onPressed: () {
                    if (selectedSet != null) {
                      //log(selectedSet.setId);
                      learnWriteMode(selectedSet.setId, ref, context);
                    } else {
                      AppAlerts.showFlushBar(context,
                          "Bạn hãy chọn 1 thẻ để bắt đầu", AlertType.error);
                    }
                  },
                ),
              ],
              title: _rowTitleDialog(context),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              content: _contentDialog(context, ref, flashcardSetsState),
            );
          },
        );
      },
    );
  }

  SizedBox _contentDialog(BuildContext context, WidgetRef ref,
      FlashcardSetsState flashcardSetsState) {
    final flashcardSetsStream = ref.watch(flashcardSetsStreamProvider);
    final flashcardSets = flashcardSetsState.flashcardSets;
    final selectedSet = flashcardSetsState.selectedFlashcardSet;
    final colors = context.colorScheme;

    return SizedBox(
      width: 400,
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DisplayText(
            text: "Hãy chọn bộ thẻ: ",
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          const Gap(10),
          Expanded(
            child: flashcardSetsStream.when(
              data: (flashcardSets) {
                return flashcardSets.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        itemCount: flashcardSets.length,
                        itemBuilder: (context, index) {
                          final flashcardSet = flashcardSets[index];
                          final isSelected =
                              selectedSet?.setId == flashcardSet.setId;
                          final cardNumber = ref
                              .read(flashcardSetsProvider.notifier)
                              .getCardNumber(flashcardSet.setId);

                          return InkWell(
                            onTap: () {
                              ref
                                  .read(flashcardSetsProvider.notifier)
                                  .selectFlashcardSet(flashcardSet);
                            },
                            child: Container(
                              height: 70,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? colors.primaryContainer
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 1,
                                    color:
                                        const Color.fromRGBO(158, 158, 158, 1)),
                              ),
                              child: StreamBuilder(
                                  stream: cardNumber,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return const Text('Error');
                                    } else {
                                      final count = snapshot.data ?? 0;
                                      return ListTile(
                                        title: DisplayText(
                                          text:
                                              "${flashcardSet.title} - $count thẻ",
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        subtitle: DisplayText(
                                          text: flashcardSet.description,
                                          color: Colors.black,
                                        ),
                                      );
                                    }
                                  }),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Gap(10);
                        },
                      );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  Center(child: Text('Error: $error')),
            ),
          )
        ],
      ),
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

  Row _rowTitleDialog(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            DisplayTitle(
                text: "Chế độ viết",
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ],
        ),
        IconButton(
            onPressed: () => context.pop(), icon: const Icon(Icons.close))
      ],
    );
  }

  Widget _buildStudyModeCard(
    BuildContext context, {
    required String title,
    required String description,
    required String pathImage,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xfff1f1f1),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Image.asset(pathImage)),
            const Gap(10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(5),
            Text(
              description,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void learnWriteMode(String setId, WidgetRef ref, BuildContext context) async {
    final cardNumberStream =
        ref.read(flashcardSetsProvider.notifier).getCardNumber(setId);
    final cardNumber = await cardNumberStream.first;

    if (cardNumber! < 1) {
      AppAlerts.showFlushBar(
          context, "Bộ thẻ chưa có thẻ nào", AlertType.error);
    } else {
      context.push('/writeModeStudy/$setId');
    }
  }
}
