import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/weather_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchState();
}

class _SearchState extends State<SearchScreen> {
  Card? currentLocationCard;
  final TextEditingController searchController = TextEditingController();

  Future<Card?> getResultCard(String location) async {
    const apiKey = "54d6d1359c044af0bd1171918250908";
    final url = Uri.parse(
        "https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$location");

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (data['error'] != null) return null;

      return Card(
        color: Colors.black45,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_pin,
                    size: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    data['location']['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "${data['current']['temp_c']}°C, ${data['current']['condition']['text']}",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      return null;
    }
  }

  void search() async {
    String location = searchController.text.trim();
    if (location.isEmpty) return;

    final wc = await getResultCard(location);
    if (wc != null) {
      setState(() => currentLocationCard = wc);
    }
  }

  void selectLocation() {
    WeatherService.setCity(searchController.text.trim());
    Navigator.pop(context, searchController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        title: const Text("Search Location"),
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search Locations",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: search,
              child: const Text("Search"),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: selectLocation,
              child: SizedBox(
                width: double.infinity,
                height: 100,
                child: currentLocationCard ??
                    const Center(
                      child: Text(
                        "No location selected",
                        style: TextStyle(color: Colors.white70),
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
