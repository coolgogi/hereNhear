//written by suhyun.
//For http function.
//version 1
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// late CloudFunctionsHelloWorldState pageState;
//
// class CloudFunctionsHelloWorld extends StatefulWidget {
//   @override
//   CloudFunctionsHelloWorldState createState() {
//     pageState = CloudFunctionsHelloWorldState();
//     return pageState;
//   }
// }
//
// class CloudFunctionsHelloWorldState extends State<CloudFunctionsHelloWorld> {
//   String resp = "";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Cloud Functions HelloWorld")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(resp),
//             TextButton(
//               child: Text("Call Cloud Function HelloWorld"),
//               onPressed: () async {
//                 setState(() {
//                   resp = "";
//                 });
//                 String url =
//                     "https://us-central1-herenhear-e67af.cloudfunctions.net/helloWorld";
//                 Uri _url = Uri.parse(url);
//                 var response = await http.get(_url);
//                 setState(() {
//                   resp = response.body;
//                 });
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

//version 2
// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// late CloudFunctionsHelloWorldState pageState;
//
// class CloudFunctionsHelloWorld extends StatefulWidget {
//   @override
//   CloudFunctionsHelloWorldState createState() {
//     pageState = CloudFunctionsHelloWorldState();
//     return pageState;
//   }
// }
//
// class CloudFunctionsHelloWorldState extends State<CloudFunctionsHelloWorld> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//
//   final HttpsCallable helloWorld = FirebaseFunctions.instance
//       .httpsCallable('helloWorld'); // 호출할 Cloud Functions 의 함수명
//   // ..timeout = const Duration(seconds: 30); // 타임아웃 설정(옵션)
//
//   String resp = "";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(title: Text("Cloud Functions HelloWorld")),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: ListView(
//           children: <Widget>[
//             Container(
//               alignment: Alignment.center,
//               margin: const EdgeInsets.symmetric(vertical: 20),
//               padding: const EdgeInsets.all(10),
//               color: Colors.deepOrangeAccent,
//               child: Text(
//                 resp,
//                 style: TextStyle(color: Colors.white, fontSize: 16),
//               ),
//             ),
//             // URL로 helloWorld 에 접근
//             TextButton(
//               child: Text("http.get helloWorld"),
//               onPressed: () async {
//                 clearResponse();
//                 String url =
//                     "https://us-central1-herenhear-e67af.cloudfunctions.net/helloWorld";
//                 Uri _url = Uri.parse(url);
//                 showProgressSnackBar();
//                 var response = await http.get(_url);
//                 hideProgressSnackBar();
//                 setState(() {
//                   resp = response.body;
//                 });
//               },
//             ),
//
//             // Cloud Functions 으로 호출
//             TextButton(
//               child: Text("Call Cloud Function helloWorld"),
//               onPressed: () async {
//                 try {
//                   clearResponse();
//                   showProgressSnackBar();
//                   final HttpsCallableResult result = await helloWorld.call();
//                   setState(() {
//                     resp = result.data;
//                   });
//                 } on FirebaseFunctionsException catch (e) {
//                   print('caught firebase functions exception');
//                   print('code: ${e.code}');
//                   print('message: ${e.message}');
//                   print('details: ${e.details}');
//                 } catch (e) {
//                   print('======caught generic exception======');
//                   print(e);
//                   print('====================================');
//                 }
//                 hideProgressSnackBar();
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   clearResponse() {
//     setState(() {
//       resp = "";
//     });
//   }
//
//   showProgressSnackBar() {
//     _scaffoldKey.currentState!
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           duration: Duration(seconds: 10),
//           content: Row(
//             children: <Widget>[
//               CircularProgressIndicator(),
//               Text("   Calling Firebase Cloud Functions...")
//             ],
//           ),
//         ),
//       );
//   }
//
//   hideProgressSnackBar() {
//     _scaffoldKey.currentState!..hideCurrentSnackBar();
//   }
//
//   showErrorSnackBar(String msg) {
//     _scaffoldKey.currentState!
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           backgroundColor: Colors.red[400],
//           duration: Duration(seconds: 10),
//           content: Text(msg),
//           action: SnackBarAction(
//             label: "Done",
//             textColor: Colors.white,
//             onPressed: () {},
//           ),
//         ),
//       );
//   }
// }

//version 3
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_functions/cloud_functions.dart';

late CloudFunctionsHelloWorldState pageState;

class CloudFunctionsHelloWorld extends StatefulWidget {
  @override
  CloudFunctionsHelloWorldState createState() {
    pageState = CloudFunctionsHelloWorldState();
    return pageState;
  }
}

class CloudFunctionsHelloWorldState extends State<CloudFunctionsHelloWorld> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final HttpsCallable helloWorld = FirebaseFunctions.instance
      .httpsCallable('helloWorld'); // 호출할 Cloud Functions 의 함수명
  // ..timeout = const Duration(seconds: 30); // 타임아웃 설정(옵션)

  final HttpsCallable addCount = FirebaseFunctions.instance
      .httpsCallable('addCount'); // 호출할 Cloud Functions 의 함수명
  // ..timeout = const Duration(seconds: 30); // 타임아웃 설정(옵션)

  final HttpsCallable removeCount = FirebaseFunctions.instance
      .httpsCallable('removeCount'); // 호출할 Cloud Functions 의 함수명
  // ..timeout = const Duration(seconds: 30); // 타임아웃 설정(옵션)

  String resp = "";
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Cloud Functions HelloWorld")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.all(10),
              color: Colors.deepOrangeAccent,
              child: Text(
                resp,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            // URL로 helloWorld 에 접근
            TextButton(
              child: Text("http.get helloWorld"),
              onPressed: () async {
                clearResponse();
                String url =
                    "https://us-central1-flutter-firebase-a2994.cloudfunctions.net/helloWorld";
                Uri _url = Uri.parse(url);
                showProgressSnackBar();
                var response = await http.get(_url);
                hideProgressSnackBar();
                setState(() {
                  resp = response.body;
                });
              },
            ),

            // Cloud Functions 으로 호출
            TextButton(
              child: Text("Call Cloud Function helloWorld"),
              onPressed: () async {
                try {
                  clearResponse();
                  showProgressSnackBar();
                  final HttpsCallableResult result = await helloWorld.call();
                  setState(() {
                    resp = result.data;
                  });
                } on FirebaseFunctionsException catch (e) {
                  print('caught firebase functions exception');
                  print('code: ${e.code}');
                  print('message: ${e.message}');
                  print('details: ${e.details}');
                } catch (e) {
                  print('caught generic exception');
                  print(e);
                }
                hideProgressSnackBar();
              },
            ),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: null,
                    child: Icon(Icons.remove),
                    onPressed: () async {
                      final HttpsCallableResult result = await removeCount
                          .call(<String, dynamic>{'count': count});
                      print(result.data);
                      setState(() {
                        count = result.data;
                      });
                    },
                  ),
                  FloatingActionButton(
                    heroTag: null,
                    child: Icon(Icons.add),
                    onPressed: () async {
                      final HttpsCallableResult result = await addCount
                          .call(<String, dynamic>{'count': count});
                      print(result.data);
                      setState(() {
                        count = result.data;
                      });
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  clearResponse() {
    setState(() {
      resp = "";
    });
  }

  showProgressSnackBar() {
    _scaffoldKey.currentState!
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: Duration(seconds: 10),
          content: Row(
            children: <Widget>[
              CircularProgressIndicator(),
              Text("   Calling Firebase Cloud Functions...")
            ],
          ),
        ),
      );
  }

  hideProgressSnackBar() {
    _scaffoldKey.currentState!..hideCurrentSnackBar();
  }

  showErrorSnackBar(String msg) {
    _scaffoldKey.currentState!
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[400],
          duration: Duration(seconds: 10),
          content: Text(msg),
          action: SnackBarAction(
            label: "Done",
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
  }
}
