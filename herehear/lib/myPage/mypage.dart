import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../login/login.dart';
class myPage extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            '마이페이지',
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: ListView(
              children: <Widget>[
                _profile(),
                _divier(),
                ListTile(
                  title: Text('회원정보 수정'),
                ),
                ListTile(
                  title: Text('성별, 신체 사이즈 정보'),
                ),
                ListTile(
                  title: Text('로그아웃'),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                  },
                ),
                _divier(),
                ListTile(
                  title: Text(
                    '실험실',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
                ListTile(
                  title: Text('현재 버전'),
                  onTap: () {
          
                  },
                ),
                ListTile(
                  title: Text('설정'),
                ),
                _divier(),
                ListTile(
                  title: Text(
                    '고객센터',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
                ListTile(
                  title: Text('공지사항'),
                ),
                ListTile(
                  title: Text('앱 문의 건의'),
                ),
                _divier(),
                _info(),
              ],
            )));
  }

  Widget _divier() {
    return Divider(
      color: Colors.grey,
      height: 10,
      thickness: 10,
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

  Widget _profile() {
    return Column(
      children: [
        //   imageProfile(),
        Container(
          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: Text('id'),
        )
      ],
    );
  }
  //
  // Widget imageProfile() {
  //   return Center(
  //       child: Stack(
  //         children: <Widget>[
  //           CircleAvatar(
  //             radius: 80,
  //             backgroundImage: data()['profileImage'] == null
  //                 ? AssetImage('assets/profile.jpg')
  //                 : NetworkImage(data()['profileImage']),
  //           ),
  //           Positioned(
  //             bottom: 20,
  //             right: 20,
  //             child: InkWell(
  //                 onTap: () {
  //                   showOptionsDialog(context);
  //                   //showModalBottomSheet(context: context, builder: ((builder) => bottomSheet()));
  //                 },
  //                 child: Icon(
  //                   Icons.camera_alt,
  //                   color: Colors.black,
  //                   size: 40,
  //                 )
  //             ),
  //           )
  //         ],
  //       )
  //   );
  // }

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

/*
  Widget bottomSheet(){
    return Container(
      height:100,
      width:MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal:20,
        vertical: 50,
      ),
      child: Column(
        children: <Widget>[
          Text(
            'Choose Profile photo',
            style: TextStyle(
              fontSize:20,
            ),
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton.icon(
                icon:Icon(Icons.camera, size:50),
                onPressed:(){
                  takePhoto(ImageSource.camera);
                },
                label:Text('Camera', style: TextStyle(fontSize:20),),
              ),
              TextButton.icon(
                  onPressed: (){
                    takePhoto(ImageSource.gallery);
                    },
                  icon: Icon(Icons.photo_library, size:50,),
                  label: Text('Gallery', style: TextStyle(fontSize:20),),
              )
            ],
          )
        ]
      )
    );
  }

 */
