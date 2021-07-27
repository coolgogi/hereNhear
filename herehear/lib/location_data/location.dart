import 'package:get/get.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class LocationController extends GetxController {
  //yr controller
  bool check = true;
  int count = 1;

  void read() {
    check = false;
  }

  void decrement() {
    if (count != 0) {
      count--;
      update();
    }
  }

  ///////////////////////////////////////////////for YR
  // Get.find<ProfileController>()대신에 ProfileController.to ~ 라고 쓸 수 있음
  static LocationController get to => Get.find();
  RxString location = ''.obs;

  // void getCurrentLocation() async {
  //   try {
  //     // print("111!!!");
  //     bool isLocationServiceEnabled =
  //     await Geolocator.isLocationServiceEnabled();
  //     if (isLocationServiceEnabled) {
  //       print("True!!");
  //     } else {
  //       print("False!!");
  //     }
  //     //이 코드는 오류가 날 수 있으니 try catch 로 오류잡기
  //     // print("222!!!");
  //     // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low, timeLimit: Duration(seconds: 10)); <-- 이게 문제였음. 이유는 모르겠음.
  //     Rx<Future<Position>> position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).obs;
  //
  //
  //   } catch (e) {
  //     print("error!!!");
  //     print(e);
  //   }
  //   // return position;
  // }

  @override
  void onInit() async {
    // called immediately after the widget is allocated memory
    locationPermission();
    await getLocation();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> locationPermission() async {
    await Geolocator.requestPermission();
  }

  Future<void> getLocation() async {
    Position? position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint('location: ${position}');
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("detail address : ${first.addressLine}");
    // print("needed address data : ${first.locality} ${first.subLocality}");
    location = '${first.locality} ${first.subLocality}'.obs;
    print('location: $location');
  }
}
