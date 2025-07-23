import 'package:flutter/material.dart';
import 'package:islami/core/consts/app_assets.dart';
import 'package:islami/core/theme/app_Colors.dart';
import 'hadithscreen.dart';
import 'bottomnavbar.dart';

class HomePageScreen extends StatefulWidget {
  static const String route = "/home";
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    // Replace with your actual screens
    HomeScreen(), // Example placeholder
    const HadithScreen(),
    const Center(child: Text('Radio')),
    const Center(child: Text('More')),
    const Center(child: Text('Time')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    ));
  }
}

class HomeScreen extends StatelessWidget {
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
                      color:
                          Colors.black54, // Dark background for the input field
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
                            //controller: _suraController,
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
    );
  }
}
