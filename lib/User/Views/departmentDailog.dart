import 'dart:convert';
import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:opaltimecard/Admin/Modal/loggedInUsermodel.dart';
import 'package:opaltimecard/User/Modal/EmployeeData.dart';
import 'package:opaltimecard/connectivity.dart';
import 'package:opaltimecard/localDatabase/DatabaseHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DepartmentCard extends StatefulWidget {
  final Employees employee;

  const DepartmentCard({super.key, required this.employee});

  @override
  State<DepartmentCard> createState() => _DepartmentCardState();
}

class _DepartmentCardState extends State<DepartmentCard> {
  TextEditingController locationController = TextEditingController();
  TextEditingController bussinessId = TextEditingController();
  TextEditingController deviceId = TextEditingController();
  TextEditingController userId = TextEditingController();
  LoggedInUser? user;
  late SharedPreferences _prefs;
  Alldepartment? selectedDepartment;

  @override
  void initState() {
    _getCurrentLocation();
    _loadUserData();
    super.initState();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    if (!mounted) return;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (!mounted) return;

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (!mounted) return;

    setState(() {
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        locationController.text =
            '${placemark.name}, ${placemark.subLocality}, ${placemark.locality} ${placemark.postalCode}, ${placemark.administrativeArea}, ${placemark.country}';
        log("Location: ${locationController.text}");
      } else {
        locationController.text = 'Address not found';
      }
    });
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _loadUserData() async {
    await _initPrefs();
    String? userJson = _prefs.getString('loggedInUser');
    if (userJson != null) {
      setState(() {
        user = LoggedInUser.fromJson(jsonDecode(userJson));
        bussinessId.text = user!.businessId.toString();
        deviceId.text = user!.deviceId.toString();
        userId.text = user!.uid.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Dialog(
      child: SizedBox(
        width: width > 800 ? width * 0.3 : width * 0.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.green.shade800,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.employee.name}',
                      style: TextStyle(
                        fontSize: width < 700 ? 18 : 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.white,
                          size: 28.0,
                        ))
                  ],
                ),
              ),
            ),
            const Divider(height: 3),
            const SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.login_rounded,
                  color: Colors.green.shade800,
                  size: 50,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  'IN: ${DateFormat('hh:mm a').format(DateTime.now())}',
                  style: TextStyle(
                    fontSize: width < 700 ? 20 : 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    if (widget.employee.alldepartment != null)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            widget.employee.alldepartment!.map((alldepartment) {
                          return alldepartment.department != null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      // border: Border.all(color: Colors.green),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          foregroundColor: selectedDepartment ==
                                                  alldepartment
                                              ? Colors.black
                                              : Colors.black,
                                          backgroundColor: selectedDepartment ==
                                                  alldepartment
                                              ? const Color.fromARGB(
                                                  255, 224, 224, 224)
                                              : Colors.white,
                                          shadowColor: Colors.green.shade900,
                                          side: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 37, 84, 124),
                                          )),
                                      onPressed: () {
                                        setState(() {
                                          selectedDepartment = alldepartment;
                                        });
                                      },
                                      child: Text(
                                        alldepartment.department!.name ??
                                            'Unknown Department',
                                      ),
                                    ),
                                  ),
                                )
                              : const Text('No departments assigned');
                        }).toList(),
                      ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: selectedDepartment == null
                              ? null
                              : () async {
                                  _getCurrentLocation();
                                  bool isConnected = await ConnectionFuncs
                                      .checkInternetConnectivity();
                                  String currentTime = DateFormat('HH:mm:ss')
                                      .format(DateTime.now());
                                  String currentDate = DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now());

                                  EmployeeAttendance attendanceRecord =
                                      EmployeeAttendance(
                                          employeeId: widget.employee.id,
                                          employeeName: widget.employee.name,
                                          pin: widget.employee.pin,
                                          time: currentTime,
                                          date: currentDate,
                                          uid: userId.text,
                                          status: 'in',
                                          businessId: bussinessId.text,
                                          currentLocation:
                                              locationController.text,
                                          departmentId: selectedDepartment!
                                              .department!.id
                                              .toString(),
                                          deviceId: deviceId.text);

                                  int id = await DatabaseHelper.instance
                                      .insertAttendance(attendanceRecord);
                                  log('Attendance record inserted with ID: $id');
                                  final player = AudioPlayer();
                                  await player
                                      .play(AssetSource('audios/in.mp3'));
                                  Navigator.pop(context);
                                  if (isConnected) {
                                    DatabaseHelper databaseHelper =
                                        DatabaseHelper.instance;
                                    await databaseHelper
                                        .postSingleDataToAPI(attendanceRecord);
                                  }
                                },
                          child: const Text(
                            "OK",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
