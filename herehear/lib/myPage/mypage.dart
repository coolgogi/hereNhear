import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:herehear/subscribed/subscribed.dart';
import 'package:image_picker/image_picker.dart';
import '../login/signIn.dart';

class myPage extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Map<String, dynamic> _user;
  myPage.withData(Map<String, dynamic> data) {
    _user = data;
    // print(_data['nickName']);
    // print(_data['uid']);
    // print(_data['profile']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
         // elevation: 0,
          title: Text(
            '마이페이지', style: Theme.of(context).appBarTheme.titleTextStyle
          ),
        ),
        body: Padding(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: ListView(
              children: <Widget>[
                _profile(context),
                _divier(),
                ListTile(
                  title: Text('회원정보 수정'),
                  onTap: () {
                    Get.to(LoginPage());
                  },
                ),
                ListTile(
                  title: Text('구독 정보'),
                  onTap: () {
                    Get.to(() => SubscribedPage.withData(_user));
                  },
                ),
                _divier(),
                ListTile(
                  title: Text('현재 버전 0.0.5'),
                  onTap: () {
                   // Get.to(LoginPage());
                  },
                ),
                ListTile(
                  title: Text('실험'),
                  onTap: () {
                  //  FirebaseAuth.instance.signOut();
                  },
                ),
                _divier(),
                ListTile(
                  title: Text('공지사항'),
                  onTap: () {
                    //Get.to(LoginPage());
                  },
                ),
                ListTile(
                  title: Text('자주 묻는 질문'),
                  onTap: () {
                    //Get.to(LoginPage());
                  },
                ),
                ListTile(
                  title: Text('문의하기'),
                  onTap: () {
                    //Get.to(LoginPage());
                  },
                ),
                ListTile(
                  title: Text('로그아웃'),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                  },
                ),
                ListTile(
                  title: Text('회원탈퇴'),
                  onTap: () {
                    //Get.to(LoginPage());
                  },
                ),
                _divier(),
                ListTile(
                  title: Text('로그인 페이지'),
                  onTap: () {
                    Get.to(LoginPage());
                  },
                ),
                ListTile(
                  title: Text('로그아웃'),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                  },
                ),
                _divier(),

                _info(),
              ],
            )));
  }

  Widget _divier() {
    return Divider(
      color: Colors.grey[300],
      height: 10,
      thickness: 7,
      indent: 0,
      endIndent: 0,
    );
  }

  Widget _info() {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 10, 20),
      child: Row(
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
              child: Text(
                '서비스 이용 약관',
                style: TextStyle(color: Colors.grey, fontSize: 10),
              )),
          Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
              child: Text(
                '개인정보 처리방침',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              )),
        ],
      ),
    );
  }
  Widget imageProfile(BuildContext context){
    return Center(
        child:Stack(
          children: <Widget>[
            CircleAvatar(
              radius:60,
              backgroundImage:
              _user['profile'] == null
                  ? AssetImage('assets/images/you.png')
                  : AssetImage(_user['profile']) as ImageProvider ,
                  //: NetworkImage(_user['profile']) as ImageProvider ,
            ),
            Positioned(
              bottom:0,
              right:0,
              child: InkWell(
                  onTap:(){
                    //showOptionsDialog(context);
                    //showModalBottomSheet(context: context, builder: ((builder) => bottomSheet()));
                  },
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size:35,
                  )
              ),
            )
          ],
        )
    );
  }

  Widget _profile(BuildContext context) {
    return Column(
      children: [
           imageProfile(context),
        Container(
          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: _user['nickName'] != null ? Text(_user['nickName'],style: TextStyle(fontWeight: FontWeight.bold),)
              : Text('noUser')
        )
      ],
    );
  }
  //
  // Future<void> showOptionsDialog(BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Center(child: Text("프로필 사진")),
  //           content: SingleChildScrollView(
  //             child: ListBody(
  //               children: [
  //                 GestureDetector(
  //                   child: Center(child: Text("카메라")),
  //                   onTap: ()  {
  //                     takePhoto(ImageSource.camera);
  //                   },
  //                 ),
  //                 Padding(padding: EdgeInsets.all(10)),
  //                 GestureDetector(
  //                   child: Center(child: Text("갤러리")),
  //                   onTap: () {
  //                     takePhoto(ImageSource.gallery);
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }
  //
  // takePhoto(ImageSource source) async {
  //   final now = FieldValue.serverTimestamp();
  //   final pickedFile = await _picker.getImage(source:source);
  //   setState(() {
  //     _imageFile = pickedFile;
  //   });
  //
  //   if(_imageFile != null){
  //     await storage
  //         .ref()
  //         .child('user/${docId}/')
  //         .putFile(File(_imageFile.path));
  //
  //     imageURL = await firebase_storage.FirebaseStorage.instance
  //         .ref()
  //         .child('products/${_productNameController.text}')
  //         .getDownloadURL();
  //   }
  //   Navigator.of(context).pop();
  // }
  //


  Widget nameTextField() {
    return TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          prefixIcon: Icon(
            Icons.person,
            color: Colors.black,
          ),
          labelText: 'Name',
          hintText: 'Input your name'),
    );
  }
}
