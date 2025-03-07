import 'package:flutter/material.dart';
import 'package:islami/core/consts/app_assets.dart';
import 'package:islami/core/theme/app_Colors.dart';

class HomePage extends StatefulWidget {
  static const String route = "/home";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final TextEditingController _suraController = TextEditingController(); // Controller for input

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildNavItem(String assetPath, int index) {
    bool isSelected = _selectedIndex == index;

    return Container(
      decoration: isSelected
          ? BoxDecoration(
        color: AppColors.pri, // Background matches the nav bar
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      )
          : null,
      padding: EdgeInsets.all(8), // Ensures proper alignment
      child: Image.asset(
        assetPath,
        height: 30,
        color: isSelected ? AppColors.selectedIconColor : AppColors.unselectedIconColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              AppAssets.homeBg,
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Islami Logo
                Image.asset(
                  AppAssets.Islami,
                  height: 50,
                ),

                const SizedBox(height: 20),

                // Search Field Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54, // Dark background for the input field
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white70, width: 1),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            AppAssets.NavIcn1,
                            color: AppColors.pri,
                            width: 24,
                            height: 24,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _suraController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "Sura Name",
                              hintStyle: TextStyle(color: Colors.white70),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Placeholder for Home Content
                Expanded(
                  child: Center(
                    child: Text(
                      "Welcome to the Home Page!",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.pri,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.selectedIconColor,
          unselectedItemColor: AppColors.unselectedIconColor,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: _buildNavItem(AppAssets.NavIcn1, 0),
              label: "Quran",
            ),
            BottomNavigationBarItem(
              icon: _buildNavItem(AppAssets.NavIcn2, 1),
              label: "Prayer",
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
        ),
      ),
    );
  }
}

