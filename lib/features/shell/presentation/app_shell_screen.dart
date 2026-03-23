import 'package:flutter/material.dart';

import '../../../shared/components/navigation/custom_bottom_nav_bar.dart';
import '../../favorites/presentation/favorites_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../sequence/presentation/screens/sequence_list_screen.dart';
import '../../settings/presentation/settings_screen.dart';

class AppShellScreen extends StatefulWidget {
  const AppShellScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<AppShellScreen> createState() => _AppShellScreenState();
}

class _AppShellScreenState extends State<AppShellScreen> {
  late int _currentIndex;

  static const _tabs = <Widget>[
    HomeScreen(),
    SequenceListScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, _tabs.length - 1);
  }

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
