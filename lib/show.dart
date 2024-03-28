import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'dart:convert';
import 'model.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {




  Location location = Location();
  TextEditingController searchController = TextEditingController();
  List<WeatherInfo> weatherDataList = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocationWeather();
  }

  Future<void> _getCurrentLocationWeather() async {
    try {
      var currentLocation = await location.getLocation();
      double? currentLat = currentLocation.latitude;
      double? currentLong = currentLocation.longitude;

      final currentWeather =
      await _fetchWeather(currentLat!, currentLong!, 'Current Location');
      if (currentWeather != null) {
        setState(() {
          weatherDataList.add(currentWeather);
        });
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> _searchWeather(String query) async {
    final apiKey = 'ee565cb6943fce2f2675cf546a09ad12';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$query&appid=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final searchWeather = WeatherInfo.fromJson(jsonData);
      setState(() {
        weatherDataList.add(searchWeather);
        searchController.clear(); // Clear the text field after search
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<WeatherInfo?> _fetchWeather(
      double lat, double lon, String name) async {
    final apiKey = 'ee565cb6943fce2f2675cf546a09ad12';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return WeatherInfo.fromJson(jsonData);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff454daf),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, icon:Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        width: MediaQuery.of(context).size.width * 1,
        decoration: BoxDecoration(color: Color(0xfff4f4fc),
          image: DecorationImage(
              image: AssetImage("assets/moon.jpg"),fit: BoxFit.fill
          ),),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  onSubmitted: (String value) {
                    _searchWeather(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 5,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: weatherDataList.length,
                  itemBuilder: (context, index) {
                    final weatherData = weatherDataList[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      weatherData.name ?? '',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                  // SizedBox(
                                  //   width: 50,
                                  // ) ,
                                  Expanded(
                                    child: Text(
                                      '${((weatherData.main?.temp ?? 0) - 273.15).toStringAsFixed(2)}°C',
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Icon(Icons.water_drop),
                                  Text('${weatherData.main?.humidity ?? ''}%'),
                                  Icon(Icons.air),
                                  Text(
                                      '${weatherData.wind?.speed ?? ''} km/hr'),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * .2,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/moon.jpg"),
                              fit: BoxFit.fill
                          ),

                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text("Preciption",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("40%",
                                          style: TextStyle(
                                            fontSize: 20,
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("Humidity",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('45',
                                          style: TextStyle(
                                            fontSize: 20,
                                          )),
                                    ],
                                  ),
                                  Container(
                                    height: 80,
                                    alignment: Alignment.center,
                                    child: VerticalDivider(
                                      color: Colors.white,
                                      thickness: 2,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text("Wind",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("140",
                                          style: TextStyle(
                                            fontSize: 20,
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("Pressure",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("450hPa",
                                          style: TextStyle(
                                            fontSize: 20,
                                          ))
                                    ],
                                  )
                                ]),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
