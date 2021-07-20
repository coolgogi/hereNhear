import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/groupCall/controllers/group_call_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

import '../groupCall/group_call.dart';

class CreateGroupCallPage extends StatefulWidget {
  @override
  _CreateGroupCallPageState createState() => _CreateGroupCallPageState();
}

class _CreateGroupCallPageState extends State<CreateGroupCallPage> {
  User? user = FirebaseAuth.instance.currentUser;
  final _title = TextEditingController();
  final _notice = TextEditingController();
  String? _docId ;
  bool _validateError = false;
  final controller = Get.put(GroupCallController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Agora Group Video Calling'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Container(
                //   child: Image.asset('assets/agora-logo.png'),
                //   height: MediaQuery.of(context).size.height * 0.1,
                // ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  'Agora Group Video Call Demo',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: _textFieldCustom(_title,'방 제목' , '제목 힌트', '텍스트 에러'),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: _textFieldCustom(_notice,'방 공지' , '공지 힌트', '텍스트 에러'),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 30)),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: MaterialButton(
                    onPressed: onJoin,
                    height: 40,
                    color: Colors.blueAccent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Join',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textFieldCustom(TextEditingController controller, String title, String hint, String? errorText){
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        labelStyle: TextStyle(color: Colors.blue),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.black45),
        errorText:
        _validateError ? errorText : null,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(20),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    setState(() {
      _title.text.isEmpty
          ? _validateError = true
          : _validateError = false;

    });
    // await _handleCameraAndMic(Permission.camera);
    await Permission.microphone.request();
    // await _handleCameraAndMic(Permission.microphone);

    _docId =(10000000000000- DateTime.now().millisecondsSinceEpoch).toString();
    controller.createGroupCallRoom(user, _title.text,_notice.text, _docId);
    // FirebaseFirestore.instance
    //     .collection("groupcall").doc('_docId').update({"participants": FieldValue.arrayUnion(user.uid)});
    Get.to(() => GroupCallPage(), arguments: _docId);
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print('################: $status');
  }
}
