import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';



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
      appBar: const CommonAppBar(
        title: "Hãy chọn chế độ ộp tâp",
        isCenterTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(
              height: 550,
              child: _buildGridViewStudyMode(context),
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

  GridView _buildGridViewStudyMode(BuildContext context) {
    return GridView.count(
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
          onTap: () {
            _showDialogConfirmDoTest(context);
          },
        ),
      ],
    );
  }

  Future<dynamic> _showDialogConfirmDoTest(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return const DialogConfirmDoTest();
      },
    );
  }

  Future<void> showDialogSelectLearnSet (
      BuildContext context, WidgetRef ref, StudyType studyType) async {
    await showDialog(
      context: context,
      builder: (context) {
        return DialogSelectLearnSet(studyType: studyType);
      },
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
}
