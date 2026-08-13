import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'search_screen.dart';
import 'reels_screen.dart';
import 'profile_screen.dart';
import 'create_post_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _openCreateMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30),
            ),
            boxShadow: const [
              BoxShadow(
                blurRadius: 24,
                offset: Offset(0, -8),
                color: Color(0x22000000),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 46,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'إنشاء جديد',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'اختر ما تريد مشاركته مع الآخرين',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _createOption(
                    context,
                    icon: Icons.photo_camera_outlined,
                    color: const Color(0xFF7C4DFF),
                    title: 'منشور',
                    subtitle: 'شارك صورة أو محتوى جديد',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreatePostScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _createOption(
                    context,
                    icon: Icons.play_arrow_rounded,
                    color: const Color(0xFFFF4081),
                    title: 'Reel',
                    subtitle: 'شارك فيديو قصير ومميز',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _currentIndex = 3;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _createOption(
                    context,
                    icon: Icons.auto_awesome,
                    color: const Color(0xFF536DFE),
                    title: 'Story',
                    subtitle: 'أضف قصة جديدة ليشاهدها أصدقاؤك',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _createOption(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: color,
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const SearchScreen(),
      const SizedBox.shrink(),
      const ReelsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        height: 74,
        elevation: 8,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        indicatorColor: const Color(0xFF7C4DFF).withValues(alpha: 0.14),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          if (index == 2) {
            _openCreateMenu();
            return;
          }

          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search_rounded),
            label: 'استكشاف',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.add_circle_outline_rounded,
              size: 30,
              color: Color(0xFF7C4DFF),
            ),
            selectedIcon: Icon(
              Icons.add_circle_rounded,
              size: 32,
              color: Color(0xFFFF4081),
            ),
            label: 'إنشاء',
          ),
          NavigationDestination(
            icon: Icon(Icons.play_circle_outline_rounded),
            selectedIcon: Icon(Icons.play_circle_fill_rounded),
            label: 'Reels',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}
