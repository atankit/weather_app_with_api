import 'package:flutter/material.dart';
import 'weather_service.dart';

class AddCityScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddCity;

  AddCityScreen({required this.onAddCity});

  @override
  _AddCityScreenState createState() => _AddCityScreenState();
}

class _AddCityScreenState extends State<AddCityScreen> {
  final TextEditingController _controller = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  String? _errorMessage;

  Future<void> _addCity() async {
    final cityName = _controller.text.trim();
    if (cityName.isEmpty) {
      setState(() {
        _errorMessage = 'City name cannot be empty.';
      });
      return;
    }

    try {
      final weatherData = await _weatherService.fetchWeather(cityName);
      widget.onAddCity({
        'name': weatherData['name'],
        'temperature': weatherData['main']['temp'],
        'humidity': weatherData['main']['humidity'],
        'description': weatherData['weather'][0]['description'],
        'icon': weatherData['weather'][0]['icon'],
        'speed': weatherData['wind']['speed'],
        'visibility': weatherData['visibility'],
      });
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch weather for $cityName.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add City'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'City Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            SizedBox(height: 16),
            if (_errorMessage != null)
              Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addCity,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'Add City',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
