import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/upload.dart';

import 'comments.dart';

class FeedPage extends StatefulWidget {

  var user_tag;
  var doc;

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  Map<String, dynamic>  data;
  final snackBar1 = SnackBar(content: Text('I LIKE IT!'));
  final snackBar2 = SnackBar(content: Text('You can only do it once!!'));
  int likeNum;
  String selectedPostID = '';
  String displayName = '';
  String userPhotoURL = '';
  var userDoc;
  var user_tag;

  var currentUserDoc;
  String currentUserDisplayName = '';
  String currentUserPhotoURL = '';

  int n = 0;

  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid;

  @override
  initState() {
    super.initState();
    input();
  }

  Future input() async {
    final User user = auth.currentUser;
    uid = user.uid;
  }


  void deleteDoc(var doc) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(doc['docID']).delete();
      if(doc['imageURL'] != "") await FirebaseStorage.instance.ref().child('posts/${doc['imageURL']}').delete();
      Get.back();
    } catch(e) {
      print('권한 없음');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('수 다', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.black87),
            onPressed: () {
              Get.to(UploadPage());
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("posts").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return Text("There is no expense");
            // selectedItemData(context, snapshot);
            print('selectedItemData: ${data}');
            return FutureBuilder(
                future: FirebaseFirestore.instance.collection("users").get(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot2) {
                  if(!snapshot2.hasData) return Container();
                  currentUserDoc = snapshot2.data.docs.where((element) => element['uid'] == uid);
                  currentUserDisplayName = currentUserDoc.first.get('displayname');
                  currentUserPhotoURL = currentUserDoc.first.get('userPhotoURL');
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: postList(context, snapshot, snapshot2),
                        ),
                      ],
                    ),
                  );
                }
            );
          }
      ),
    );
  }

  // void selectedItemData (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //   try {
  //     var item = snapshot.data.docs.where((element) => element['docID'] == doc['docID']);
  //     print("asdf: ${item.first.data()}");
  //     data = item.first.data();
  //   } catch(error) {
  //     print(error);
  //   }
  // }

  List<Widget> postList (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot2) {
    try {
      return snapshot1.data.docs
      // .where((element) => element['docID'] != selectedPostID)
          .map((doc2) {
        if(snapshot1.hasData) {
          // if(doc['docID'] == doc2['docID']) {
          //   doc = doc2;
          //   return Container();
          // }
          // print(snapshot1.data.docs.single.toString());
          userDoc = snapshot2.data.docs.toList().where((element) => element['uid'] == doc2['uid']).single.data();
          // print('userDoc!!!: ${userDoc['displayname']}');
          displayName = userDoc['displayname'];
          userPhotoURL = userDoc['userPhotoURL'];
          Map<String, dynamic> dataMap = doc2.data();
          return postItem(dataMap, doc2, displayName, userPhotoURL);
        }
      }).toList();
    } catch(error) {
      print(error);
    }
  }

  Widget postItem(Map<String, dynamic> data, QueryDocumentSnapshot<Object> doc2, String displayName, String userPhotoURL) {
    if(doc2['imageURL'] == '') {
      return Column(
        children: <Widget>[
          postTopBar(doc2),
          Container(
              height: MediaQuery.of(context).size.height * 0.5,
              color: Theme.of(context).colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                      doc2['description'],
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.black87
                        // color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 5,
                    )),
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: <Widget>[
                  IconButton(
                      icon: likeIcon(data),
                      onPressed: () {
                        bool flag = true;

                        var dataList = data.values.toList();
                        var keyList = data.keys.toList();
                        int tempLength = data.length;
                        for (int i = 0; i < tempLength; i++){
                          print(dataList[i]);

                          if (uid == dataList[i].toString()){
                            if ((keyList[i] == "uid") || (keyList[i].contains('scrap_user'))){
                              continue;
                            }
                            flag = false;
                            print("같음");
                            break;
                          }
                        }

                        // 변경가능.
                        if (flag == true){
                          print("변경가능");

                          likeData(doc2);

                          setState(() async {
                            n++;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content : Text("I Like it !!"),
                            duration: const Duration(seconds: 2),
                          )
                          );
                        }
                        else{
                          print("변경불가");
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content : Text("You can only do it once !!"),
                            duration: const Duration(seconds: 2),
                          )
                          );
                        }
                      }),
                  Text(doc2['likeNum'].toString(), style: TextStyle(fontSize: 18, color: Colors.grey),),
                  SizedBox(width: 10,),
                  IconButton(icon: Icon(Icons.question_answer), onPressed: () {
                    Get.to(CommentPage());
                  }),
                  Expanded(
                    child: Container(),
                  ),
                  IconButton(
                      icon: ScrapIcon(data),
                      onPressed: () {
                        ScrapData(doc2);
                        setState(() {
                          n += 1;
                        });
                      }),
                ],
              ),
              SizedBox(height: 10),
              Divider(
                height: 5,
              ),
              SizedBox(height: 10),
              // Padding(
              //   padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              //   child: Text(
              //     doc2['description'],
              //     style: TextStyle(fontSize: 15),
              //   ),
              // ),
              SizedBox(height: 30,),
              Divider(),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          postTopBar(doc2),
          Image.network(
            doc2['imageURL'],
            width: MediaQuery.of(context).size.width,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: <Widget>[
                  IconButton(
                      icon: likeIcon(data),
                      onPressed: () {
                        bool flag = true;

                        var dataList = data.values.toList();
                        var keyList = data.keys.toList();
                        int tempLength = data.length;
                        for (int i = 0; i < tempLength; i++){
                          print(dataList[i]);

                          if (uid == dataList[i].toString()){
                            if ((keyList[i] == "uid") || (keyList[i].contains('scrap_user'))){
                              continue;
                            }
                            flag = false;
                            print("같음");
                            break;
                          }
                        }

                        // 변경가능.
                        if (flag == true){
                          print("변경가능");

                          likeData(doc2);

                          setState(() async {
                            n++;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content : Text("I Like it !!"),
                            duration: const Duration(seconds: 2),
                          )
                          );
                        }
                        else{
                          print("변경불가");
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content : Text("You can only do it once !!"),
                            duration: const Duration(seconds: 2),
                          )
                          );
                        }
                      }),
                  Text(doc2['likeNum'].toString(), style: TextStyle(fontSize: 18, color: Colors.grey),),
                  SizedBox(width: 10,),
                  IconButton(icon: Icon(Icons.question_answer), onPressed: () {
                    Get.to(CommentPage(doc: doc2, uid: uid));
                  }),
                  Expanded(
                    child: Container(),
                  ),
                  IconButton(
                      icon: ScrapIcon(data),
                      onPressed: () {
                        ScrapData(doc2);
                        setState(() {
                          n += 1;
                        });
                      }),
                ],
              ),
              SizedBox(height: 10),
              Divider(
                height: 5,
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Text(
                  doc2['description'],
                  style: TextStyle(fontSize: 15),
                ),
              ),
              SizedBox(height: 30,),
              Divider(thickness: 1.5,),
            ],
          ),
        ],
      );
    }
  }

  Widget postTopBar(QueryDocumentSnapshot<Object> doc) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(userPhotoURL),
                  fit: BoxFit.fill
              ),
            ),
          ),
        ),
        SizedBox(width: 8,),
        Text(displayName, style: TextStyle(fontSize: 17),),
        Expanded(child: Container()),
        IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              if(doc['uid'] == uid) {
                // Get.to(UpdataPage());
              }
              else {
                final snackBar = SnackBar(
                  content: Text('게시글의 작성자만 수정할 수 있습니다.'),
                  duration: Duration(seconds: 1),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            }),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            if(doc['uid'] == uid) {
              _showMyDialog(doc);
            }
            else {
              final snackBar = SnackBar(
                content: Text('게시글의 작성자만 삭제할 수 있습니다.'),
                duration: Duration(seconds: 1),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
        ),
      ],
    );
  }

  Future<void> _showMyDialog(QueryDocumentSnapshot<Object> doc) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Alert'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('게시물을 삭제하시겠습니까?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () async {
                print('Confirmed');
                await deleteDoc(doc);
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget likeIcon(Map<String, dynamic> data){
    var dataList = data.values.toList();
    var keyList = data.keys.toList();
    int tempLength = data.length;
    for (int i = 0; i < tempLength; i++){

      if (uid == dataList[i].toString()){
        if ((keyList[i] == "uid") || (keyList[i].contains('scrap_user'))){
          continue;
        }
        return Icon(Icons.favorite, color: Colors.red);
      }
    }
    return Icon(Icons.favorite_outline);
  }

  likeData(QueryDocumentSnapshot<Object> doc) async {
    String field_name = "like_user" + (doc['likeNum'] + 1).toString();
    print(field_name);

    int likeNum = doc['likeNum'] + 1;

    FirebaseFirestore.instance.collection('posts').doc(doc['docID']).update({
      field_name : uid,
      'likeNum' : likeNum,
    }).whenComplete(() => print('완료!!'));
  }

  ScrapData(QueryDocumentSnapshot<Object> doc) async{
    String field_name = "scrap_user" + (doc['scrapNum'] + 1).toString();
    print(field_name);

    int scrapNum = doc['scrapNum'] + 1;

    FirebaseFirestore.instance.collection('posts').doc(doc['docID']).update({
      field_name : uid,
      'scrapNum' : scrapNum,
    }).whenComplete(() => print('완료!!'));

    FirebaseFirestore.instance.collection("users")
        .doc(uid).update({
      'Scrap' : FieldValue.arrayUnion([doc.id]) // doc.id는 게시글의 id를 잡아줌.
    });
  }

  Widget ScrapIcon(Map<String, dynamic> data){
    var dataList = data.values.toList();
    var keyList = data.keys.toList();
    int tempLength = data.length;
    for (int i = 0; i < tempLength; i++){
      if (uid == dataList[i].toString()){
        print('keyList[i]: ${keyList[i].toString()}');
        print('dataList[i]: ${dataList[i].toString()}');
        print('uid: ${uid}');
        if ((keyList[i] == "uid") || (keyList[i].contains('like_user'))){
          print('ooooooooooooooooooooooooooooooooooooooooooooooooooo');
          continue;
        }
        return Icon(Icons.star, color: Colors.yellow);
      }
    }
    return Icon(Icons.star_outline, color: Colors.yellow);
  }
}