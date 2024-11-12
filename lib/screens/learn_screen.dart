
import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

enum StudyType { normal, write, speed, abcd, test }

class LearnScreen extends ConsumerStatefulWidget {
  const LearnScreen({super.key});

  @override
  ConsumerState<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends ConsumerState<LearnScreen> {
  DefaultSets? selectedDefaultSet;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Hãy chọn chế độ ộp tâp", isCenterTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(
              height: 550,
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [
                  _buildStudyModeCard(
                    context,
                    title: "Thông thường",
                    description: "Lật thẻ để ôn tập",
                    pathImage: 'assets/images/regular_study_mode.png',
                    onTap: () {
                      showDialogSelectLearnSet(context, ref, StudyType.normal);
                    },
                  ),
                  _buildStudyModeCard(
                    context,
                    title: "Ghi nhớ nhanh",
                    description: "Tốc độ & phản xạ",
                    pathImage: 'assets/images/combination_study_mode.png',
                    onTap: () {
                      showDialogSelectLearnSet(context, ref, StudyType.speed);
                    },
                  ),
                  _buildStudyModeCard(
                    context,
                    title: "Viết",
                    description: "Tự tay nhập kết quả",
                    pathImage: 'assets/images/write_study_mode.png',
                    onTap: () {
                      showDialogSelectLearnSet(context, ref, StudyType.write);
                    },
                  ),
                  _buildStudyModeCard(
                    context,
                    title: "ABCD",
                    description: "Chọn đáp án đúng",
                    pathImage: 'assets/images/multiple_choice_study_mode.png',
                    onTap: () {
                      showDialogSelectLearnSet(context, ref, StudyType.abcd);
                    },
                  ),
                  _buildStudyModeCard(
                    context,
                    title: "Kiểm tra",
                    description: "Bài kiểm tra ngẫu nhiên",
                    pathImage: 'assets/images/combination_study_mode.png',
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
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
                              title: Row(
                                children: [
                                  const DisplayText(
                                    text: "Bài kiểm tra ngẫu nhiên",
                                    color: Colors.black,
                                  ),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      icon: const Icon(Icons.close))
                                ],
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 15),
                              content: const Column(
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
                                    text:
                                        "- Học sinh có 20 phút để hoàn thành 30 câu đó",
                                    color: Colors.black,
                                  ),
                                  Gap(10),
                                  DisplayText(
                                    text:
                                        "- Trong lúc làm bài, học sinh không được thoát khỏi phiên làm bài hoặc khỏi ứng dụng",
                                    color: Colors.black,
                                  ),
                                ],
                              ));
                        },
                      );
                    },
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

  Future<void> showDialogSelectLearnSet(
      BuildContext context, WidgetRef ref, StudyType studyType) async {
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
                      _startStudySession(
                          selectedSet.setId, ref, context, studyType, selectedSet.title);
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

  Widget _contentDialog(BuildContext context, WidgetRef ref,
      FlashcardSetsState flashcardSetsState) {
    final flashcardSetsStream = ref.watch(flashcardSetsStreamProvider);
    final selectedSet = flashcardSetsState.selectedFlashcardSet;
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
                  tabs: [
                    Tab(text: 'Của bạn'),
                    Tab(text: 'Lớp 11'),
                  ],
                ),
                // TabBarView
                Expanded(
                  child: TabBarView(
                    children: [
                      _listviewSets(
                          flashcardSetsStream, selectedSet, ref, colors),
                      FutureBuilder<List<DefaultSets>>(
                        future: DefaultSetsDatasource().fetchDefaultSets(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: DisplayText(
                              text: "Lỗi khi tải các bộ thẻ mặc định",
                              color: Colors.black,
                            ));
                          } else {
                            final List<DefaultSets> flashcardSets =
                                snapshot.data!;
                            return _listViewDefaultSets(
                                flashcardSets, colors, ref);
                          }
                        },
                      ),
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
        return Consumer(
          builder: (context, ref, child) {
            final isSelected =
                flashcardSet == ref.watch(selectedDefaultSetProvider);
            return InkWell(
              onTap: () {
                ref.read(selectedDefaultSetProvider.notifier).state =
                    flashcardSet;
              },
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: isSelected ? colors.primaryContainer : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      width: 1, color: const Color.fromRGBO(158, 158, 158, 1)),
                ),
                child: child,
              ),
            );
          },
          child: FutureBuilder(
            future: DefaultSetsDatasource().getCardNumber(flashcardSet.setId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Error');
              } else {
                final count = snapshot.data ?? 0;
                return ListTile(
                  title: DisplayText(
                    text: "${flashcardSet.title} - $count thẻ",
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }
            },
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Gap(10);
      },
    );
  }

  Widget _listviewSets(AsyncValue<List<FlashcardSets>> flashcardSetsStream,
      FlashcardSets? selectedSet, WidgetRef ref, ColorScheme colors) {
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
                  final isSelected = selectedSet?.setId == flashcardSet.setId;
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
                                  text: "${flashcardSet.title} - $count thẻ",
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

  void _startStudySession(String setId, WidgetRef ref, BuildContext context,
      StudyType studyType, String setName) async {
    final cardNumberStream =
        ref.read(flashcardSetsProvider.notifier).getCardNumber(setId);
    final cardNumber = await cardNumberStream.first;

    if (cardNumber! < 1) {
      AppAlerts.showFlushBar(
          context, "Bộ thẻ chưa có thẻ nào", AlertType.error);
    } else {
      _startStudyMode(studyType, context, setId, setName);
    }
  }

  void _startStudyMode(
      StudyType studyType, BuildContext context, String setId, String setName) {
    if (studyType == StudyType.normal) {
      context.push('/flipModeStudy/$setId/$setName');
    } else if (studyType == StudyType.write) {
      context.push('/writeModeStudy/$setId/$setName');
    } else if (studyType == StudyType.abcd) {
      context.push('/abcdModeStudy/$setId/$setName');
    } else {
      context.push('/speedRecallModeStudy/$setId/$setName');
    }
  }
}
