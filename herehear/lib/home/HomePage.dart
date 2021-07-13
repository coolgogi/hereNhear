import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/appBar/create_broadcast.dart';
import 'package:herehear/appBar/create_groupcall.dart';
import 'package:herehear/appBar/searchBar.dart';
import 'package:herehear/location_data/location.dart';

class HomePage extends StatelessWidget {
  // String uid;
  //
  // HomePage({this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Herehear'),
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
            'BroadCast',
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 18.0),
            child: Container(
              height: 100.0,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(10, (int index) {
                    return Card(
                        child: Container(
                      width: 110.0,
                      height: 80.0,
                      child: Center(child: Text("${index + 1} 라이브")),
                    ));
                  })),
            ),
          ),
          Text(
            'Group Call',
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 18.0),
            child: Column(
              children: List.generate(15, (int index) {
                return Card(
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
                              '${index + 1} 번째 대화방입니다~',
                              style: TextStyle(fontSize: 17),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '같이 대화하면서 놀아요!!',
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ));
              }),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: null, //사용자 위치 기반으로 데이터 다시 불러오기 및 새로고침
        label: Text(
          '새로 고침',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
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
              onPressed: () => Get.off(() => CreateBroadcastPage()),
            ),
            TextButton(
              child: Text(
                '그룹 대화',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              onPressed: () => Get.off(() => CreateGroupCallPage()),
            ),
          ],
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          CreateBroadcastPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
