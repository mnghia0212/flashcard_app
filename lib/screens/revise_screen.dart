import 'package:flashcard_app/widgets/display_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ReviseScreen extends StatelessWidget {
  const ReviseScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: [
            _buildStudyModeCard(
              context,
              title: "Thông thường",
              description: "Lật thẻ để ôn tập",
              pathImage: 'lib/assets/images/regular_study_mode.png'
            ),
            _buildStudyModeCard(
              context,
              title: "Kết hợp",
              description: "Kết hợp các bộ thẻ",
              pathImage: 'lib/assets/images/combination_study_mode.png'
            ),
            _buildStudyModeCard(
              context,
              title: "Viết",
              description: "Tự tay nhập kết quả",          
              pathImage: 'lib/assets/images/write_study_mode.png'
            ),
            _buildStudyModeCard(
              context,
              title: "ABCD",
              description: "Chọn đáp án đúng",
              pathImage: 'lib/assets/images/multiple_choice_study_mode.png'
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildStudyModeCard(
    BuildContext context, {
    required String title,
    required String description,
    required String pathImage,
  }) {
    return GestureDetector(
      onTap: () {
        
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xfff1f1f1),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(15),
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Image.asset(pathImage)),
              const Gap(10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(5),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
