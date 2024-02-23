import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar(
      {super.key,
      required this.currentIndex,
      required this.itemValues,
      required this.onTabTapped});

  final int currentIndex;
  final List<Map<String, dynamic>> itemValues;
  final void Function(int) onTabTapped;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTabTapped,
      items: widget.itemValues.map((item) {
        return BottomNavigationBarItem(
            icon: item['icon'] as Icon, label: item['label'] as String);
      }).toList(),
    );
  }
}
