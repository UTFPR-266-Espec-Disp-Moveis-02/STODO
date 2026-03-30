import 'package:flutter/material.dart';
import 'package:stodo/core/db/app_database.dart';

import 'app/base_page.dart';
import 'core/themes/theme_exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppDatabase.instance;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STodo',
      theme: AppDarkTheme.darkTheme,
      darkTheme: AppDarkTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const BasePage(),
    );
  }
}
