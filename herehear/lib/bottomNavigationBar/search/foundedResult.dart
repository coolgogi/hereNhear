import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herehear/bottomNavigationBar/home/groupCallDetail.dart';
import 'package:herehear/bottomNavigationBar/search/searchBar_controller.dart';
import 'package:herehear/broadcast/broadcast_list.dart';
import 'package:herehear/broadcast/data/broadcast_model.dart';
import 'package:herehear/chatting/my_firebase_chat.dart';
import 'package:herehear/groupCall/data/group_call_model.dart';
import 'package:herehear/groupCall/groupcall_list.dart';
import '../../broadcast/data/broadcast_model.dart' as types;
import 'package:herehear/groupCall/data/group_call_model.dart' as types;

class FoundedResult extends StatelessWidget {
  AsyncSnapshot<List<BroadcastModel>>? broadcastData;
  AsyncSnapshot<List<GroupCallModel>>? groupcallData;

  FoundedResult({this.broadcastData, this.groupcallData});

  final searchController = Get.put(SearchBarController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(thickness: 3.h),
        Padding(
          padding: EdgeInsets.fromLTRB(26.w, 15.h, 15.w, 20.h),
          child: Column(
            children: [
              Row(
                children: [
                  Text("'${searchController.text.value}' 검색결과  ", style: Theme.of(context).textTheme.headline2),
                  Text('총 건', style: Theme.of(context).textTheme.headline5!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  )),
                ],
              ),
              broadcastData!.data!.isNotEmpty?
              Column(
                children: [
                  SizedBox(height: 27.h),
                  Row(
                    children: [
                      Text('HERE 라이브', style: Theme.of(context).textTheme.headline1),
                      SizedBox(width: 10.w),
                      Image.asset('assets/icons/live.png',
                          width: 43.w, height: 18.h),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Container(
                    height: 200.0.h,
                    child: broadcastRoomList(context, broadcastData!),
                  ),
                ],
              ) : Container(),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 27.0.h),
                        child: Text(
                          'HEAR CHAT',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 16.0.h, bottom: 50.h),
                      child: NotificationListener<OverscrollIndicatorNotification>(
                          onNotification: (overScroll) {
                            overScroll.disallowGlow();
                            return true;
                          },
                          child: groupcallRoomList(context, groupcallData!))
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
