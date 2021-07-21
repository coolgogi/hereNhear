import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:herehear/broadcast/broadcast.dart';
import 'package:herehear/broadcast/controllers/broadcast_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateBroadcastPage extends StatefulWidget {
  late Map<String, dynamic> userData;

  CreateBroadcastPage.withData(Map<String, dynamic> uData) {
    this.userData = uData;
  }

  CreateBroadcastPage();

  @override
  _CreateBroadcastPageState createState() => _CreateBroadcastPageState();
}

class _CreateBroadcastPageState extends State<CreateBroadcastPage> {
  User? user = FirebaseAuth.instance.currentUser;
  List<String> categoryList = ['소통', '힐링', '잡담'];
  int _index = 0;
  bool _validateError = false;
  List<bool> _isSelected = List.generate(3, (_) => false);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ClientRole _role = ClientRole.Broadcaster;
  TextEditingController _title = TextEditingController();
  TextEditingController _notice = TextEditingController();
  var _data;

  final controller = Get.put(BroadcastController());

  @override
  void dispose() {
    _title.dispose();
    _notice.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    // 이 클래스애 리스너 추가
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('개인 라이브', style: Theme.of(context).appBarTheme.titleTextStyle),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => {
            Get.back(),
          },
        ),
      ),
      body: SizedBox(
        key: _formKey,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Text('제목'),
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
                hintText: '제목을 입력해주세요(15자 이내)',
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Container(padding: EdgeInsets.all(10), child: Text('카테고리')),
            ToggleButtons(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('소통'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('힐링'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('잡담'),
                ),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < _isSelected.length; i++) {
                    _isSelected[i] = i == index;
                  }
                  _index = index;
                  // if (index == 3) {
                  //   _role = ClientRole.Audience;
                  // } else {
                  //   _role = ClientRole.Broadcaster;
                  // }
                });
              },
              isSelected: _isSelected,
            ),
            Text('공지사항'),
            TextFormField(
              controller: _notice,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '방의 공지를 입력해주세요(100자 이내)',
              ),
            ),
            Stack(
              children: <Widget>[
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      onJoin();
                    },
                    child: Text('방만들기'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    setState(() {
      _title.text.isEmpty ? _validateError = true : _validateError = false;
    });
    await Permission.microphone.request();

    final docId =
        (10000000000000 - DateTime.now().millisecondsSinceEpoch).toString();
    await controller.createBroadcastRoom(
        user,
        _title.text,
        _notice.text,
        categoryList[_index],
        docId,
        widget.userData,
        List<String>.filled(0, '', growable: true));
    await Get.to(
      () => BroadCastPage(
        channelName: docId,
        userName: user!.uid,
        role: ClientRole.Broadcaster,
      ),
    );
  }
}
