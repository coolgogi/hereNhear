import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herehear/broadcast/broadcast_list.dart';
import 'package:herehear/chatting/my_firebase_chat.dart';
import '../../broadcast/data/broadcast_model.dart' as types;

class CategoryDetailPage extends StatelessWidget {

  String caterory = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 25.0.w,
        centerTitle: true,
        title: Text(caterory,
            style: Theme.of(context).appBarTheme.titleTextStyle),
        actions: <Widget>[
          IconButton(
              onPressed: null,
              icon: Image.asset('assets/icons/bell.png', height: 17.0.h)),
          IconButton(
              onPressed: null,
              icon: Image.asset('assets/icons/more.png', height: 17.0.h)),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 31.0.w, top: 20.0.h, right: 30.w, bottom: 30.h),
        child: StreamBuilder<List<types.BroadcastModel>>(
          stream: MyFirebaseChatCore.instance.broadcastRoomsWithLocation(),
          initialData: const [],
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ));
            }
            if (snapshot.data!.isEmpty)
              return Padding(
                padding: EdgeInsets.only(top: 50.0.h),
                child: Container(
                  child: Text('라이브중인 방송이 없습니다.'),
                ),
              );
            return broadcastRoomList(context, snapshot);
          },
        ),
      ),
    );
  }
}
