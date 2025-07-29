import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:islami/core/consts/app_assets.dart';

import 'package:islami/core/consts/app_assets.dart';

class TimeScreen extends StatefulWidget {
  static const String route = "/time";
  const TimeScreen({Key? key}) : super(key: key);

  @override
  State<TimeScreen> createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  int _currentPrayerIndex = 0;
  List<Map<String, String>> prayerTimes = [];
  bool isLoading = true;

  final List<String> orderedPrayerKeys = [
    "Sunrise",
    "Dhuhr",
    "Asr",
    "Maghrib",
    "Isha"
  ];

  String getCurrentDate() => DateFormat('dd MMM, yyyy').format(DateTime.now());
  String getCurrentDay() => DateFormat('EEEE').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    fetchPrayerTimes();
  }

  Future<void> fetchPrayerTimes() async {
    final date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final url =
        'https://api.aladhan.com/v1/timingsByCity/$date?city=cairo&country=egypt';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final timings = decoded['data']['timings'];

        setState(() {
          prayerTimes = orderedPrayerKeys
              .map((key) =>
                  {"name": key, "time": _formatTime(timings[key] ?? "--:--")})
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load prayer times");
      }
    } catch (e) {
      print("Error fetching prayer times: $e");
      setState(() => isLoading = false);
    }
  }

  String _formatTime(String rawTime) {
    try {
      final parsed = DateFormat("HH:mm").parse(rawTime);
      return DateFormat("hh:mm a").format(parsed);
    } catch (e) {
      return rawTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hijriDate = "09 Muh, 1446"; // Placeholder

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Image.asset(AppAssets.Mos, height: 80),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF5CB89),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(getCurrentDate(),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        Column(
                          children: [
                            const Text("Pray Time",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(getCurrentDay(),
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        Text(hijriDate,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Prayer Time Carousel
                  if (isLoading)
                    const CircularProgressIndicator()
                  else
                    CarouselSlider.builder(
                      itemCount: prayerTimes.length,
                      itemBuilder: (context, index, realIdx) {
                        final item = prayerTimes[index];
                        return Container(
                          width: 100,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.black87, Colors.black26],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(item["name"]!,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(height: 6),
                              Text(item["time"]!,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: 115,
                        enlargeCenterPage: true,
                        viewportFraction: 0.33,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentPrayerIndex = index;
                          });
                        },
                      ),
                    ),

                  const SizedBox(height: 15),

                  // Timer + Mute Icon
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text("Next Pray - ",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            TimerCountdown(
                              endTime: DateTime.now()
                                  .add(const Duration(hours: 2, minutes: 32)),
                              format: CountDownTimerFormat.hoursMinutes,
                              spacerWidth: 2,
                              descriptionTextStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              colonsTextStyle: const TextStyle(fontSize: 14),
                              enableDescriptions: false,
                            ),
                          ],
                        ),
                        const Icon(Icons.volume_off_outlined, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Azkar",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildAzkarCard("Evening Azkar", AppAssets.evening),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildAzkarCard("Morning Azkar", AppAssets.morning),
                  ),
                ],
              ),
            ),
            const Spacer(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildAzkarCard(String title, String imagePath) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.amber, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 80),
          const SizedBox(height: 10),
          Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ],
      ),
    );
  }
}
