import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

enum StudyType { normal, write, speed, abcd, test }

class DialogSelectLearnSet extends ConsumerWidget {
  final StudyType studyType;
  const DialogSelectLearnSet({super.key, required this.studyType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSet = ref.watch(selectedSetProvider);
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
              _startStudySession(selectedSet, ref, context, studyType);
            } else {
              AppAlerts.showFlushBar(
                  context, "Bạn hãy chọn 1 thẻ để bắt đầu", AlertType.error);
            }
            //log("selected set: ${selectedSet!.set.toString()}");
          },
        ),
      ],
      title: _rowTitleDialog(context),
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      content: _contentDialog(context, ref, selectedSet),
    );
  }

  Widget _contentDialog(
      BuildContext context, WidgetRef ref, SelectedSetWrapper? selectedSet) {
    final colors = context.colorScheme;
    final size = context.deviceSize;

    return SizedBox(
        width: size.width,
        height: size.height,
        child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                // TabBar
                const TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  tabs: [
                    Tab(text: 'Của bạn'),
                    Tab(text: 'Lớp 11'),
                  ],
                ),
                // TabBarView
                Expanded(
                  child: TabBarView(
                    children: [
                      _listviewSets(ref, colors),
                      _futureFetchDefaultSets(colors, ref),
                    ],
                  ),
                ),
              ],
            )));
  }

  Widget _listViewDefaultSets(
      List<DefaultSets> flashcardSets, ColorScheme colors, WidgetRef ref) {
    return ListView.separated(
      itemCount: flashcardSets.length,
      itemBuilder: (context, index) {
        final flashcardSet = flashcardSets[index];
        final selectedSet = ref.watch(selectedSetProvider);
        final bool isSelected = selectedSet?.set == flashcardSet;

        return InkWell(
          onTap: () {
            ref.read(selectedSetProvider.notifier).state =
                SelectedSetWrapper(set: flashcardSet, isDefault: true);
          },
          child: Consumer(
            builder: (context, ref, child) {
              return Container(
                height: 80,
                decoration: BoxDecoration(
                  color: isSelected ? colors.primaryContainer : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      width: 1, color: const Color.fromRGBO(158, 158, 158, 1)),
                ),
                child: FutureBuilder(
                  future:
                      DefaultSetsDatasource().getCardNumber(flashcardSet.setId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Error');
                    } else {
                      final count = snapshot.data ?? 0;
                      return ListTile(
                        title: DisplayText(
                          text: flashcardSet.title,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        subtitle: DisplayText(
                          text: "$count thẻ",
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      );
                    }
                  },
                ),
              );
            },
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Gap(10);
      },
    );
  }

  Widget _listviewSets(WidgetRef ref, ColorScheme colors) {
    final flashcardSetsStream = ref.watch(flashcardSetsStreamProvider);
    return flashcardSetsStream.when(
      data: (flashcardSets) {
        return flashcardSets.isEmpty
            ? const Center(
                child: DisplayText(
                text: "Chưa có bộ thẻ nào",
                color: Colors.black,
              ))
            : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 10),
                physics: const BouncingScrollPhysics(),
                itemCount: flashcardSets.length,
                itemBuilder: (context, index) {
                  final flashcardSet = flashcardSets[index];
                  final selectedSet = ref.watch(selectedSetProvider);
                  final isSelected = selectedSet?.set == flashcardSet;
                  final cardNumber = ref
                      .read(flashcardSetsProvider.notifier)
                      .getCardNumber(flashcardSet.setId);

                  return InkWell(
                    onTap: () {
                      ref.read(selectedSetProvider.notifier).state =
                          SelectedSetWrapper(
                              set: flashcardSet, isDefault: false);
                    },
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color:
                            isSelected ? colors.primaryContainer : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 1,
                            color: const Color.fromRGBO(158, 158, 158, 1)),
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
                                  text: flashcardSet.title,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                subtitle: DisplayText(
                                  text: "$count thẻ",
                                  color: Colors.black,
                                  fontSize: 13,
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
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
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
            DisplayText(
                text: "Chọn bộ thẻ để bắt đầu",
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ],
        ),
        IconButton(
            onPressed: () => context.pop(), icon: const Icon(Icons.close))
      ],
    );
  }

  FutureBuilder<List<DefaultSets>> _futureFetchDefaultSets(
      ColorScheme colors, WidgetRef ref) {
    return FutureBuilder<List<DefaultSets>>(
      future: DefaultSetsDatasource().fetchDefaultSets(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: DisplayText(
              text: "Lỗi khi tải các bộ thẻ mặc định",
              color: Colors.black,
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: DisplayText(
            text: "Lỗi khi tải các bộ thẻ mặc định",
            color: Colors.black,
          ));
        } else {
          final List<DefaultSets> flashcardSets = snapshot.data!;
          return _listViewDefaultSets(flashcardSets, colors, ref);
        }
      },
    );
  }

  void _startStudySession(SelectedSetWrapper selectedSetWrapper, WidgetRef ref,
      BuildContext context, StudyType studyType) async {
    final set = selectedSetWrapper.set;

    if (selectedSetWrapper.isDefault) {
      final defaultSet = set as DefaultSets;
      _startStudyMode(studyType, context, defaultSet, true);
    } else {
      final flashcardSet = set as FlashcardSets;

      final cardNumberStream = ref
          .read(flashcardSetsProvider.notifier)
          .getCardNumber(flashcardSet.setId);

      final cardNumber = await cardNumberStream.first;

      if (!context.mounted) {
        return;
      }

      if (cardNumber! < 1) {
        AppAlerts.showFlushBar(context, "Bộ thẻ trống", AlertType.error);
      } else {
        _startStudyMode(studyType, context, flashcardSet, false);
      }
    }
  }

  void _startStudyMode(
      StudyType studyType, BuildContext context, dynamic set, bool isDefault) {
    if (studyType == StudyType.normal) {
      context.push('/flipModeStudy', extra: set);
    } else if (studyType == StudyType.write) {
      context.push('/writeModeStudy', extra: set);
    }
    else if (studyType == StudyType.abcd) {
      context.push('/abcdModeStudy', extra: set);
    } else {
      context.push('/speedRecallModeStudy', extra: set);
    }
  }
}
