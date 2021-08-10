import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:herehear/agora/agoraEventController.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/bottomNavigationBar/bottom_bar.dart';

class GroupCallPage extends StatefulWidget {
  String? _title;
  GroupCallPage(this._title);
  final String channelName = Get.arguments;
  @override
  _GroupCallPageState createState() => _GroupCallPageState(_title);
}

class _GroupCallPageState extends State<GroupCallPage> {
  String? _title;
  _GroupCallPageState(this._title);

  final String channelName = Get.arguments;

  bool alreadyJoin = false;

  late final controller = Get.put(AgoraEventController.groupcall(
      channelName: channelName, role: ClientRole.Broadcaster));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.add),
          color: Colors.black,
          onPressed: null,
        ),
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            _title!,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Noto Sans CJK kr',
              fontWeight: FontWeight.w900,
              fontSize: 18.sp,
            ),
          ),
        ),
        actions: <Widget>[
          //HARD
          Padding(
            padding: EdgeInsets.only(top: 10.0.h, right: 8.0.w),
            child: Column(
              children: <Widget>[
                Icon(Icons.people),
                Text(
                  '999+',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Image.asset(
              'assets/icons/exit.png',
              width: 23.w,
              color: Colors.white,
            ),
            onPressed: () => _onCallEnd(),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 288.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 16.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30.0.h),
                    child: Text(
                      '참여',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19.sp,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Obx(() => _viewRows(_getParticipantsImageList())),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 25.0.h, left: 16.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '관전',
                  style: Theme.of(context).textTheme.headline2,
                ),
                Row(
                  children: <Widget>[
                    Obx(() => _viewRows(_getWatcherImageList())),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomBar(context),
    );
  }

  /// Helper function to get list of native views
  //HARD
  List<Widget> _getParticipantsImageList() {
    final List<Widget> list = [];
    if (controller.isParticipate.value) {
      list.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
            child: Container(
              child: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/you.png'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 14.0, top: 8.0),
            child: Text(
              'USER',
              style: TextStyle(
                  color: controller.isParticipate.value
                      ? Colors.white
                      : Color(0xFF618051)),
            ),
          ),
        ],
      ));
    }
    return list;
  }

  //HARD
  List<Widget> _getWatcherImageList() {
    final List<Widget> list = [];
    if (controller.isParticipate.value == false) {
      list.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
            child: Container(
              child: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/you.png'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 7.0, top: 8.0),
            child: Text(
              'USER',
              style: TextStyle(
                  color: controller.isParticipate.value
                      ? Colors.white
                      : Color(0xFF618051)),
            ),
          ),
        ],
      ));
      print(controller.users.obs);
    }

    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Container(
        child: Center(
      child: view,
    ));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Row(
      children: wrappedViews,
    );
  }

  Widget bottomBar(BuildContext context) {
    return BottomAppBar(
      color: Colors.black,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.0.w, 10.0.w, 10.0.w, 10.0.w),
            child: InkWell(
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Icon(Icons.chat, color: Colors.black),
              ),
              onTap: null,
            ),
          ),
          Expanded(
            child: Container(
              height: 50.h,
            ),
          ),
          Obx(() => Padding(
                padding: EdgeInsets.fromLTRB(10.0.w, 10.0.w, 16.0.w, 10.0.w),
                child: InkWell(
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: controller.muted.value
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                    child: Icon(
                      controller.muted.value ? Icons.mic_off : Icons.mic,
                      color: !alreadyJoin
                          ? Colors.grey
                          : controller.muted.value
                              ? Colors.white
                              : Colors.black,
                      size: 30,
                    ),
                  ),
                  onTap: (() {
                    if (alreadyJoin == true) controller.onToggleMute();
                  }),
                ),
              )),
          Padding(
            padding: EdgeInsets.fromLTRB(10.0.w, 10.0.w, 16.0.w, 10.0.w),
            child: InkWell(
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.pan_tool_outlined,
                  color: Colors.black,
                  size: 28,
                ),
              ),
              onTap: (() {
                setState(() {
                  if (alreadyJoin == false)
                    controller.move_watcher_to_participant();

                  alreadyJoin = true;
                });
              }),
            ),
          )
        ],
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows(List<Widget> userImageList) {
    // final views = _getRenderViews();
    var views = userImageList;
    print('asdfasdf: $views');
    if (views.length == 1) {
      return Container(
          child: Column(
        children: <Widget>[_videoView(views[0])],
      ));
    } else if (views.length <= 5) {
      return Container(
          child: Column(
        children: <Widget>[
          _expandedVideoRow(views.sublist(0, views.length)),
        ],
      ));
    } else if (views.length <= 10) {
      return Container(
          child: Column(
        children: <Widget>[
          _expandedVideoRow(views.sublist(0, 5)),
          _expandedVideoRow(views.sublist(5, views.length - 1))
        ],
      ));
    } else if (views.length <= 15) {
      return Container(
          child: Column(
        children: <Widget>[
          _expandedVideoRow(views.sublist(0, 5)),
          _expandedVideoRow(views.sublist(5, 10)),
          _expandedVideoRow(views.sublist(15, views.length - 1))
        ],
      ));
    } else if (views.length <= 20) {
      return Container(
          child: Column(
        children: <Widget>[
          _expandedVideoRow(views.sublist(0, 5)),
          _expandedVideoRow(views.sublist(5, 10)),
          _expandedVideoRow(views.sublist(10, 15)),
          _expandedVideoRow(views.sublist(15, views.length - 1))
        ],
      ));
    }
    return Container();
  }

  void _onCallEnd() {
    controller.onClose();
    Get.off(() => BottomBar());
  }
}
