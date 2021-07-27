// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:herehear/main.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class UploadPage extends StatefulWidget {
//   @override
//   _UploadPageState createState() => _UploadPageState();
// }
//
// class _UploadPageState extends State<UploadPage> {
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   late String _CategoryValue;
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   late String uid;
//
//   @override
//   initState() {
//     input();
//   }
//
//   Future input() async {
//     final User? user = auth.currentUser;
//     uid = user!.uid;
//   }
//
//   Future uploadToFirebase() async {
//     String docID = Timestamp.now().seconds.toString();
//     final now = FieldValue.serverTimestamp();
//
//     Map<String, dynamic> data = {
//       'title': titleController.text,
//       'description': descriptionController.text,
//       'uid': uid,
//       'generatedTime': now,
//       'category': _CategoryValue,
//     };
//
//     await FirebaseFirestore.instance.collection('posts').doc(docID).set(data);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(
//             Icons.close,
//             color: Colors.redAccent,
//             size: 25,
//           ),
//           onPressed: () {
//             Get.back();
//           },
//         ),
//         title: Center(
//             child: Text(
//           '새 게시물',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         )),
//         actions: [
//           IconButton(
//               icon: Icon(
//                 Icons.done,
//                 color: Colors.greenAccent[700],
//                 size: 25,
//               ),
//               onPressed: () {
//                 uploadToFirebase().then((value) {
//                   Get.offAll(
//                     LandingPage(),
//                   );
//                 });
//               })
//         ],
//       ),
//       body: ListView(
//         children: <Widget>[
//           Row(
//             children: <Widget>[
//               SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.65,
//               ),
//               DropdownButton(
//                 hint: _CategoryValue == null
//                     ? Text('카테고리')
//                     : Text(
//                         _CategoryValue,
//                         style: TextStyle(color: Colors.black87),
//                       ),
//                 // isExpanded: true,
//                 iconSize: 30.0,
//                 style: TextStyle(color: Colors.black87),
//                 items: ['한동대학교 공지', '총학생회', '자치회', '동아리', '한동장터', '분실물'].map(
//                   (val) {
//                     return DropdownMenuItem<String>(
//                       value: val,
//                       child: Text(val),
//                     );
//                   },
//                 ).toList(),
//                 onChanged: (val) {
//                   setState(
//                     () {
//                       _CategoryValue = val.toString();
//                     },
//                   );
//                 },
//               ),
//             ],
//           ),
//           Divider(
//             height: 5,
//             thickness: 1,
//           ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(24, 8, 24, 5),
//             child: TextFormField(
//               autofocus: true,
//               controller: titleController,
//               keyboardType: TextInputType.text,
//               maxLines: 1,
//               decoration: InputDecoration(
//                   border: InputBorder.none, hintText: "제목을 입력하세요."),
//             ),
//           ),
//           Divider(
//             height: 5,
//             thickness: 0.5,
//           ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(24, 5, 24, 5),
//             child: Column(
//               children: [
//                 TextField(
//                   autofocus: true,
//                   controller: descriptionController,
//                   keyboardType: TextInputType.multiline,
//                   maxLines: null,
//                   minLines: 15,
//                   decoration: InputDecoration(
//                       border: InputBorder.none, hintText: "내용을 입력하세요."),
//                 ),
//                 Divider(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
