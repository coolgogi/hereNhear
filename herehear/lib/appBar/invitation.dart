import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:herehear/theme/colors.dart';

class invite extends StatefulWidget {
  @override
  inviteState createState() => inviteState();
}

class inviteState extends State<invite> {
  List<bool> isChecked = List.filled(5, false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('친구초대'), backgroundColor: PrimaryColorLight),
      body: invitationList(context),
    );
  }

  Widget invitationList(BuildContext context) {
    return Column(
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
        ),
        TextButton(
          child: Text('보내기'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
