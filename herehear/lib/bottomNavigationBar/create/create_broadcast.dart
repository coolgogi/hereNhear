import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:herehear/agora/agoraCreateController.dart';
import 'package:herehear/broadcast/broadcast.dart';
import 'package:herehear/location/controller/location_controller.dart';
import 'package:herehear/users/controller/user_controller.dart';
import 'package:herehear/users/data/user_model.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateBroadcastPage extends StatefulWidget {
  late UserModel userData;

  CreateBroadcastPage.withData(UserModel uData) {
    this.userData = uData;
  }

  CreateBroadcastPage();

  @override
  _CreateBroadcastPageState createState() => _CreateBroadcastPageState();
}

class _CreateBroadcastPageState extends State<CreateBroadcastPage> {
  List<String> categoryList = ['소통', '힐링', 'ASMR', '연애', '음악'];
  int _index = -1;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _notice = TextEditingController();
  String _docId = '';
  //unused variable
  ClientRole _role = ClientRole.Broadcaster;
  bool _validateError = false;


  final agoraController = Get.put(agoraCreateController());
  final locationController = Get.put(LocationController());

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text('새 라이브 방송',
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
              children: List.generate(categoryList.length, (index) {
                return Center(
                  child: Container(
                    padding: EdgeInsets.all(3),
                    child: ChoiceChip(
                      label: Text(
                        categoryList[index],
                      ),
                      labelStyle: TextStyle(color: Colors.black),
                      shape: StadiumBorder(
                          side: BorderSide(color: Colors.grey, width: 0.5)),
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
              }),
            ),
            SizedBox(
              height: 32.0,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  onJoin();
                },
                child: Text('방만들기'),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 32.0,
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

    _docId =
        (10000000000000 - DateTime.now().millisecondsSinceEpoch).toString();
    print('=========================host profile========================');
    print(UserController.to.myProfile.value.profile);
    print('======================================================');

    agoraController.createBroadcastRoom(
      UserController.to.myProfile.value,
      _title.text,
      _notice.text,
      categoryList[_index],
      _docId,
      List<String>.filled(0, '', growable: true),
      locationController.location.value,
    );

    print('==============ddddddddddddddddaaata======================');
    print(_docId);
    print(UserController.to.myProfile.value.profile);
    print('====================================');
    Get.off(
      () => BroadCastPage.broadcaster(
        channelName: _docId,
        role: ClientRole.Broadcaster,
        userData: UserController.to.myProfile.value,
      ),
    );
  }
}
