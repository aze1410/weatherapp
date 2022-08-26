// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_string_escapes, prefer_interpolation_to_compose_strings, sort_child_properties_last, deprecated_member_use

import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:geoapp/weatherpart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoapp/search.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  String bgimg;

  MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(scaffoldBackgroundColor: Color.fromARGB(255, 35, 35, 35)),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int val = 1;
  String output;
  String currentAddress = "";
  Position currentposition;
  String dp = "assets/images/night.jpg";
  String ic = "assets/icons/cloudsic.png";
  bool isbool = true;
  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;

  // ignore: missing_return
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please enable Your Location Service');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
              'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        currentposition = position;
        currentAddress = "${place.locality}";
      });
      http.Response response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$currentAddress&appid=1e8d29d84a807c90ad50c8d1d61370f4&units=metric'));

      var results = jsonDecode(response.body);
      setState(() {
        this.temp = results["main"]["temp"];
        this.description = results["weather"][0]["description"];
        this.currently = results["weather"][0]["main"];
        this.humidity = results["main"]["humidity"];
        this.windSpeed = results["wind"]["speed"];

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
        output = temp != null ? temp.round().toString() + "\u2103" : "loading";
      });
      // ignore: empty_catches
    } catch (e) {}
    setState(() {
      isbool = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  conv() {
    if (val == 1) {
      output = temp != null ? temp.round().toString() + "\u2103" : "loading";
    } else if (val == 2) {
      var fah = ((temp * 9 / 5) + 32).round();
      output = fah != null ? fah.toString() + "\u2109" : "loading";
    }
  }
  // ignore: non_constant_identifier_names

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Search(val)),
            );
          },
          icon: Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
        ),
        actions: [
          PopupMenuButton<dynamic>(
              icon: Icon(Icons.menu_rounded),
              color: Color.fromARGB(255, 222, 222, 222),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                      .copyWith(topRight: Radius.circular(0))),
              padding: EdgeInsets.all(10),
              itemBuilder: (context) => [
                    PopupMenuItem(
                        padding: EdgeInsets.fromLTRB(32, 0, 0, 0),
                        child: Row(children: [
                          Text(
                            "Units  -  ",
                            style: GoogleFonts.hind(
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 27, 27, 27)),
                          ),
                          Text(
                            "C",
                            style: GoogleFonts.hind(
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 27, 27, 27)),
                          ),
                          Radio<int>(
                            value: 1,
                            groupValue: val,
                            onChanged: (value) {
                              setState(() {
                                val = value as int;
                                conv();
                                Navigator.pop(context);
                              });
                            },
                          ),
                          Text(
                            "F",
                            style: GoogleFonts.hind(
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 27, 27, 27)),
                          ),
                          Radio<int>(
                            value: 2,
                            groupValue: val,
                            onChanged: (value) {
                              setState(() {
                                val = value as int;
                                conv();
                                Navigator.pop(context);
                              });
                            },
                          ),
                        ])),
                    PopupMenuItem(
                        child: ListTile(
                      title: Text(
                        'Data provided in part by',
                        style: GoogleFonts.hind(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 27, 27, 27)),
                      ),
                      subtitle: Text(
                        'OpenWeather',
                        style: GoogleFonts.hind(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 27, 27, 27)),
                      ),
                      onTap: () async {
                        await launch("https://openweathermap.org/");
                      },
                    ))
                  ]),
        ],
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
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 118,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 14,
                              ),
                              Text(
                                DateFormat('HH:mm').format(DateTime.now()),
                                style: GoogleFonts.hind(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                height: 0,
                              ),
                              Text(
                                currentAddress,
                                style: GoogleFonts.lato(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
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
                                output,
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
                          height: 98,
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
                                                style:
                                                    GoogleFonts.archivoNarrow(
                                                        fontSize: 19,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white)),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Text(
                                              output,
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
                                                style:
                                                    GoogleFonts.archivoNarrow(
                                                        fontSize: 19,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                                style:
                                                    GoogleFonts.archivoNarrow(
                                                        fontSize: 19,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                                style:
                                                    GoogleFonts.archivoNarrow(
                                                        fontSize: 19,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                ),
              ],
            ),
    );
  }
}
