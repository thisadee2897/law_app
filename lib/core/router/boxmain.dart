import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithAppbar extends ConsumerWidget {
  const ScaffoldWithAppbar({Key? key, required this.navigationShell}) : super(key: key ?? const ValueKey('ScaffoldWithAppbar'));
  final StatefulNavigationShell navigationShell;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: navigationShell,

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.document_scanner_outlined), activeIcon: const Icon(Icons.document_scanner_rounded), label: 'Documents'),
          BottomNavigationBarItem(icon: const Icon(Icons.timer_sharp), activeIcon: const Icon(Icons.timer_sharp), label: 'Reminders'),
        ],
      ),
    );
  }

  void _onTap(index) {
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }
}
