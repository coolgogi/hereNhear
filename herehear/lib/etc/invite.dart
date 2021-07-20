import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/main.dart';

class InvitationPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center( 
            child: Row(
              children: [
                Text('익명의 사람으로부터 초대가 왔습니다. \n 수락하시겠습니까?'),
                  TextButton(
                      onPressed: () => Get.off(() => LandingPage(),),
                      child: Text(
                        "네",
                        style: TextStyle(color: Colors.black),
                      ),),
                TextButton(
                  onPressed: () => Get.off(() => LandingPage(),),
                  child: Text(
                    "아니요",
                    style: TextStyle(color: Colors.black),
                  ),),

              ],
            )
        )
    );
  }

}