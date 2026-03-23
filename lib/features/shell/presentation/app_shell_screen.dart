import 'package:flutter/material.dart';

import '../../../shared/components/navigation/custom_bottom_nav_bar.dart';
import '../../favorites/presentation/favorites_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../sequence/presentation/screens/sequence_list_screen.dart';
import '../../settings/presentation/settings_placeholder_screen.dart';

class AppShellScreen extends StatefulWidget {
  const AppShellScreen({super.key});

  @override
  State<AppShellScreen> createState() => _AppShellScreenState();
}

class _AppShellScreenState extends State<AppShellScreen> {
  int _currentIndex = 0;

  static const _tabs = <Widget>[
    HomeScreen(),
    SequenceListScreen(),
    FavoritesScreen(),
    SettingsPlaceholderScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
