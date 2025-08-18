import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../services/models.dart';

class ChatScreen extends StatelessWidget {
  final String title;
  const ChatScreen({super.key, required this.title});

  factory ChatScreen.placeholder({required Character character}) {
    return ChatScreen(title: 'Чат с ${character.name}');
  }

  factory ChatScreen.placeholderFromSummary({required ChatSummary item}) {
    return ChatScreen(title: 'Чат с ${item.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(
        child: Text(
          'Экран чата (заглушка)\nTODO: интеграция с backend',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.secondaryText),
        ),
      ),
    );
  }
}


