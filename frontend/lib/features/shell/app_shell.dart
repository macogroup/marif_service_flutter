import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../home/home_screen.dart';
import '../chat/chat_list_screen.dart';
import '../ideal_type/ideal_type_screen.dart';
import '../recommend/recommend_screen.dart';
import '../profile/my_page_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    ChatListScreen(),
    IdealTypeScreen(),
    RecommendScreen(),
    MyPageScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _pages[_index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Дом'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Беседа'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), label: 'Найдите свой идеальный тип'),
          BottomNavigationBarItem(icon: Icon(Icons.star_border), label: 'Предложение'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Моя страница'),
        ],
        backgroundColor: AppColors.card,
      ),
    );
  }
}


