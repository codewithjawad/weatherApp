import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  TextEditingController search = TextEditingController();
  String city = "Karachi";
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

  @override
  void initState() {
    super.initState();
    // Fetch weather data for the default city on app launch
    getweather();
  }

  void getweather() async {
    var data = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=ur api key&units=metric"));

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
        humidity = 0;
        cloud = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text('Weather App',
                style: GoogleFonts.poppins(
                    fontSize: 24, fontWeight: FontWeight.w700))),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: search,
                        decoration: InputDecoration(
                          hintText: "Search city or country",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            city = value;
                            getweather();
                          }
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (search.text.isNotEmpty) {
                          city = search.text;
                          getweather();
                        }
                      },
                      child: const Text(
                        "Search",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Icon(
                  Icons.cloud,
                  size: 80,
                  color: Colors.blue,
                ),
                const SizedBox(height: 10),
                Text(city, style: const TextStyle(fontSize: 24)),
                Text('$temp °C', style: const TextStyle(fontSize: 48)),
                Text('$fah °F', style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 10),
                Text(formattedDate, style: const TextStyle(color: Colors.grey)),
                Text(weather, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                const Divider(thickness: 2),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildWeatherInfo(
                        Icons.air, "$windSpeed km/h", "Wind", Colors.black),
                    _buildWeatherInfo(
                        Icons.cloud, "$cloud %", "Cloud", Colors.blue),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildWeatherInfo(
                        Icons.speed, "$pressure mb", "Pressure", Colors.black),
                    _buildWeatherInfo(
                        Icons.opacity, "$humidity %", "Humidity", Colors.blue),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
