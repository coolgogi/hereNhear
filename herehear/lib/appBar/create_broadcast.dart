import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateBroadcastPage extends StatefulWidget {
@override
  _CreateBroadcastPageState createState() => _CreateBroadcastPageState();
}

class _CreateBroadcastPageState extends State<CreateBroadcastPage>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _title = TextEditingController();
  TextEditingController _notice = TextEditingController();

  @override
  void dispose(){
    _title.dispose();
    _notice.dispose();
    super.dispose();
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
      body: Container(
        padding: EdgeInsets.all(16.0),
        key: _formKey,
        child: ListView(
          children: [
            Text('제목'),
            TextFormField(
              controller: _title,
              validator: (value){
                if(value!.trim().isEmpty){
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
          ],
        ),
      )
    );
  }
}
