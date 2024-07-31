// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:opaltimecard/Admin/Modal/loggedInUsermodel.dart';
import 'package:opaltimecard/User/Modal/EmployeeData.dart';
import 'package:opaltimecard/User/Views/departmentDailog.dart';
import 'package:opaltimecard/User/Views/logoutDailog.dart';
import 'package:opaltimecard/Utils/customDailoge.dart';
import 'package:opaltimecard/Utils/employeeScreen.dart';
import 'package:opaltimecard/connectivity.dart';
import 'package:opaltimecard/localDatabase/DatabaseHelper.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool attendance = false;
  List<EmployeeAttendance> attendanceList = [];
  Timer? timer;
  String UserLocation = '';
  late SharedPreferences _prefs;
  LoggedInUser? user;
  bool toggle = true;
  bool isProcessing = false;
  late StreamSubscription<bool> streamSubscription;
  late TimeOfDay selectedTime;
  String? modelName;
  String? deviceMACAddress;
  Timer? _dismissTimer;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      await Permission.camera.request();
    }
  }

  // void _onQRViewCreated(QRViewController qrController) {
  //   controller = qrController;
  // controller?.scannedDataStream.listen((scanData) async {
  //     if (!isProcessing) {
  //       setState(() {
  //         isProcessing = true;
  //         result = scanData;
  //       });
  //       await Future.delayed(const Duration(milliseconds: 500)); // Debounce
  //       processAttendance();
  // isProcessing = false;
  //     }
  //   });
  // }

  void _onQRViewCreated(QRViewController qrController) {
    controller = qrController;
    controller?.scannedDataStream.listen((scanData) async {
      if (!isProcessing) {
        setState(() {
          isProcessing = true;
          result = scanData;
        });
        toggle = !toggle;
        await Future.delayed(const Duration(milliseconds: 800), () {
          processAttendance();
          isProcessing = false;
        });
      }
    });
  }

  void processAttendance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('loggedInUser');
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      LoggedInUser loggedInUser = LoggedInUser.fromJson(userMap);
      List<Employees>? employees = loggedInUser.employees;

      bool pinMatch =
          employees!.any((employee) => employee.pin == result!.code);

      if (pinMatch) {
        Employees? matchedEmployee = employees.firstWhere(
          (employee) => employee.pin == result!.code,
          orElse: () {
            return const Employees();
          },
        );
        handleAttendance(matchedEmployee, loggedInUser);
      } else {
        final player = AudioPlayer();
        await player.play(AssetSource('audios/pleasetryagain.mp3'));
        _showerrorDailog(context);
      }
    }
  }

  void handleAttendance(
      Employees matchedEmployee, LoggedInUser loggedInUser) async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    List<EmployeeAttendance> records =
        await databaseHelper.getAllAttendanceRecord();
    EmployeeAttendance? lastAttendance =
        await DatabaseHelper.instance.getLastAttendance(matchedEmployee.pin!);
    if (lastAttendance != null && lastAttendance.status == 'in') {
      bool isConnected = await ConnectionFuncs.checkInternetConnectivity();

      List<String> parts = lastAttendance.time!.split(":");
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);

      List<String> dateParts = lastAttendance.date!.split("-");
      int year = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int day = int.parse(dateParts[2]);

      DateTime dateTime = DateTime(year, month, day, hours, minutes);
      String lastTime = DateFormat('hh:mm a').format(dateTime);

      DateTime time1 = DateTime.now();
      Duration difference = time1.difference(dateTime);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          double width = MediaQuery.of(context).size.width;

          return Dialog(
            child: SizedBox(
              width: width > 800 ? width * 0.3 : width * 0.5,
              child: Wrap(
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ' ${matchedEmployee.name ?? "Unknown"}',
                                  style: TextStyle(
                                    fontSize: width < 700 ? 18 : 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(
                          height: 3,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Column(
                                children: [
                                  Icon(
                                    Icons.logout_rounded,
                                    color: Colors.red,
                                    size: 50,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Out',
                                    style: TextStyle(
                                        fontSize: width < 700 ? 20 : 25,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                  Text(
                                    DateFormat('hh:mm a')
                                        .format(DateTime.now()),
                                    style: TextStyle(
                                        fontSize: width < 700 ? 15 : 20,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    'In:',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${lastAttendance.date ?? ''} $lastTime",
                                    style: TextStyle(
                                        fontSize: width < 700 ? 15 : 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    'Out:',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    DateFormat('yyyy-MM-DD hh:mm a')
                                        .format(DateTime.now()),
                                    style: TextStyle(
                                        fontSize: width < 700 ? 15 : 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    'Hours:',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${difference.inHours.toString().padLeft(2, '0')}:${difference.inMinutes.remainder(60).toString().padLeft(2, '0')}",
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(30, 60, 87, 1),
                                    ),
                                  ),
                                ],
                              ),
                              if (matchedEmployee.alldepartment!.length > 1)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color?>(
                                          (Set<MaterialState> states) {
                                            return Colors.red;
                                          },
                                        ),
                                        fixedSize: MaterialStateProperty.all(
                                            const Size(150, 40)),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _dismissTimer?.cancel();
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return DepartmentCard(
                                                employee: matchedEmployee);
                                          },
                                        );
                                      },
                                      child: const Text(
                                        "Transfer",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ]),
                ],
              ),
            ),
          );
        },
      ).whenComplete(() async {
        String currentTime = DateFormat('HH:mm').format(DateTime.now());
        String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

        Future.delayed(const Duration(milliseconds: 100), () async {
          EmployeeAttendance attendanceRecord = EmployeeAttendance(
            employeeId: matchedEmployee.id,
            employeeName: matchedEmployee.name,
            pin: matchedEmployee.pin,
            time: currentTime,
            date: currentDate,
            uid: loggedInUser.uid,
            status: 'out',
            businessId: loggedInUser.businessId,
            currentLocation: locationController.text,
            departmentId: lastAttendance.departmentId,
            deviceId: loggedInUser.deviceId.toString(),
          );
          if (isConnected) {
            await databaseHelper.postDataToAPI(records).whenComplete(() async {
              await Future.delayed(const Duration(milliseconds: 200));
              await databaseHelper.postSingleDataToAPI(attendanceRecord);
              deletePairwiseRecords();
            });

            Future.delayed(const Duration(seconds: 2), () {
              log('all records : $records');
            });
          } else {
            return;
          }
        });
        await DatabaseHelper.instance.insertAttendance(
          lastAttendance.copyWith(
            employeeId: matchedEmployee.id,
            employeeName: matchedEmployee.name,
            time: currentTime,
            pin: matchedEmployee.pin,
            date: currentDate,
            uid: loggedInUser.uid,
            status: 'out',
            businessId: loggedInUser.businessId,
            currentLocation: locationController.text,
            departmentId: lastAttendance.departmentId,
            deviceId: loggedInUser.deviceId.toString(),
          ),
        );
      });
      final player = AudioPlayer();
      await player.play(AssetSource('audios/out.mp3'));
      _dismissTimer = Timer(const Duration(seconds: 5), () {
        Navigator.of(context, rootNavigator: true).pop();
      });
    } else {
      if (matchedEmployee.alldepartment!.length > 1) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return DepartmentCard(employee: matchedEmployee);
          },
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            double width = MediaQuery.of(context).size.width;

            return Dialog(
              child: SizedBox(
                width: width > 800 ? width * 0.3 : width * 0.5,
                child: Wrap(
                  children: [
                    Column(children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: Colors.green.shade800,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                ' ${matchedEmployee.name ?? "Unknown"}',
                                style: TextStyle(
                                  fontSize: width < 700 ? 18 : 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 3,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ]),
                  ],
                ),
              ),
            );
          },
        ).whenComplete(() async {
          bool isConnected = await ConnectionFuncs.checkInternetConnectivity();
          String currentTime = DateFormat('HH:mm').format(DateTime.now());
          String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
          int? departmentId = matchedEmployee.alldepartment!.isEmpty
              ? null
              : matchedEmployee.alldepartment![0].department?.id;
          EmployeeAttendance attendanceRecord = EmployeeAttendance(
            employeeId: matchedEmployee.id,
            employeeName: matchedEmployee.name,
            pin: matchedEmployee.pin,
            time: currentTime,
            date: currentDate,
            status: 'in',
            uid: loggedInUser.uid,
            businessId: loggedInUser.businessId,
            currentLocation: locationController.text,
            departmentId: departmentId.toString(),
            deviceId: loggedInUser.deviceId.toString(),
          );
          int id =
              await DatabaseHelper.instance.insertAttendance(attendanceRecord);
          log('Attendance record inserted with ID: $id');
          if (isConnected) {
            await databaseHelper.postDataToAPI(records).whenComplete(() async {
              await Future.delayed(const Duration(milliseconds: 200));
              await databaseHelper.postSingleDataToAPI(attendanceRecord);
              deletePairwiseRecords();
            });
          } else {
            return;
          }
        });

        final player = AudioPlayer();
        await player.play(AssetSource('audios/in.mp3'));
        Future.delayed(const Duration(seconds: 5), () {
          Navigator.of(context, rootNavigator: true).pop();
        });
      }
      resetScanner();
    }
  }

  void _showerrorDailog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return errorDailog(context);
      },
    );

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  errorDailog(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Dialog(
      child: SizedBox(
        width: width > 800 ? width * 0.3 : width * 0.5,
        child: Wrap(
          children: [
            Column(children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.red,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Alert',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 3,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 30,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Invalid User",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: width < 700 ? 20 : 25,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  void resetScanner() {
    if (mounted) {
      setState(() {
        result = null;
        isProcessing = false;
      });
    }
  }

  @override
  void initState() {
    _requestCameraPermission();
    _getCurrentLocation();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: [SystemUiOverlay.bottom]);

    streamSubscription = ConnectionFuncs.checkInternetConnectivityStream()
        .asBroadcastStream()
        .listen((isConnected) async {
      CheckConnection connection =
          BlocProvider.of<CheckConnection>(context, listen: false);
      connection.add(isConnected);
    });

    Timer.periodic(const Duration(minutes: 30), (Timer timer) async {
      bool isConnected = await ConnectionFuncs.checkInternetConnectivity();
      DatabaseHelper databaseHelper = DatabaseHelper.instance;
      List<EmployeeAttendance> records =
          await databaseHelper.getAllAttendanceRecord();
      log('all records : $records');

      if (isConnected && records.isNotEmpty) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     backgroundColor: Color.fromRGBO(30, 60, 87, 1),
        //     content: Text(
        //       'Syncing...',
        //       style:
        //           TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        //     ),
        //     duration: Duration(seconds: 3),
        //   ),
        // );

        await postAllRecordsToAPI(context);
      } else {}
    });
    _loadUserData();
    selectedTime = TimeOfDay.now();
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        setState(() {
          selectedTime = TimeOfDay.now();
        });
      }
    });
    super.initState();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
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

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Reverse geocoding
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    setState(() {
      // ignore: unnecessary_null_comparison
      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        locationController.text =
            '${placemark.name}, ${placemark.subLocality}, ${placemark.locality} ${placemark.postalCode}, ${placemark.administrativeArea}, ${placemark.country}';
        log("Location: ${locationController.text}");
      } else {
        locationController.text = 'Address not found';
      }
    });
  }
  // Future<void> _initDeviceInfo() async {
  //   Map<String, String> deviceInfo = await getDeviceInfo();
  //   String modelName = deviceInfo['modelName'] ?? 'Unknown';
  //   String? macAddress = await getMacAddress();
  //   log('Model Name: $modelName');
  //   log('MAC Address: $macAddress');
  // }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _loadUserData() async {
    await _initPrefs();
    String? userJson = _prefs.getString('loggedInUser');
    if (userJson != null) {
      setState(() {
        user = LoggedInUser.fromJson(jsonDecode(userJson));
        UserLocation = user?.businessName ?? '';
        emailController.text = user?.email ?? '';
      });
    } else {}
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    timer?.cancel();
    controller?.dispose();
    super.dispose();
  }

  Widget qrCodeDailog() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Card(
      child: Container(
        height: height > 800 ? height / 1.85 : height / 1.55,
        width: width > 900 ? width / 3.85 : width / 1.5,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          cameraFacing: CameraFacing.front,
          overlay: QrScannerOverlayShape(
            borderColor: Colors.red,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: width > 900 ? 300 : 400,
          ),
        ),
      ),
    );
  }

  userAttendance() {
    double width = MediaQuery.of(context).size.width;
    if (width > 900) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          qrCodeDailog(),
          const SizedBox(
            width: 20,
          ),
          const EmployeeScreen(),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: toggle ? const EmployeeScreen() : qrCodeDailog(),
          ),
          const SizedBox(height: 50),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String date = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
    // String time = DateFormat('hh:mm a').format(DateTime.now());
    String time = selectedTime.format(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 29, 29, 29),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (width > 900)
                        Expanded(
                          child: Text(
                            textAlign: TextAlign.start,
                            date,
                            style: TextStyle(
                                fontSize: width > 600 ? 30 : 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          ),
                        ),
                      if (width > 900)
                        Expanded(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Center(
                              child: Image(
                                image: const AssetImage(
                                    "assets/images/purple.png"),
                                height: width < 700 ? 140 : 175,
                                width: 400,
                              ),
                            ),
                          ),
                        ),
                      if (width > 900)
                        Expanded(
                          child: Text(
                            textAlign: TextAlign.end,
                            time,
                            style: TextStyle(
                                fontSize: width > 600 ? 30 : 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
                if (width < 900)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: const AssetImage("assets/images/purple.png"),
                        height: width < 700 ? 140 : 175,
                        width: width < 700 ? 200 : 400,
                      ),
                    ],
                  ),
                if (width < 900)
                  Text(
                    time,
                    style: TextStyle(
                        fontSize: width < 700 ? 30 : 50,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                  ),
                if (width < 900)
                  Text(
                    date,
                    style: TextStyle(
                        fontSize: width > 600 ? 30 : 20, color: Colors.white),
                  ),
                SizedBox(height: height > 768 ? height / 50 : height / 30),
                userAttendance(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (width < 900)
                IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    height: 50,
                    width: 50,
                    child: Icon(
                      toggle
                          ? Icons.qr_code_scanner_rounded
                          : Icons.password_rounded,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      toggle = !toggle;
                    });
                  },
                ),
              Expanded(
                child: Text(
                  UserLocation.toUpperCase(),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: width > 600 ? 30 : 20,
                    color: const Color.fromARGB(255, 52, 126, 190),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              BlocBuilder<CheckConnection, bool>(
                builder: (context, isConnected) {
                  return IconButton(
                    onPressed: () {
                      log('status:$isConnected');
                      if (isConnected) {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              LogoutDailog(email: emailController.text),
                        );
                      } else {
                        ConstDialog(context).showErrorDialog(
                          error: "Check Your Internet Connection",
                          title: const Row(
                            children: [
                              Icon(Icons.error, color: Colors.red),
                              SizedBox(width: 8),
                              Text("Alert"),
                            ],
                          ),
                          iconColor: Colors.red,
                        );
                      }
                    },
                    icon: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.power_settings_new_rounded,
                          color: Colors.deepOrange),
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }

  Future<void> postAllRecordsToAPI(BuildContext context) async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    List<EmployeeAttendance> records =
        await databaseHelper.getAllAttendanceRecord();
    log('all records : $records');

    // Show a SnackBar indicating data syncing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color.fromRGBO(30, 60, 87, 1),
        content: Text(
          'Syncing...',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    try {
      await Future.delayed(const Duration(milliseconds: 200));
      await databaseHelper.postDataToAPI(records).whenComplete(
            () => deletePairwiseRecords(),
          );

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    } catch (e) {
      log('Error posting data: $e');
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error syncing data. Please try again later.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void deletePairwiseRecords() async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    List<EmployeeAttendance> records =
        await databaseHelper.getAllAttendanceRecord();
    Map<int, EmployeeAttendance> inRecords = {};
    for (var record in records) {
      if (record.status == "in") {
        inRecords[int.parse(record.employeeId.toString())] = record;
      } else if (record.status == "out") {
        if (inRecords.containsKey(record.employeeId)) {
          EmployeeAttendance inRecord = inRecords[record.employeeId]!;
          try {
            await databaseHelper.deleteAttendance(inRecord.employeeId!);
            await databaseHelper.deleteAttendance(record.employeeId!);
            inRecords.remove(record.employeeId);
          } catch (e) {
            log('Error deleting data: $e');
            continue;
          }
        } else {
          log('No matching "in" record found for "out" record: $record');
        }
      }
    }
  }
}
