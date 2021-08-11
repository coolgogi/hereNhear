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

  Future<void> locationPermission() async {
    await Geolocator.requestPermission();
  }

  Future<String> getLocation() async {
    Position? position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint('location: $position');
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("detail address : ${first.addressLine}");
    // print("needed address data : ${first.locality} ${first.subLocality}");
    location = '${first.locality} ${first.subLocality}'.obs;
    print('location: $location');
    return location.value;
  }
}
