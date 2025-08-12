import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'search_screen.dart';
import 'weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => WeatherScreenState();
}

class WeatherScreenState extends State<WeatherScreen> {
  bool isLoading = true;
  Map<String, dynamic>? weatherData;
  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    try {
      var data = await WeatherService.fetchWeatherByCity();
      setState(() {
        weatherData = data;
        isLoading = false;
      });
      print(weatherData!['forecast']['forecastday'].length);
    } catch (e) {
      debugPrint("Error fetching weather: $e");
    }
  }

  String getDayFromDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('EEEE').format(parsedDate);
  }

  void refresh() {
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [IconButton(onPressed: refresh, icon: Icon(Icons.refresh))],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text("Search Location"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              },
            ),
          ],
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : weatherData == null
          ? const Center(child: Text("Error loading weather data"))
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  // Current Weather Row
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left side (Temp + Icon)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${weatherData!['current']['temp_c']}°C",
                                style: const TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                weatherData!['location']['name'],
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 6),
                              Image.network(
                                "https:${weatherData!['current']['condition']['icon']}",
                                width: 70,
                              ),
                            ],
                          ),

                          // Right side (Details)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Humidity: ${weatherData!['current']['humidity']}%",
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Wind: ${weatherData!['current']['wind_kph']} km/h",
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Feels Like: ${weatherData!['current']['feelslike_c']}°C",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Forecast
                  Expanded(
                    child: ListView.builder(
                      itemCount: weatherData!['forecast']['forecastday'].length,
                      itemBuilder: (context, index) {
                        var day =
                            weatherData!['forecast']['forecastday'][index];
                        return Card(
                          child: ListTile(
                            leading: Image.network(
                              "https:${day['day']['condition']['icon']}",
                            ),
                            title: Text(getDayFromDate(day['date'])),
                            subtitle: Text(day['day']['condition']['text']),
                            trailing: Text("${day['day']['avgtemp_c']}°C"),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
