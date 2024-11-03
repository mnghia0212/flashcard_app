import 'package:flashcard_app/utils/extensions.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    String selectedItem = 'Sắp xếp';
    final List<String> dropdownItems = [
      'Sắp xếp',
      'Yêu thích',
      'Số lượng thẻ',
      'Gần đây',
      'A-Z'
    ];

    return Scaffold(
        appBar: _buildAppBar(colors, context),
        floatingActionButton:
            const FloatingActionButtonCreate(dialogCreate: DialogCreateGroup()),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Column(
              children: [
                const Gap(10),
                rowTextFieldMenuDropDown(dropdownItems, selectedItem),
                const Gap(15),
                const DisplayListOfGroups(),
              ],
            ),
          ),
        ));
  }

  Row rowTextFieldMenuDropDown(
      List<String> dropdownItems, String selectedItem) {
    return Row(
      children: [
        const Expanded(
          child: ShadowBoxContainer(
            child: CommonTextFormField(
              labelText: "Tìm kiếm",
              icon: Icon(Icons.search_outlined),
              filledColor: Colors.white,
            ),
          ),
        ),
        const Gap(15),
        ShadowBoxContainer(
          padding: 3,
          child: DropdownButton(
            underline: const SizedBox.shrink(),
            items: dropdownItems.map((String item) {
              return DropdownMenuItem(value: item, child: Text(item));
            }).toList(),
            value: selectedItem,
            onChanged: (value) {
              selectedItem = value!;
            },
            icon: const Icon(Icons.arrow_drop_down),
          ),
        )
      ],
    );
  }

  AppBar _buildAppBar(ColorScheme colors, BuildContext context) {
    return AppBar(
        title: const DisplayTitle(text: "Nhóm học", color: Colors.black),
        centerTitle: true,
        elevation: 0.5,
        actions: <Widget>[
          TextButton(
              onPressed: () {
                showDialog(
                context: context,
                builder: (context) {
                  return const DialogJoinGroup();
                });
              },
              child: DisplayText(text: "Tham gia", color: colors.primary
              )
          ),
        ]
    );
  }
}
