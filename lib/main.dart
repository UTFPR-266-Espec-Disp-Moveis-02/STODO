import 'package:flutter/material.dart';
import 'app/design_system/design_system_page.dart';
import 'core/themes/theme_exports.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STodo Design System',
      theme: AppDarkTheme.darkTheme,
      darkTheme: AppDarkTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const DesignSystemPage(),
    );
  }
}
