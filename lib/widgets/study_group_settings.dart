import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class StudyGroupSettings extends StatelessWidget {
  final String groupId;
  const StudyGroupSettings({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionSeeStudyCode(colors, context),
          const Spacer(),
          _buildButtonLeaveGroup(colors)
        ],
      ),
    );
  }

  void copyGroupCodeToClipBoard(String groupId, BuildContext context) {
    final value = ClipboardData(text: groupId);
    Clipboard.setData(value).then((value) {
      if (!context.mounted) {
        return;
      }

      AppAlerts.showFlushBar(
          context, "Đã copy mã nhóm vào clipboard", AlertType.info);
    });
  }

  ElevatedButton _buildButtonLeaveGroup(ColorScheme colors) {
    return ElevatedButton.icon(
      onPressed: () {},
      label: const DisplayText(
        text: "Rời nhóm",
        fontWeight: FontWeight.bold,
      ),
      icon: const Icon(
        Icons.exit_to_app,
        color: Colors.white,
      ),
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: colors.primary),
    );
  }

  Column _buildSectionSeeStudyCode(ColorScheme colors, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const DisplayText(
          text: "Mã nhóm học",
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        const Gap(10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: colors.primary)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DisplayText(
                text: groupId,
                color: Colors.black,
              ),
              IconButton(
                onPressed: () {
                  copyGroupCodeToClipBoard(groupId, context);
                },
                icon: const Icon(Icons.copy, size: 20),
              )
            ],
          ),
        )
      ],
    );
  }
}
