import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/groupCall/controllers/group_call_controller.dart';
import 'package:herehear/groupCall/group_call2.dart';
import 'package:herehear/location_data/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

import '../etc/delete/group_call.dart';

class CreateGroupCallPage extends StatefulWidget {
  @override
  _CreateGroupCallPageState createState() => _CreateGroupCallPageState();
}

class _CreateGroupCallPageState extends State<CreateGroupCallPage> {
  User? user = FirebaseAuth.instance.currentUser;
  final _title = TextEditingController();
  final _notice = TextEditingController();
  String? _docId;
  String? _selectedTime;

  DateTime selectedDate = DateTime.now();
  bool _validateError = false;
  final controller = Get.put(GroupCallController());
  final controller2 = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text('새 그룹 대화방',
            style: Theme.of(context).appBarTheme.titleTextStyle),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => {
            Get.back(),
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                '시작시간 예약하기',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(bottom: 10, right: 15),
                    child: GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Icon(Icons.calendar_today, size: 30))),
                Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                        onTap: () {
                          Future<TimeOfDay?> selectedTime = showTimePicker(
                              context: context, initialTime: TimeOfDay.now());
                          selectedTime.then((timeOfDay) {
                            setState(() {
                              _selectedTime =
                                  '${timeOfDay!.hour}: ${timeOfDay.minute}';
                            });
                          });
                        },
                        child: Icon(Icons.access_time, size: 30))),
              ],
            ),
            SizedBox(
              height: 16.0,
            ),
            Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                '제목',
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextFormField(
              controller: _title,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return '제목을 입력해주세요.';
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.fromLTRB(10, 6, 0, 6),
                hintText: '제목을 입력해주세요(15자 이내)',
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            SizedBox(
              height: 16.0,
            ),
            Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                '공지사항',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              padding: EdgeInsets.fromLTRB(15, 1, 10, 0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: Colors.grey,
                  width: 0.7,
                ),
              ),
              child: TextField(
                cursorColor: Theme.of(context).primaryColor,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _notice,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  hintText: '공지를 입력해주세요(100자 이내)',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: 32.0,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    onJoin();
                  },
                  child: Text('방만들기'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> onJoin() async {
    setState(() {
      _title.text.isEmpty ? _validateError = true : _validateError = false;
    });
    // await _handleCameraAndMic(Permission.camera);
    await Permission.microphone.request();
    // await _handleCameraAndMic(Permission.microphone);

    _docId =
        (10000000000000 - DateTime.now().millisecondsSinceEpoch).toString();
    controller.createGroupCallRoom(
        user, _title.text, _notice.text, _docId, controller2.location.value);
    // FirebaseFirestore.instance
    //     .collection("groupcall").doc('_docId').update({"participants": FieldValue.arrayUnion(user.uid)});
    // _docId =(10000000000000- DateTime.now().millisecondsSinceEpoch).toString();
    // controller.createGroupCallRoom(user, _title.text,_notice.text, _docId);
    // // await FirebaseFirestore.instance
    //     .collection("groupcall")
    //     .doc('_docId')
    //     .update({"participants": FieldValue.arrayUnion([user!.uid])});

    Get.off(() => GroupCallPage(_title.text), arguments: _docId);
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print('################: $status');
  }
}
