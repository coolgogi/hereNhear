import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/main.dart';

class InvitationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(child: Text('익명의 사람으로부터 초대가 왔습니다.')),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0 , 0, 10),
                      child: Text('수락하시겠습니까?'),),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: ElevatedButton(
                            onPressed: () => Get.off(() => LandingPage(),),
                            child: Text("네", style: TextStyle(color: Colors.black),),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.fromLTRB(10, 0 , 0, 0),
                          child: ElevatedButton(
                            onPressed: () => Get.off(() => LandingPage(),),
                            child: Text(
                              "아니요",
                              style: TextStyle(color: Colors.black),
                            ),),
                        ),
                      ]),
                ],
    ),
        ));
  }
}
