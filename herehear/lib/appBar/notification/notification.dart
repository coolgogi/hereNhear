import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/location/controller/location_controller.dart';

class NotificationPage extends StatelessWidget {
  final controller = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.delete),
        ),
        title: Text(
          '알림',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: controller.check ? Colors.blue[50] : Colors.blue[0],
              child: ListTile(
                onTap: () {
                  controller.read();
                  controller.decrement();
                  _showMyDialog();
                },
                leading: Icon(
                  Icons.email_outlined,
                  size: 30,
                ),
                title: Text('친구로부터 10:00PM에 예약된 단체톡 방에 초대되었습니다 '),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return Get.defaultDialog(
      title: '시작 시간은 10:00PM 입니다!',
      content: SingleChildScrollView(
            child: TextButton(
              child: Text(
                '나가기',
                style: TextStyle(color: Colors.black87),
              ),
              onPressed: () => Get.back(),
            ),

      ),
    );
  }
}

