import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  TextEditingController search = TextEditingController();
  String city = "";
  String weather = "";
  num? windSpeed;
  num? temp;
  num? fah;
  num? cloud;
  num? pressure;
  num? humidity;
  String formattedDate = DateFormat('EEEE, MMMM d').format(DateTime.now());

  num fahrenheit() {
    return temp != null ? (temp! * 9 / 5) + 32 : 0;
  }

  void getweather() async {
    String searchCity = search.text;
    var data = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$searchCity&appid=5bd7a27bebc6db6a9dfdc53748a3bbc2&units=metric"));

    if (data.statusCode == 200) {
      var response = jsonDecode(data.body);
      setState(() {
        city = response['name'];
        temp = response['main']['temp'];
        weather = response['weather'][0]['description'];
        fah = fahrenheit();
        windSpeed = response['wind']['speed'];
        cloud = response['clouds']['all'];
        pressure = response['main']['pressure'];
        humidity = response['main']['humidity'];
      });
    } else {
      setState(() {
        city = "City not found";
        temp = 0;
        fah = 0;
        formattedDate = "";
        weather = "";
        windSpeed = 0;
        pressure = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: search,
                            decoration: InputDecoration(
                              hintText: "Search city,state or country",
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                getweather();
                              }
                            },
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              getweather();
                            },
                            child: const Text(
                              "Search",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Icon(
                      temp != null ? Icons.cloud : Icons.error,
                      size: 80,
                      color: Colors.blue,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(city, style: const TextStyle(fontSize: 24)),
                    Text(temp != null ? '$temp °C' : 'N/A',
                        style: const TextStyle(fontSize: 48)),
                    Text(fah != null ? '$fah °F' : 'N/A',
                        style: const TextStyle(fontSize: 24)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(temp != null ? formattedDate : "",
                        style: const TextStyle(color: Colors.grey)),
                    Text(weather, style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 20),
                    const Divider(thickness: 2),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildWeatherInfo(Icons.air, "${windSpeed ?? 0} km/h",
                            "Wind", Colors.black),
                        _buildWeatherInfo(Icons.cloud, "${cloud ?? 0} %",
                            "Cloud", Colors.blue),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildWeatherInfo(Icons.speed, "${pressure ?? 0} mb",
                            "Pressure", Colors.black),
                        _buildWeatherInfo(Icons.opacity, "${humidity ?? 0} %",
                            "Humidity", Colors.blue),
                      ],
                    )
                  ],
                ),
              )),
        ));
  }

  Widget _buildWeatherInfo(
      IconData icon, String value, String label, Color col) {
    return Column(
      children: [
        Icon(icon, size: 30, color: col),
        Text(value, style: const TextStyle(fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
