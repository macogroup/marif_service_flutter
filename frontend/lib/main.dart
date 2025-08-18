import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'features/shell/app_shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Мариф',
      theme: buildAppTheme(),
      home: const AppShell(),
    );
  }
}
