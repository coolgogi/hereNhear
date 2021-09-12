import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herehear/bottomNavigationBar/home/scroll_controller.dart';
import 'package:herehear/broadcast/broadcast_list.dart';
import 'package:herehear/chatting/my_firebase_chat.dart';
import '../../broadcast/data/broadcast_model.dart' as types;

class BroadcastDetailPage extends StatelessWidget {
  final _scrollController = Get.put(ScrollOpacityController());

  @override
  Widget build(BuildContext context) {
    _scrollController.onInit();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0.w,
        // centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.onSurface, size: 22.w), onPressed: () => Get.back()),
        title: Row(
          children: [
            Text('HERE 라이브',
                style: Theme.of(context).appBarTheme.titleTextStyle),
            SizedBox(width: 5.w),
            Image.asset('assets/icons/live.png',
                width: 43.w, height: 18.h),
          ],
        ),
        actions: <Widget>[
          IconButton(
              onPressed: null,
              icon: Image.asset('assets/icons/bell.png', height: 17.0.h)),
          IconButton(
              onPressed: null,
              icon: Image.asset('assets/icons/more.png', height: 17.0.h)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() => AnimatedOpacity(
              // key: widgetKey,
                duration: Duration(milliseconds: 1),
                opacity: _scrollController.opacity.value,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 25.0.w,
                      top: 20.0.h,
                      right: 26.0.w,
                      bottom: 20.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Text('원하는 카테고리의 ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3),
                          Text(
                              'HERE 라이브',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1),
                          Text(
                              '를',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3),
                        ],
                      ),
                      Text('찾아보세요.',
                          style: Theme.of(context)
                              .textTheme
                              .headline3),
                    ],
                  ),
                ))),
            SizedBox(height: 300.h,),
            Padding(
              padding: EdgeInsets.only(left: 26.0.w, top: 20.0.h, right: 28.w, bottom: 30.h),
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
                  return broadcastRoomVerticalList(context, snapshot);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
