import 'package:flutter/material.dart';
import 'package:islami/core/consts/app_assets.dart';
import 'package:islami/core/theme/app_Colors.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  const BottomNavBar(
      {super.key, this.selectedIndex = 0, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.pri,
      elevation: 10,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.selectedIconColor,
      unselectedItemColor: AppColors.unselectedIconColor,
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: _buildNavItem(AppAssets.NavIcn1, 0),
          label: "Quran",
        ),
        BottomNavigationBarItem(
          icon: _buildNavItem(AppAssets.NavIcn2, 1),
          label: "Hadith",
        ),
        BottomNavigationBarItem(
          icon: _buildNavItem(AppAssets.NavIcn3, 2),
          label: "Radio",
        ),
        BottomNavigationBarItem(
          icon: _buildNavItem(AppAssets.NavIcn4, 3),
          label: "More",
        ),
        BottomNavigationBarItem(
          icon: _buildNavItem(AppAssets.NavIcn5, 4),
          label: "Time",
        ),
      ],
    );
  }

  Widget _buildNavItem(String asset, int index) {
    // Replace with your actual icon/image widget
    return Image.asset(asset, width: 24, height: 24);
  }
}
