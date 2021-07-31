// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:herehear/bottomNavigationBar/create/broadcastInfoController/broadcast_info_controller.dart';
//
//
// class LoginView extends StatelessWidget {
//   // GetX State Management로 Controller를 불러오는 과정
//   // _loginController안에 login과 관련된 정보가 있고 이를 앱 전반에서 공유
//   final BroadcastInfoController _loginController = Get.put(BroadcastInfoController());
//   final _formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text('GetX Login'),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _loginController.emailTextController,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                     fillColor: Colors.grey[200],
//                     filled: true,
//                     hintText: 'Email',
//                     hintStyle: GoogleFonts.exo2(
//                         fontSize: 16,
//                         color: Colors.grey,
//                         fontWeight: FontWeight.normal),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide:
//                         BorderSide(color: Colors.transparent, width: 0)),
//                     enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide:
//                         BorderSide(color: Colors.transparent, width: 0))),
//                 style: GoogleFonts.exo2(
//                   fontSize: 16,
//                   color: Colors.black,
//                   fontWeight: FontWeight.normal,
//                 ),
//                 validator: (value) =>
//                 value.trim().isEmpty ? 'Email required' : null,
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 controller: _loginController.passwordTextController,
//                 keyboardType: TextInputType.text,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                     fillColor: Colors.grey[200],
//                     filled: true,
//                     hintText: 'PassWord',
//                     hintStyle: GoogleFonts.exo2(
//                         fontSize: 16,
//                         color: Colors.grey,
//                         fontWeight: FontWeight.normal),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide:
//                         BorderSide(color: Colors.transparent, width: 0)),
//                     enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide:
//                         BorderSide(color: Colors.transparent, width: 0))),
//                 validator: (value) =>
//                 value.trim().isEmpty ? 'Password required' : null,
//                 style: GoogleFonts.exo2(
//                     fontSize: 16,
//                     color: Colors.black,
//                     fontWeight: FontWeight.normal),
//               ),
//               SizedBox(height: 16),
//               MaterialButton(
//                 color: Colors.deepOrangeAccent,
//                 splashColor: Colors.white,
//                 height: 45,
//                 minWidth: Get.width / 2,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//                 child: Text(
//                   'Login',
//                   style: GoogleFonts.exo2(
//                       fontSize: 20,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 onPressed: () {
//                   if (_formKey.currentState.validate()) {
//                     _loginController.apiLogin();
//                   }
//                 },
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }