import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/bottomNavigationBar/create/create_broadcast.dart';
import '../../appBar/search/search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class Controller extends GetxController {
//
//   @override
//   void onInit() {
//     // called immediately after the widget is allocated memory
//     broadCastList();
//     super.onInit();
//   }
//
//   var broadcastSnapshot;
//   Future<void> broadCastList() async {
//     broadcastSnapshot = await FirebaseFirestore.instance.collection("broadcast").snapshots();
//   }
//
//   StreamController<int> streamController = StreamController<int>();
//   // the path from where our data will be fetched and displayed to used
//   Stream<DocumentSnapshot> doc =      FirebaseFirestore.instance.collection("data").document("counterState").snapshots();
//
//   void StartStream(){
//     doc.listen((event) {
//       // here count is a field name in firestore database
//       streamController.sink.add(event.data()['count']);
//     });
//   }
//
//   @override
//   FutureOr onClose() {
//     streamController.close();
//   }
// }

class Subscribed22Page extends StatelessWidget {
  // String uid;
  //
  // SavedChannelPage({this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscribed'),
        actions: <Widget>[
          IconButton(
              onPressed: _showMyDialog,
              color: Colors.amber,
              icon: Icon(Icons.add_circle)),
          IconButton(
              onPressed: null,
              color: Colors.black87,
              icon: Icon(Icons.notifications_none_outlined)),
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black87,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PostSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        children: <Widget>[
          Text(
            '팔로잉 라이브',
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 18.0),
            child: Container(
              height: 100.0,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("broadcast")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return Container(
                      child: Text('라이브중인 방송이 없습니다.'),
                    );
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: broadcastRoomList(snapshot),
                  );
                  // children: List.generate(10, (int index) {
                  //   return Card(
                  //       child: Container(
                  //     width: 110.0,
                  //     height: 80.0,
                  //     child: Center(child: Text("${index + 1} 라이브")),
                  //   ));
                  // }));
                },
              ),
              // child: GetBuilder<Controller>(
              //   init: Controller(),
              //   builder: (value) {
              //     if(value.broadcastSnapshot == null)
              //       return Container(
              //         child: Text('라이브중인 방송이 없습니다.'),
              //       );
              //     return ListView(
              //         scrollDirection: Axis.horizontal,
              //         children: broadcastRoomList(value.broadcastSnapshot),
              //     );
              //         // children: List.generate(10, (int index) {
              //         //   return Card(
              //         //       child: Container(
              //         //     width: 110.0,
              //         //     height: 80.0,
              //         //     child: Center(child: Text("${index + 1} 라이브")),
              //         //   ));
              //         // }));
              //   }
              // ),
            ),
          ),
          Text(
            '팔로우 중인 카테고리',
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 18.0),
            child: Container(
              height: 35.0,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(3, (int index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextButton(
                        child: Text('카테고리 ${index + 1}'),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red),
                        ))),
                        onPressed: null,
                      ),
                    );
                  })),
            ),
          ),
          Text(
            'My Talk',
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 18.0),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("groupcall")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return Container(
                      child: Center(child: Text('생성된 대화방이 없습니다.')),
                    );
                  return Column(
                    children: groupcallRoomList(snapshot),
                  );
                  // return Column(
                  //   children: List.generate(15, (int index) {
                  //     return Card(
                  //         child: Container(
                  //       // width: MediaQuery.of(context).size.width,
                  //       height: 80.0,
                  //       child: Row(
                  //         children: <Widget>[
                  //           Padding(
                  //             padding: const EdgeInsets.only(
                  //                 left: 13.0, right: 13.0),
                  //             child: Container(
                  //               width: 50.0,
                  //               height: 50.0,
                  //               decoration: BoxDecoration(
                  //                 color: Colors.amber,
                  //                 shape: BoxShape.circle,
                  //               ),
                  //             ),
                  //           ),
                  //           Padding(
                  //             padding: const EdgeInsets.only(top: 10.0),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: <Widget>[
                  //                 Text(
                  //                   '${index + 1} 번째 대화방입니다~',
                  //                   style: TextStyle(fontSize: 17),
                  //                 ),
                  //                 SizedBox(
                  //                   height: 5,
                  //                 ),
                  //                 Text(
                  //                   '같이 대화하면서 놀아요!!',
                  //                   style: TextStyle(fontSize: 12),
                  //                 )
                  //               ],
                  //             ),
                  //           )
                  //         ],
                  //       ),
                  //     ));
                  //   }),
                  // );
                }),
          ),
        ],
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return Get.defaultDialog(
      title: '소리 시작하기',
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextButton(
              child: Text(
                '개인 라이브',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              onPressed: () => Get.off(CreateBroadcastPage()),
            ),
            TextButton(
              child: Text(
                '그룹 대화',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              onPressed: () => Get.off(CreateBroadcastPage()),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> broadcastRoomList(
      AsyncSnapshot<QuerySnapshot> broadcastSnapshot) {
    return broadcastSnapshot.data!.docs.map((room) {
      return Card(
        child: InkWell(
          onTap: () {},
          child: Container(
            width: 110.0,
            height: 80.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(child: Text(room['title'])),
                Center(child: Text(room['notice'])),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> groupcallRoomList(
      AsyncSnapshot<QuerySnapshot> broadcastSnapshot) {
    return broadcastSnapshot.data!.docs.map((room) {
      return Card(
        child: InkWell(
          onTap: () {},
          child: Container(
            // width: MediaQuery.of(context).size.width,
            height: 80.0,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 13.0, right: 13.0),
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        room['title'],
                        style: TextStyle(fontSize: 17),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        room['notice'],
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}
