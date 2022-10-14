import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Wether prediction App',
        home: Home(),
      ),
    );

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;
  var city = 'Landon';

  String getWeatherIcon(int condition) {
    if (condition < 30) {
      return '🌩';
    } else if (condition < 40) {
      return '🌧';
    } else if (condition < 60) {
      return '☔️';
    } else if (condition < 70) {
      return '☃️';
    } else if (condition < 80) {
      return '🌫';
    } else if (condition == 80) {
      return '☀️';
    } else if (condition <= 84) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  Future getWether() async {
    http.Response response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&units=Metric&appid=89c391678f289337ace893bdf39b1a98"));
    var results = jsonDecode(response.body);
    setState(() {
      this.temp = results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
    });
  }

  @override
  void initState() {
    super.initState();
    this.getWether();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            color: Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(hintText: 'City'),
                    onChanged: (value) {
                      setState(() {
                        city = value.trim();
                      });
                    },
                  ),
                ),
                TextButton(
                    onPressed: () {
                      String tempcity = city.toString();
                      setState(() {
                        city = tempcity;
                        getWether();
                      });
                    },
                    child: const Text(
                      'Get',
                      style: TextStyle(color: Colors.black),
                    )),
                Padding(
                  padding: EdgeInsets.only(bottom: 70.0),
                  child: Text(
                    'Currently in $city',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  temp != null ? temp.toString() + '\u00B0' : 'Loading',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  currently != null
                      ? currently.toString() +
                          " " +
                          getWeatherIcon(temp.round())
                      : 'Loading',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                    title: Text('Temperature'),
                    trailing: Text(
                      temp != null ? temp.toString() + '\u00B0' : 'Loading',
                    ),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.cloud),
                    title: Text('Weather'),
                    trailing: Text(
                      description != null ? description.toString() : 'Loading',
                    ),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.sun),
                    title: Text('Wind'),
                    trailing: Text(
                      windSpeed != null ? windSpeed.toString() : 'Loading',
                    ),
                  ),
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.solidGrinBeamSweat),
                    title: Text('Humidity'),
                    trailing: Text(
                      humidity != null ? humidity.toString() : 'Loading',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
