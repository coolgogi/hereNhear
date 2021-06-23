import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/mypage.dart';

class home extends StatelessWidget {
  final controller = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [
      // list(),
      // write(),
      myPage(),
      myPage(),
      myPage(),
    ];

    return Scaffold(
      appBar: AppBar(title: Text("hereNhear")),
      body: _children[controller.num],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: controller.num,
        onTap: (value) {
          controller.changeNum(value);
        },
        items: [
          BottomNavigationBarItem(
              title: Text('게시글'),
              //icon: Icon(Icons.home_outlined)
              icon: Icon(Icons.checkroom_outlined)),
          BottomNavigationBarItem(
              title: Text('글쓰기'), icon: Icon(Icons.pie_chart_outlined)),
          BottomNavigationBarItem(
              title: Text('마이 페이지'), icon: Icon(Icons.perm_identity)),
        ],
      ),
    );
  }
}

class Controller extends GetxController {
  var num = 0;
  void changeNum(int num) {
    this.num = num;
    update();
  }
}
