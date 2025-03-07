import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:islami/core/consts/app_assets.dart';
import 'package:islami/features/intro/screens/intro_screen.dart';

class SplashPage extends StatefulWidget {
  static const String route = "/splash";

  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, IntroScreen.route);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(AppAssets.splashBg),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: ZoomIn(
                duration: const Duration(milliseconds: 1750),
                child: Image.asset(
                  AppAssets.splashLogo,
                  height: size.height * 0.25,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FadeInUp(
                duration: const Duration(milliseconds: 1750),
                child: Image.asset(
                  AppAssets.splashRoute,
                  height: size.height * 0.25,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: FadeInDown(
                duration: const Duration(milliseconds: 1750),
                child: Image.asset(
                  AppAssets.splashGlow,
                  height: size.height * 0.25,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 0.25),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FadeInRight(
                  duration: const Duration(milliseconds: 1750),
                  child: Image.asset(
                    AppAssets.splashLeft,
                    width: size.width * 0.25,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 0.25),
              child: FadeInLeft(
                duration: const Duration(milliseconds: 1750),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    AppAssets.splashRight,
                    width: size.width * 0.25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
