import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

class RadioScreen extends StatefulWidget {
  static const String route = "/radio";
  const RadioScreen({Key? key}) : super(key: key);

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen>
    with TickerProviderStateMixin {
  List<RadioStation> radioStations = [];
  bool isLoading = true;
  late TabController _tabController;

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchRadioStations();
  }

  Future<void> fetchRadioStations() async {
    final url = Uri.parse('https://mp3quran.net/api/v3/radios?language=eng');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        radioStations = (jsonData['radios'] as List)
            .map((station) => RadioStation.fromJson(station))
            .toList();
        isLoading = false;
      });
    } else {
      // handle error
      setState(() => isLoading = false);
    }
  }

  void playRadio(String url) async {
    await _audioPlayer.stop();
    await _audioPlayer.setVolume(1); // Set volume to 0 as requested
    await _audioPlayer.play(UrlSource(url));
  }

  void pauseRadio() async {
    await _audioPlayer.pause();
  }

  void muteRadio() async {
    await _audioPlayer.setVolume(0);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset("assets/images/radio_bg.png",
                        width: double.infinity, height: 200, fit: BoxFit.cover),
                    Positioned(
                      child: Image.asset("assets/images/header_mosque.png",
                          width: 100),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: "Live"),
                    Tab(text: "All"),
                  ],
                  indicatorColor: Colors.deepPurple,
                  labelColor: Colors.deepPurple,
                  unselectedLabelColor: Colors.grey,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      buildRadioList(radioStations),
                      buildRadioList(radioStations),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildRadioList(List<RadioStation> stations) {
    return ListView.builder(
      itemCount: stations.length,
      itemBuilder: (context, index) {
        final station = stations[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: ListTile(
            title: Text(station.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("ID: ${station.id}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () => playRadio(station.url)),
                IconButton(
                    icon: const Icon(Icons.pause), onPressed: pauseRadio),
                IconButton(
                    icon: const Icon(Icons.volume_off), onPressed: muteRadio),
              ],
            ),
          ),
        );
      },
    );
  }
}

class RadioStation {
  final int id;
  final String name;
  final String url;
  final String recentDate;

  RadioStation({
    required this.id,
    required this.name,
    required this.url,
    required this.recentDate,
  });

  factory RadioStation.fromJson(Map<String, dynamic> json) {
    return RadioStation(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      recentDate: json['recent_date'],
    );
  }
}
