import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class DiscussTab extends ConsumerStatefulWidget {
  final String groupId;
  final String userId;
  final String userName;
  const DiscussTab(
      {super.key,
      required this.groupId,
      required this.userId,
      required this.userName});

  @override
  ConsumerState<DiscussTab> createState() => _DiscussTabState();
}

class _DiscussTabState extends ConsumerState<DiscussTab> {

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final flashcardSetsSharedAsync =
        ref.watch(flashcardSetsSharedStreamProvider(widget.groupId));
    final sizes = context.deviceSize;
    
    return flashcardSetsSharedAsync.when(
      data: (flashcardSetsShared) => flashcardSetsShared.isEmpty
          ? _emptySharedSets(context, colors)
          : Column(
            children: [
              Expanded(
                  child: _listviewSetsShared(colors, flashcardSetsShared, sizes)),
              _rowButtonShare(context, colors),
            ],
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Padding _emptySharedSets(BuildContext context, ColorScheme colors) {
    return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
              children: [
                const Expanded(
                    child: Center(
                        child: DisplayText(
                  text: "Nhóm chia sẻ bộ thẻ nào",
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ))),
                _rowButtonShare(context, colors)
              ],
            ),
        );
  }

  Widget _rowButtonShare(BuildContext context, ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => showDialogSelectShareSet(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 15)),
              child: const DisplayText(text: "Chia sẻ bộ thẻ", fontWeight: FontWeight.bold,),
            ),
          ),
        ],
      ),
    );
  }

  ListView _listviewSetsShared(
      ColorScheme colors, List<FlashcardSetsShared> flashcardSetsShared, Size sizes) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      itemCount: flashcardSetsShared.length,
      itemBuilder: (context, index) {
        final flashcardSetShared = flashcardSetsShared[index];

        return Row(
          children: [
            const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(
                        'assets/images/ava2.jpg'), 
                  ),
            InkWell(
              onTap: () => context.push('/flashcard/${flashcardSetShared.setId}/${flashcardSetShared.setName}'),
              child: Container(
                height: 65,
                width: 280,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    DisplayText(
                      text: "Bạn đã chia sẻ bộ thẻ ${flashcardSetShared.setName}",
                      fontSize: 15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return const Gap(20);
      },
    );
  }

  Future<void> showDialogSelectShareSet(BuildContext context) async {
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
                      _checkNumberCard(
                          selectedSet.setId, ref, context, selectedSet.title);
                    } else {
                      AppAlerts.showFlushBar(
                          context, "Bạn chưa chọn bộ thẻ nào", AlertType.error);
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
    final selectedSet = flashcardSetsState.selectedFlashcardSet;
    final colors = context.colorScheme;

    return SizedBox(
      width: 400,
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            DisplayText(
                text: "Chọn bộ thẻ để chia sẻ",
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ],
        ),
        IconButton(
            onPressed: () => context.pop(), icon: const Icon(Icons.close))
      ],
    );
  }

  void _checkNumberCard(
      String setId, WidgetRef ref, BuildContext context, String setName) async {
    final cardNumberStream =
        ref.read(flashcardSetsProvider.notifier).getCardNumber(setId);
    final cardNumber = await cardNumberStream.first;

    if (!context.mounted) {
      return;
    }

    if (cardNumber! < 1) {
      AppAlerts.showFlushBar(
          context, "Bộ thẻ chưa có thẻ nào", AlertType.error);
    } else {
      _shareCard(setId, setName, context);
    }
  }

  void _shareCard(String setId, String setName, BuildContext context) async {
    try {
      final newSharedSetDoc =
          FirebaseFirestore.instance.collection('flashcardSetsShared').doc();

      final newSharedSetId = newSharedSetDoc.id;

      final newSharedSet = FlashcardSetsShared(
          flashcardSetSharedId: newSharedSetId,
          userId: widget.userId,
          userName: widget.userName,
          setName: setName,
          setId: setId,
          groupId: widget.groupId,
          sharedAt: DateTime.now().toString());

      await ref
          .read(flashcardSetsSharedProvider.notifier)
          .shareSet(newSharedSet)
          .then((value) {
        if (!context.mounted) {
          return;
        }

        context.pop();
        AppAlerts.showFlushBar(context,
            "Đã chia sẻ bộ thẻ ${newSharedSet.setName}", AlertType.success);
      });

      AppAlerts.showFlushBar(context, "Đã chia sẻ bộ thẻ", AlertType.success);
      log("$newSharedSet");
    } catch (e) {
      log("error share set: $e");
    }
  }
}
