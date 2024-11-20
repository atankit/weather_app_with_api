import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final Map<String, dynamic> city;

  DetailsScreen({required this.city});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(city['name']),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://openweathermap.org/img/wn/${city['icon']}@4x.png',
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.error, color: Colors.red, size: 50),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    city['name'],
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${city['temperature']}°C',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    city['description'].toUpperCase(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Divider(height: 30, color: Colors.grey.shade300),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildWeatherInfo(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: '${city['humidity']}%',
                      ),
                      _buildWeatherInfo(
                        icon: Icons.visibility,
                        label: 'Visibility',
                        value: '${city['visibility']} m',
                      ),
                      _buildWeatherInfo(
                        icon: Icons.air,
                        label: 'Wind Speed',
                        value: '${city['speed']} km/h',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.blueAccent),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
