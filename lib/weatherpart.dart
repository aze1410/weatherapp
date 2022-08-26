// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geoapp/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;

class weatherpart extends StatefulWidget {
  final option;
  final val;

  // ignore: use_key_in_widget_constructors
  const weatherpart(this.option, this.val);

  @override
  // ignore: library_private_types_in_public_api
  _weatherpartState createState() => _weatherpartState(this.option, this.val);
}

class _weatherpartState extends State<weatherpart> {
  bool isbool = true;
  String output2;
  final option;
  final val;
  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;
  String dp = "assets/night.jpg";
  String ic = "assets/icons/cloudsic.png";

  _weatherpartState(this.option, this.val);

  Future getWeather() async {
    http.Response response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$option&appid=1e8d29d84a807c90ad50c8d1d61370f4&units=metric'));
    var results = jsonDecode(response.body);
    setState(() {
      this.temp = results["main"]["temp"];
      this.description = results["weather"][0]["description"];
      this.currently = results["weather"][0]["main"];
      this.humidity = results["main"]["humidity"];
      windSpeed = results["wind"]["speed"];

      if (currently == "Clear") {
        dp = "assets/images/clearsky.jpg";
        ic = "assets/icons/snowic.png";
      } else if (currently == "Clouds") {
        dp = "assets/images/brokenclouds.jpg";
        ic = "assets/icons/cloudsic.png";
      } else if (currently == "Drizzle") {
        dp = "assets/images/showerrain.jpg";
        ic = "assets/icons/drizzleic.png";
      } else if (currently == "Rain") {
        dp = "assets/images/rain.jpg";
        ic = "assets/icons/rainic.png";
      } else if (currently == "Thunderstorm") {
        dp = "assets/images/thunderstrom.jpg";
        ic = "assets/icons/thunderic.png";
      } else if (currently == "Snow") {
        dp = "assets/images/snow.jpg";
        ic = "assets/icons/snowic.png";
      } else if (currently == "Mist") {
        dp = "assets/images/mist.jpg";
        ic = "assets/icons/cloudsic.png";
      } else if (currently == "Dust") {
        dp = "assets/images/dustss.jpg";
        ic = "assets/icons/cloudsic.png";
      } else if (currently == "Tornado") {
        dp = "assets/images/Tornado.jpg";
        ic = "assets/icons/cloudsic.png";
      } else if (currently == "Ash") {
        dp = "assets/images/Ash.jpg";
      } else if (currently == "Fog") {
        dp = "assets/images/Fog.jpg";
        ic = "assets/icons/fogic.png";
      } else if (currently == "Haze") {
        dp = "assets/images/haze.jpg";
        ic = "assets/icons/hazeic.png";
      } else if (currently == "Smoke") {
        dp = "assets/images/smoke.jpg";
        ic = "assets/icons/cloudsic.png";
      }
      output2 = temp != null ? temp.round().toString() + "\u2103" : "loading";

      if (val == 1) {
        output2 = temp != null ? temp.round().toString() + "\u2103" : "loading";
      } else if (val == 2) {
        var fah = ((temp * 9 / 5) + 32).roundToDouble();
        output2 = fah != null ? fah.round().toString() + "\u2109" : "loading";
      }
    });
    setState(() {
      isbool = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: isbool
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Image.asset(
                  dp,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
                Container(
                  decoration: const BoxDecoration(color: Colors.black54),
                ),
                Container(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 150,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          option,
                          style: GoogleFonts.lato(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 95, 0, 0),
                        child: Column(
                          children: [
                            Image.asset(
                              ic,
                              fit: BoxFit.cover,
                              height: 60,
                              width: 60,
                            ),
                            Text(
                              output2,
                              style: GoogleFonts.inter(
                                  fontSize: 65,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              currently != null
                                  ? currently.toString()
                                  : "loading",
                              style: GoogleFonts.montserrat(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 88,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              height: 180,
                              width: 165,
                              child: Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                color: Colors.black12,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/desicons/thermoic.png"),
                                      alignment: Alignment.topLeft,
                                    ),
                                  ),
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 60, 0, 0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text("Temperature",
                                              style: GoogleFonts.archivoNarrow(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white)),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            output2,
                                            style: GoogleFonts.rubik(
                                              fontSize: 26,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                  margin: EdgeInsets.all(20),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 180,
                              width: 165,
                              child: Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                color: Colors.black12,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(ic),
                                      alignment: Alignment.topLeft,
                                    ),
                                  ),
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 60, 0, 0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text("Weather",
                                              style: GoogleFonts.archivoNarrow(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white)),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            currently != null
                                                ? currently.toString()
                                                : "loading",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 30,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                  margin: EdgeInsets.all(20),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 180,
                              width: 165,
                              child: Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                color: Colors.black12,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/desicons/humic.png"),
                                      alignment: Alignment.topLeft,
                                    ),
                                  ),
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 60, 0, 0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text("Humidity",
                                              style: GoogleFonts.archivoNarrow(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white)),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            humidity != null
                                                ? humidity.toString()
                                                : "loading",
                                            style: GoogleFonts.rubik(
                                              fontSize: 30,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                  margin: EdgeInsets.all(20),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 180,
                              width: 165,
                              child: Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                color: Colors.black12,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/desicons/windic.png"),
                                      alignment: Alignment.topLeft,
                                    ),
                                  ),
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 60, 0, 0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text("Wind",
                                              style: GoogleFonts.archivoNarrow(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white)),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            windSpeed != null
                                                ? windSpeed.toString()
                                                : "loading",
                                            style: GoogleFonts.rubik(
                                              fontSize: 30,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                  margin: EdgeInsets.all(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
