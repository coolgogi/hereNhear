import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class invite extends StatefulWidget {
  @override
  inviteState createState() => inviteState();
}

class inviteState extends State<invite> {
  @override
  Widget build(BuildContext context) {
    return invitation(context);
  }

  Widget invitation(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 32.0,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              invitationDialog(context);
            },
            child: Text('친구 초대'),
          ),
        ),
      ],
    );
  }

  Future<dynamic> invitationDialog(BuildContext context) {
    List<bool> isChecked = List.filled(5, false);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("친구 초대"),
          content: Column(
            children: [
              Row(
                children: [
                  Text('김한동'),
                  Checkbox(
                    value: isChecked[0],
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked[0] = value!;
                      });
                    },
                  )
                ],
              ),
              Row(
                children: [
                  Text('박한동'),
                  Checkbox(
                    value: isChecked[1],
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked[1] = value!;
                      });
                    },
                  )
                ],
              ),
              Row(
                children: [
                  Text('최한동'),
                  Checkbox(
                    value: isChecked[2],
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked[2] = value!;
                      });
                    },
                  )
                ],
              ),
              Row(
                children: [
                  Text('이한동'),
                  Checkbox(
                    value: isChecked[3],
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked[3] = value!;
                      });
                    },
                  )
                ],
              ),
              Row(
                children: [
                  Text('한동이'),
                  Checkbox(
                    value: isChecked[4],
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked[4] = value!;
                      });
                    },
                  )
                ],
              )
            ],
          ),
          actions: <Widget>[
            new TextButton(
              child: Text("보내기"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
