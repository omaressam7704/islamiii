import 'package:flutter/material.dart';
import 'package:islami/core/theme/app_Colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:islami/features/home/screens/homepagescreen.dart';

class IntroScreen extends StatefulWidget {
  static const String route = "/intro";

  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sec,
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                isLastPage = index == 4;
              });
            },
            children: [
              buildPage(
                  image: "assets/images/intro1.png",
                  title: "Welcome To Islami App"),
              buildPage(
                  image: "assets/images/intro2.png",
                  title: "Welcome To Islami",
                  description:
                      "We Are Very Excited To Have You In Our Community"),
              buildPage(
                  image: "assets/images/intro3.png",
                  title: "Reading the Quran",
                  description: "Read, and your Lord is the Most Generous"),
              buildPage(
                  image: "assets/images/intro4.png",
                  title: "Bearish",
                  description: "Praise the name of your Lord, the Most High"),
              buildPage(
                  image: "assets/images/intro5.png",
                  title: "Holy Quran Radio",
                  description:
                      "You can listen to the Holy Quran Radio through the application for free and easily"),
            ],
          ),

          // Dot indicator
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: 5,
                effect: ExpandingDotsEffect(
                    activeDotColor: Colors.amber,
                    dotColor: Colors.white54,
                    dotHeight: 10,
                    dotWidth: 10),
              ),
            ),
          ),

          // Navigation buttons
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                TextButton(
                  onPressed: () {
                    if (_controller.page! > 0) {
                      _controller.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    }
                  },
                  child: const Text("Back",
                      style: TextStyle(color: Colors.white70)),
                ),

                // Next / Finish button
                TextButton(
                  onPressed: () {
                    if (isLastPage) {
                      Navigator.pushReplacementNamed(
                          context, HomePageScreen.route);
                    } else {
                      _controller.nextPage(
                          duration: const Duration(milliseconds: 50),
                          curve: Curves.easeInOut);
                    }
                  },
                  child: Text(isLastPage ? "Finish" : "Next",
                      style: const TextStyle(color: Colors.amber)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage(
      {required String image, required String title, String? description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 250),
          const SizedBox(height: 20),
          Text(title,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber),
              textAlign: TextAlign.center),
          if (description != null) ...[
            const SizedBox(height: 10),
            Text(description,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center),
          ],
        ],
      ),
    );
  }
}
