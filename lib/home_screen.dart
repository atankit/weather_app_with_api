import 'package:flutter/material.dart';
import 'add_city_screen.dart';
import 'details_screen.dart';
import 'weather_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> cities = [];
  final WeatherService _weatherService = WeatherService();

  void _addCity(Map<String, dynamic> cityData) {
    setState(() {
      cities.add(cityData);
    });
  }

  void _removeCity(int index) {
    setState(() {
      cities.removeAt(index);
    });
  }

  Future<void> _refreshWeather() async {
    List<Map<String, dynamic>> updatedCities = [];

    for (var city in cities) {
      try {
        final weatherData = await _weatherService.fetchWeather(city['name']);
        updatedCities.add({
          'name': weatherData['name'],
          'temperature': weatherData['main']['temp'],
          'humidity': weatherData['main']['humidity'],
          'description': weatherData['weather'][0]['description'],
          'icon': weatherData['weather'][0]['icon'],
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to refresh data for ${city['name']}')),
        );
        updatedCities.add(city);
      }
    }

    setState(() {
      cities = updatedCities;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        backgroundColor: Colors.blueAccent,
      ),
      body: cities.isEmpty
          ? Center(
        child: Text(
          'No cities added yet!',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : RefreshIndicator(
        onRefresh: _refreshWeather,
        child: ListView.builder(
          itemCount: cities.length,
          itemBuilder: (context, index) {
            final city = cities[index];
            return Card(
              child: ListTile(
                leading: Image.network(
                  'https://openweathermap.org/img/wn/${city['icon']}@2x.png',
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.error, color: Colors.red),
                ),
                title: Text(city['name']),
                subtitle: Text('${city['temperature']}°C'),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _removeCity(index),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(city: city),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCityScreen(onAddCity: _addCity),
            ),
          );
        },
        child: Icon(Icons.add_location, color: Colors.white,),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
