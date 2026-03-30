import 'package:flutter/material.dart';
import 'package:stodo/app/dashboard/pages/home_dashboard_page.dart';

import 'design_system/design_system_page.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _currentIndex = 0;

  // Lista de páginas mapeadas para os itens do BottomNavigationBar
  final List<Widget> _pages = [
    HomeDashboardPage(),
    const Center(
      child: Text(
        'Topics',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
    const Center(
      child: Text(
        'Library',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
    const DesignSystemPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType
            .fixed, // fixed para comportar 4+ itens corretamente
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Topics'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Library'),
          BottomNavigationBarItem(
            icon: Icon(Icons.design_services),
            label: 'Des. System',
          ),
        ],
      ),
    );
  }
}
