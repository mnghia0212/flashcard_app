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
        floatingActionButton: const RowFloatingButtonCreate(),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Gap(10),
                  rowTextFieldMenuDropDown(dropdownItems, selectedItem),
                  const Gap(15),
                  const DisplayListOfFlashcardSets(),
                ],
              ),
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
}
