import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:janel_abiya/domain/models/ProductModel.dart';

import '../widgets/ProductCard.dart';
import 'home/CategoryScreen.dart';
import 'home/OrderScreen.dart';





class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    CategoryScreen(), // Replace with your catalog body widget
    OrdersScreen(), // Replace with your orders screen widget
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('JANEL ABIYE'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag),
            onPressed: () => setState(() => _currentIndex = 1),
          )
        ],
      ),
      //drawer: isWeb ? null : const AppDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Janel Abiye',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Orders',
          ),
        ],
      ),
    );
  }
}