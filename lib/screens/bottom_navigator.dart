import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/screens/screens.dart';
import 'package:flashcard_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavigator extends ConsumerWidget {
  const BottomNavigator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);
    final colorScheme = context.colorScheme;
    return Scaffold(
        bottomNavigationBar: SizedBox(
          height: 70,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 30,
            iconSize: 28,
            selectedItemColor: colorScheme.primary,
            unselectedItemColor: Colors.black87,
            currentIndex: currentIndex,
            onTap: (value) {
              ref.read(navigationProvider.notifier).state = value;
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(iconNavigationItem(
                  currentIndex, 
                  0, 
                  Icons.home,
                  Icons.home_outlined
                )), 
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(iconNavigationItem(
                  currentIndex, 
                  1, 
                  Icons.sticky_note_2,
                  Icons.sticky_note_2_outlined
                )), 
                label: "Card",
              ),
              BottomNavigationBarItem(
                icon: Icon(iconNavigationItem(
                  currentIndex, 
                  2, 
                  Icons.group,
                  Icons.group_outlined
                )), 
                label: "Group",
              ),
              BottomNavigationBarItem(
                icon: Icon(iconNavigationItem(
                  currentIndex, 
                  3, 
                  Icons.school,
                  Icons.school_outlined
                )), 
                label: "Learn",
              ),
              BottomNavigationBarItem(
                icon: Icon(iconNavigationItem(
                  currentIndex, 
                  4, 
                  Icons.person,
                  Icons.person_outline
                )),
                label: "Profile",
              ),
            ],
          ),
        ),
        body: IndexedStack(
          index: currentIndex,
          children: const [
            HomeScreen(),
            FlashcardSetsScreen(),
            GroupScreen(),
            ReviseScreen(),
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
