import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herehear/bottomNavigationBar/home/groupCallDetail.dart';
import 'package:herehear/broadcast/broadcast_list.dart';
import 'package:herehear/chatting/my_firebase_chat.dart';
import 'package:herehear/groupCall/groupcall_list.dart';
import '../../broadcast/data/broadcast_model.dart' as types;
import 'package:herehear/groupCall/data/group_call_model.dart' as types;

class FoundedResult extends StatelessWidget {
  const FoundedResult({Key? key}) : super(key: key);

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
                  Text("'한동대' 검색결과  ", style: Theme.of(context).textTheme.headline2),
                  Text('총 14건', style: Theme.of(context).textTheme.headline5!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  )),
                ],
              ),
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
                          child: Text('검색 결과가 없습니다.', style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          )),
                        ),
                      );

                    else{
                      return broadcastRoomList(context, snapshot);
                    }
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 36.0.h),
                    child: Text(
                      'HEAR CHAT',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.only(top: 16.0.h, bottom: 50.h),
                child: StreamBuilder<List<types.GroupCallModel>>(
                    stream: MyFirebaseChatCore.instance.groupCallRoomsWithLocation(),
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
                            child: Center(child: Text('검색 결과가 없습니다.', style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            )),
                          ),
                        ));
                      return NotificationListener<OverscrollIndicatorNotification>(
                          onNotification: (overScroll) {
                            overScroll.disallowGlow();
                            return true;
                          },
                          child: groupcallRoomList(context, snapshot));


                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
