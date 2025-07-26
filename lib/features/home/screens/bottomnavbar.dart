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
      selectedItemColor: Colors.white, // <-- Make sure this is white
      unselectedItemColor: AppColors.unselectedIconColor,
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: _buildNavItem(AppAssets.NavIcn1, 0, selectedIndex == 0),
          label: "Quran",
        ),
        BottomNavigationBarItem(
          icon: _buildNavItem(AppAssets.NavIcn2, 1, selectedIndex == 1),
          label: "Hadith",
        ),
        BottomNavigationBarItem(
          icon: _buildNavItem(AppAssets.NavIcn3, 3, selectedIndex == 2),
          label: "More",
        ),
        BottomNavigationBarItem(
          icon: _buildNavItem(AppAssets.NavIcn4, 2, selectedIndex == 3),
          label: "Radio",
        ),
        BottomNavigationBarItem(
          icon: _buildNavItem(AppAssets.NavIcn5, 4, selectedIndex == 4),
          label: "Time",
        ),
      ],
    );
  }

  Widget _buildNavItem(String asset, int index, bool isSelected) {
    return Image.asset(
      asset,
      width: 24,
      height: 24,
      color: isSelected ? Colors.white : AppColors.unselectedIconColor,
    );
  }
}
