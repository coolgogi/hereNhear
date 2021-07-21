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
  List<String> categoryList = ['소통', '힐링', 'ASMR','연애','음악','잡담'];
  int _index = 0;
  bool _validateError = false;
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
      body: Container(
        padding: EdgeInsets.all(20),
        key: _formKey,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              height: 16.0,
            ),
            Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                '카테고리',
                style: TextStyle(fontSize: 16),
              ),
            ),

            Row(
              children:
              List.generate(categoryList.length, (index) {
                return Center(
                  child: Container(
                    padding: EdgeInsets.all(3),
                    child: ChoiceChip(
                      label: Text(
                        categoryList[index],
                      ),
                      labelStyle:
                      TextStyle(color: Colors.black),
                      shape: StadiumBorder(side: BorderSide(color: Colors.grey, width: 0.5)),
                      backgroundColor: Colors.white,
                      selected: _index == index,
                      selectedColor: Colors.grey[500],
                      onSelected: (value) {
                        setState(() {
                          _index = value ? index : _index;
                        });
                      },
                      // backgroundColor: color,
                    ),
                  ),
                );
              }
              ),),
            SizedBox(
              height: 32.0,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  print('만들기~~~~~~~~~~');
                },
                child: Text('방만들기'),
              ),
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
