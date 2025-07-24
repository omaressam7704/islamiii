import 'package:flutter/material.dart';
import 'package:islami/core/consts/app_assets.dart';
import 'package:islami/core/theme/app_Colors.dart';
import 'hadithscreen.dart';
import 'bottomnavbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Sura {
  final String englishName;
  final String arabicName;
  final int verses;
  final String imageAsset;
  final int id;
  Sura(
      {required this.englishName,
      required this.arabicName,
      required this.id,
      required this.verses,
      required this.imageAsset});
}

final List<Sura> mostRecents = [
  Sura(
    englishName: 'Al-Fatiha',
    id: 1,
    arabicName: 'الفاتحه',
    verses: 7,
    imageAsset: AppAssets.recentIMG,
  ),
  Sura(
    englishName: 'Al-Anbiya',
    arabicName: 'الأنبياء',
    id: 21,
    verses: 112,
    imageAsset: AppAssets.recentIMG,
  ),
  Sura(
    englishName: 'Al-Baqarah',
    arabicName: 'البقرة',
    id: 2,
    verses: 286,
    imageAsset: AppAssets.recentIMG,
  ),
];

class Surah {
  final int number;
  final String arabicName;
  final String englishName;
  final int numberOfAyahs;
  Surah(
      {required this.number,
      required this.arabicName,
      required this.englishName,
      required this.numberOfAyahs});

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'] as int,
      arabicName: json['name'] as String,
      englishName: json['englishName'] as String,
      numberOfAyahs: json['numberOfAyahs'] as int,
    );
  }
}

class SurasList extends StatelessWidget {
  const SurasList({Key? key}) : super(key: key);

  Future<List<Surah>> fetchSuras() async {
    final response =
        await http.get(Uri.parse('http://api.alquran.cloud/v1/surah'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List surasJson = data['data'] as List;
      return surasJson.map((json) => Surah.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load suras');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Surah>>(
        future: fetchSuras(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No suras found.'));
          }
          final suras = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: suras.length,
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.white, thickness: 1),
            itemBuilder: (context, index) {
              final sura = suras[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SurahDetailsScreen(
                        surahNumber: sura.number,
                        arabicName: sura.arabicName,
                        englishName: sura.englishName,
                      ),
                    ),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Star badge with number
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(AppAssets.surahNO),
                          Text(
                            '${sura.number}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // English name and verses
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sura.englishName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            '${sura.numberOfAyahs} Verses',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Arabic name
                    Text(
                      sura.arabicName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

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
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: _screens[_selectedIndex],
          bottomNavigationBar: BottomNavBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),
        ));
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Surah> _allSuras = [];
  List<Surah> _filteredSuras = [];
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    fetchSuras();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> fetchSuras() async {
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final response =
          await http.get(Uri.parse('http://api.alquran.cloud/v1/surah'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List surasJson = data['data'] as List;
        final suras = surasJson.map((json) => Surah.fromJson(json)).toList();
        setState(() {
          _allSuras = suras;
          _filteredSuras = suras;
          _loading = false;
        });
      } else {
        setState(() {
          _error = true;
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = true;
        _loading = false;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    setState(() {
      if (query.isEmpty) {
        _filteredSuras = _allSuras;
      } else {
        _filteredSuras = _allSuras
            .where((sura) =>
                sura.arabicName.contains(query) ||
                sura.englishName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Islami logo and mosque background, centered
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: 0.25,
                    child: Image.asset(
                      AppAssets.Mos,
                      width: 220,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Image.asset(
                    AppAssets.Islami,
                    width: 180,
                    color: const Color(0xFFF5D9A6),
                    colorBlendMode: BlendMode.srcATop,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color.fromARGB(255, 221, 179, 106),
                      width: 1),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        AppAssets.NavIcn1,
                        color: const Color(0xFFF5D9A6),
                        width: 24,
                        height: 24,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Sura Name',
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Most Recents (only show if search is empty)
            if (_searchController.text.isEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Most Recently',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Example: show only the first two suras as most recent
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _allSuras
                      .take(3)
                      .map((sura) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SurahDetailsScreen(
                                    surahNumber: sura.number,
                                    arabicName: sura.arabicName,
                                    englishName: sura.englishName,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 200,
                              height: 134,
                              margin: const EdgeInsets.only(left: 12),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 221, 179, 106),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.10),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      sura.englishName,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      sura.arabicName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      '${sura.numberOfAyahs} Verses',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
            ],
            // Suras List
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Suras List',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _loading
                  ? const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFFF5D9A6)))
                  : _error
                      ? const Center(
                          child: Text('Error loading suras',
                              style: TextStyle(color: Colors.red)))
                      : _filteredSuras.isEmpty
                          ? const Center(
                              child: Text('No results found.',
                                  style: TextStyle(color: Colors.white)))
                          : ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              itemCount: _filteredSuras.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                      color: Colors.white, thickness: 1),
                              itemBuilder: (context, index) {
                                final sura = _filteredSuras[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SurahDetailsScreen(
                                          surahNumber: sura.number,
                                          arabicName: sura.arabicName,
                                          englishName: sura.englishName,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Image.asset(AppAssets.surahNO),
                                            Text(
                                              '${sura.number}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              sura.englishName,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Text(
                                              '${sura.numberOfAyahs} Verses',
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        sura.arabicName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
      // ... your bottom navigation bar ...
    );
  }
}

class SurahDetailsScreen extends StatelessWidget {
  final int surahNumber;
  final String arabicName;
  final String englishName;
  const SurahDetailsScreen(
      {Key? key,
      required this.surahNumber,
      required this.arabicName,
      required this.englishName})
      : super(key: key);

  Future<List<String>> fetchVerses() async {
    final response = await http
        .get(Uri.parse('http://api.alquran.cloud/v1/surah/$surahNumber'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List ayahs = data['data']['ayahs'] as List;
      return ayahs.map<String>((a) => a['text'] as String).toList();
    } else {
      throw Exception('Failed to load verses');
    }
  }

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
                    englishName,
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
            // Decorative corners and Arabic name
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
              arabicName,
              style: const TextStyle(
                color: Color(0xFFF5D9A6),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Verses all together
            Expanded(
              child: FutureBuilder<List<String>>(
                future: fetchVerses(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFFF5D9A6)));
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error: \\${snapshot.error}',
                            style: const TextStyle(color: Colors.red)));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No verses found.',
                            style: TextStyle(color: Colors.white)));
                  }
                  final verses = snapshot.data!;
                  final allVerses = List.generate(
                          verses.length, (i) => '(${i + 1}) ${verses[i]}')
                      .join(' ');
                  return SingleChildScrollView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Text(
                      allVerses,
                      style: const TextStyle(
                        color: Color(0xFFF5D9A6),
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                  );
                },
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
