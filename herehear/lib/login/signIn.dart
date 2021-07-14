import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:herehear/login/siginIn_controller.dart';
import 'package:herehear/login/sms.dart';


class LoginPage extends StatelessWidget {
  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => controller.loginWithGoogle(),
              child: Center(
                  child: Text(
                "Login with google",
                style: TextStyle(color: Colors.black),
              )),
            ),
            TextButton(
              onPressed: () => controller.logoutGoogle(),
              child: Center(
                  child: Text(
                "Login out",
                style: TextStyle(color: Colors.black),
              )),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                builder: (context) =>Sms()
                ));
    },
              child: Center(
                  child: Text(
                    "sms",
                    style: TextStyle(color: Colors.black),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
