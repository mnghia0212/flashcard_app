import 'package:flashcard_app/config/config.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/screens/bottom_tab_screens/bottom_tab_screens.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavigator extends ConsumerWidget {
  const BottomNavigator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);
    final colorScheme = context.colorScheme;
    final bottomTabs = [
      {
        "label": "Trang chủ",
        "icon": Icon(iconNavigationItem(
            currentIndex, 0, Icons.home, Icons.home_outlined)),
      },
      {
        "label": "Thẻ",
        "icon": Icon(iconNavigationItem(currentIndex, 1,
            Icons.sticky_note_2, Icons.sticky_note_2_outlined)),
      },
      {
        "label": "Nhóm",
        "icon": Icon(iconNavigationItem(
            currentIndex, 2, Icons.group, Icons.group_outlined)),
      },
      {
        "label": "Học",
        "icon": Icon(iconNavigationItem(
            currentIndex, 3, Icons.school, Icons.school_outlined)),
      },
      {
        "label": "Cá nhân",
        "icon": Icon(iconNavigationItem(
            currentIndex, 4, Icons.person, Icons.person_outline)),
      }
    ];

    return Scaffold(
        bottomNavigationBar: SizedBox(
          height: 70,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.surface,
            elevation: 30,
            iconSize: 28,
            selectedItemColor: colorScheme.primary,
            unselectedItemColor: AppColors.unselectedTabItem,
            currentIndex: currentIndex,
            selectedLabelStyle: const TextStyle(fontSize: 13),
            unselectedLabelStyle: const TextStyle(fontSize: 13),
            onTap: (value) {
              ref.read(navigationProvider.notifier).state = value;
            },
            items: [
              for (var tab in bottomTabs) 
                BottomNavigationBarItem(
                  icon: tab["icon"] as Icon,
                  label: tab["label"] as String,
                )
            ],
          ),
        ),
        body: IndexedStack(
          index: currentIndex,
          children: const [
            HomeScreen(),
            FlashcardSetsScreen(),
            GroupScreen(),
            LearnScreen(),
            ProfileScreen()
          ],
        ));
  }

  IconData iconNavigationItem(int currentIndex, int itemIndex,
      IconData iconSelected, IconData iconUnselected) {
    if (currentIndex == itemIndex) {
      return iconSelected;
    } else {
      return iconUnselected;
    }
  }
}
