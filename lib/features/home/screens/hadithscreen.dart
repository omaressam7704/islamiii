import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:islami/core/consts/app_assets.dart';
import '../data/hadith_data.dart';

class HadithScreen extends StatelessWidget {
  static const String route = "/hadith";
  const HadithScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Hadeth Screen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      AppAssets.homeBg,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 24),
                      Image.asset(
                        AppAssets.Islami,
                        height: 80,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: CarouselSlider.builder(
                          itemCount: hadithList.length,
                          itemBuilder: (context, index, realIdx) {
                            final hadith = hadithList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HadithDetailsScreen(
                                      hadith: hadith,
                                      hadithNumber: index + 1,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 16),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5D9A6),
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          hadith.title,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Cairo',
                                          ),
                                          textAlign: TextAlign.center,
                                          textDirection: TextDirection.rtl,
                                        ),
                                        const SizedBox(height: 12),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            child: Text(
                                              hadith.text,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Cairo',
                                              ),
                                              textAlign: TextAlign.center,
                                              textDirection: TextDirection.rtl,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: double.infinity,
                            enlargeCenterPage: true,
                            viewportFraction: 0.8,
                            enableInfiniteScroll: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HadithDetailsScreen extends StatelessWidget {
  final Hadith hadith;
  final int hadithNumber;
  const HadithDetailsScreen(
      {Key? key, required this.hadith, required this.hadithNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar Row
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  Text(
                    'Hadith $hadithNumber',
                    style: const TextStyle(
                      color: Color(0xFFF5D9A6),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
            // Decorative corners and Hadith title
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 24, right: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(AppAssets.sura_left_corner, width: 60),
                  Image.asset(AppAssets.sura_right_corner, width: 60),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hadith.title,
              style: const TextStyle(
                color: Color(0xFFF5D9A6),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Hadith text (scrollable)
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text(
                  hadith.text,
                  style: const TextStyle(
                    color: Color(0xFFF5D9A6),
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
            // Bottom mosque decoration
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
              child: Image.asset(AppAssets.sura_bottom_decoration, height: 60),
            ),
          ],
        ),
      ),
    );
  }
}
