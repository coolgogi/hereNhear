import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/appBar/drawer/drawer.dart';
import 'package:herehear/bottomNavigationBar/search/categoryDetail.dart';
import 'package:herehear/bottomNavigationBar/search/searchBar_controller.dart';
import 'package:herehear/bottomNavigationBar/search/search_results.dart';
import 'package:herehear/broadcast/broadcast_list.dart';
import '../../broadcast/data/broadcast_model.dart';
import 'package:herehear/chatting/my_firebase_chat.dart';
import 'package:herehear/location/controller/location_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herehear/appBar/drawer/drawer.dart';

List<Widget> action_widget(GlobalKey<ScaffoldState> _key) {
  return <Widget>[
    IconButton(
        onPressed: null,
        icon: Image.asset('assets/icons/bell.png', height: 18.0.h)),
    IconButton(
        onPressed: () => _key.currentState!.openEndDrawer(),
        icon: Image.asset('assets/icons/more.png', height: 17.0.h)),
  ];
}
