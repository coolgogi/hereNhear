import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:herehear/broadcast/controllers/broadcast_controller.dart';
import 'package:herehear/login/signIn.dart';
import 'package:herehear/data/posts.dart';

class CreateBroadcastPage extends StatefulWidget {
  @override
  _CreateBroadcastPageState createState() => _CreateBroadcastPageState();
}

class _CreateBroadcastPageState extends State<CreateBroadcastPage> {
  User? user = FirebaseAuth.instance.currentUser;
  List<String> categoryList = ['소통', '힐링', '잡담'];
  int _index = 0;
  List<bool> _isSelected = List.generate(3, (_) => false);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _title = TextEditingController();
  TextEditingController _notice = TextEditingController();

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
        title: Text('Broadcast 방 만들기'),
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
            Text('카테고리'),
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


              onPressed: (int index){
                setState(() {
                  for (int i = 0; i < _isSelected.length; i++) {
                    _isSelected[i] = i == index;
                  }
                  _index = index;
                });
              },
              isSelected: _isSelected,
            ),
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
                    controller.createBroadCastRoom(user,_title.text,_notice.text, categoryList[_index]);
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


}
