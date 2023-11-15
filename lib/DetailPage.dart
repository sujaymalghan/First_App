import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  const DetailPage({Key? key, required this.weatherData}) : super(key: key);

  String getWeatherImage() {
    if (weatherData['humidity'] > 80 && weatherData['temp'] < 20) {
      return 'assets/images/heavyrain.jpg';
    } else if (weatherData['temp'] > 25) {
      return 'assets/images/hotsun.jpg';
    } else {
      return 'assets/images/mildsunny.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    String weatherImagePath = getWeatherImage();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('More Weather Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            weatherInfoBox(
              context,
              'Wind Speed: ${weatherData['wind_speed']} m/s',
            ),
            SizedBox(height: 10),
            weatherInfoBox(
              context,
              'Wind Direction: ${weatherData['wind_degrees']} degrees',
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 400.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(weatherImagePath),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container weatherInfoBox(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.blueGrey, width: 1.0),
      ),
      child: Text(
        text,
        style: fixedSizeStyle(context),
      ),
    );
  }

  TextStyle fixedSizeStyle(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: Theme
          .of(context)
          .textTheme
          .titleLarge
          ?.fontSize,
      letterSpacing: 1.2,
      shadows: [
        Shadow(
          offset: Offset(1.0, 1.0),
          blurRadius: 3.0,
          color: Colors.grey.withOpacity(0.5),
        ),
      ],
    );
  }
}