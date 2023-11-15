import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'DetailPage.dart';

void main() {

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Sujay \'s Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _cityController = TextEditingController();
  bool _isGridView = true;
  Map<String, dynamic> _weatherData = {};

  void fetchWeather() async {
    var url = Uri.parse('https://weather-by-api-ninjas.p.rapidapi.com/v1/weather')
        .replace(queryParameters: {'city': _cityController.text});
    var headers = {
      "X-RapidAPI-Key": "9f76d8c7fcmsh43f6720c66820aep18d2c7jsnc0230aefb8da",
      "X-RapidAPI-Host": "weather-by-api-ninjas.p.rapidapi.com"
    };

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data.containsKey('error')) {
          setState(() {
            _weatherData = {};
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Enter a valid city')),
          );
        } else {
          setState(() {
            _weatherData = data;
          });
        }
      } else {
        _weatherData= "Enter the Valid City" as Map<String, dynamic>;
      }


    } catch (e) {
    _weatherData = "Enter the Valid City" as Map<String, dynamic>;
    }



  }

  Widget buildGridView() {
    if (_weatherData.isEmpty) {
      return const Center(child: Text('No weather data available'));
    }

    var relevantData = {
      'cloud_pct': _weatherData['cloud_pct'],
      'temp': _weatherData['temp'],
      'feels_like': _weatherData['feels_like'],
      'humidity': _weatherData['humidity'],
      'min_temp': _weatherData['min_temp'],
      'max_temp': _weatherData['max_temp'],
    };

    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1.5,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      children: relevantData.entries.map((entry) {
        String displayValue = entry.key == 'humidity' || entry.key == 'cloud_pct' ? '${entry.value}%' : '${entry.value}';
        return Card(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${entry.key.toLowerCase()}:',
                  style: fixedSizeStyle(context),
                ),
                Text(
                  displayValue,
                  style:fixedSizeStyle(context),
                ),
              ],
            ),
          ),
        );
      }).toList(),

    );
  }
  Widget buildListView() {
    if (_weatherData.isEmpty) {
      return const Center(child: Text('No weather data available'));
    }

    var relevantData = {
      'cloud_pct': _weatherData['cloud_pct'],
      'temp': _weatherData['temp'],
      'feels_like': _weatherData['feels_like'],
      'humidity': _weatherData['humidity'],
      'min_temp': _weatherData['min_temp'],
      'max_temp': _weatherData['max_temp'],
    };

    TextStyle fixedSizeStyle(BuildContext context) {
      return TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
      );
    }


    return ListView(
      children: relevantData.entries.map((entry) {
        String displayValue = entry.key == 'humidity' || entry.key == 'cloud_pct'  ? '${entry.value}%' : '${entry.value}';
        return Card(
          child: ListTile(
            title: Text(
              entry.key.toLowerCase(),
              style: fixedSizeStyle(context),

            ),
            trailing: Text(
              displayValue,
              style: fixedSizeStyle(context)
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () => setState(() {
              _isGridView = !_isGridView;
            }),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'Enter City Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: fetchWeather,
              child: const Text('Search Weather'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_weatherData.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailPage(weatherData: _weatherData)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Search the weather data first')),
                  );
                }
              }, child: const Text('View More Details'),
            ),
            const Text(
                "(All Temperatures in Degree Celsius)",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                )),
            const SizedBox(height: 20),
            Expanded(child: _isGridView ? buildGridView() : buildListView()),
          ],
        ),
      ),
    );
  }

  fixedSizeStyle(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
    );
  }
}