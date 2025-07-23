import 'package:flutter/material.dart';
import 'package:islami/features/home/screens/homepagescreen.dart';
import 'package:islami/features/intro/screens/intro_screen.dart';
import 'package:islami/features/splash/screens/splash_page.dart';
import 'package:islami/features/home/screens/hadithscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashPage.route, // Start with Splash Page
      routes: {
        SplashPage.route: (context) => const SplashPage(),
        IntroScreen.route: (context) => const IntroScreen(),
        HomePageScreen.route: (context) => const HomePageScreen(),
        HadithScreen.route: (context) => const HadithScreen(),
      },
    );
  }
}
