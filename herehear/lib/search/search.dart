import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../appBar/create_broadcast.dart';
import '../appBar/searchBar.dart';

class searchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('탐색'),
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
          Row(
            children: <Widget>[
              Text(
                'TOP 라이브',
                style: TextStyle(fontSize: 20),
              ),
              Expanded(child: Container()),
              TextButton(
                  onPressed: null,
                  child: Row(
                    children: <Widget>[
                      Text('더보기'),
                      Icon(Icons.chevron_right),
                    ],
                  ))
            ],
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
          Row(
            children: <Widget>[
              Text(
                '추천 테마',
                style: TextStyle(fontSize: 20),
              ),
              Expanded(child: Container()),
              TextButton(onPressed: null, child: Text('편집'))
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 18.0),
            child: Container(
              height: 35.0,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(10, (int index) {
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
            '카테고리',
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 18.0),
            child: Column(
              children: List.generate(15, (int index) {
                return Container(
                  // width: MediaQuery.of(context).size.width,
                  height: 80.0,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 13.0, right: 13.0),
                        child: Container(
                          width: 70.0,
                          height: 70.0,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${index + 1} 번째 카테고리',
                              style: TextStyle(fontSize: 17),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '~~~~',
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }),
            ),
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
              onPressed: () => Get.off(_createRoute()),
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

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => CreateBroadcastPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
