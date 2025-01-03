import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FlashcardSetsScreen extends StatelessWidget {
  const FlashcardSetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String selectedItem = 'Sắp xếp';
    final List<String> dropdownItems = [
      'Sắp xếp',
      'Yêu thích',
      'Số lượng thẻ',
      'Gần đây',
      'A-Z'
    ];
    return Scaffold(
        floatingActionButton: const FloatingActionButtonCreate(dialogCreate: DialogCreateSet()),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                rowTextFieldMenuDropDown(dropdownItems, selectedItem),
                const Gap(15),
                const Expanded(child: DisplayListOfFlashcardSets()),
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
            height: 70,
            child: CommonTextFormField(
              labelText: "Tìm kiếm",
              icon: Icon(Icons.search_outlined),
              filledColor: Colors.white,
            ),
          ),
        ),
        const Gap(15),
        ShadowBoxContainer(
          height: 70,
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
}
