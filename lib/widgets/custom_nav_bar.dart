import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/enum/page_index.dart';

class CustomNavBar extends StatefulWidget {
  CustomNavBar({super.key, required this.index});
  PageIndex index;
  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  void _onPageIndexChange(int index){
    widget.index = PageIndex.values[index];
    switch(widget.index){
      case PageIndex.home: context.go('/');
      case PageIndex.month: context.go('/month_page');
      case PageIndex.categoryAdd: context.go('/add_category');
      case PageIndex.receiptPhoto: context.go('/receipt_scanner');
      case PageIndex.paymentAdd: context.go('/add_payment');
      default: context.go('/receipt_scanner');
    }
  }
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) => _onPageIndexChange(index),
      selectedItemColor: Colors.amber.shade600,
      unselectedItemColor: Colors.grey.shade600,
      currentIndex: widget.index.index,
        items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "start"),
      BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today), label: "Miesiąc"),
      BottomNavigationBarItem(
          icon: Icon(Icons.edit_calendar), label: "Dodaj Kategorie"),
      // BottomNavigationBarItem(
      //     icon: Icon(Icons.add_circle_outline), label: "Dodaj opcje"),
      BottomNavigationBarItem(
          icon: Icon(Icons.payments_outlined), label: "Dodaj płatność"),
      BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt_outlined), label: "Paragon"),
    ]);
  }
}
