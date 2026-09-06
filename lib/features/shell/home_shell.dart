import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import '../inventory/inventory_screen.dart';

/// The two rooms of the notebook: the cartridges (with everything
/// under them) and the component shelf. Phase E adds Trends.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [HomeScreen(), InventoryScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.menu_book_outlined), label: 'Notebook'),
          NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined), label: 'Inventory'),
        ],
      ),
    );
  }
}
