import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:herehear/appBar/notification/data/notification_model.dart';
import 'package:overlay_support/overlay_support.dart';

class PushNotification extends StatefulWidget {
  @override
  PushNotificationState createState() => PushNotificationState();
}

class PushNotificationState extends State<PushNotification> {
  late int _totalNotifications;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  PushNotificationModel? _notificationInfo;

  @override
  void initState() {
    _totalNotifications = 0;

    checkForInitialMessage();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("=====remotemsg=====");
      print(message.data); //{}
      print(message.messageId); //0:1627958961401002%6529c8c36529c8c3
      print(message.messageType); //null
      print(message.category); //null
      print(message.collapseKey); //com.hgu.herehear
      print("===================");
      PushNotificationModel notification = PushNotificationModel(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );
      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    });

    super.initState();
  }

  void printToken() async {
    print("===========token===========");
    print(await FirebaseMessaging.instance.getToken());
    print("===========================");
  }

  String pushToken =
      'eVa6RLgkQYCWxRVOipcJj9:APA91bHGQFzTEWc4E36BYdSoubWkVNFLZvDxYMmFN6RrYUsEpjvj8iPoNB6sr42IxORdvVEj8XJIO9FDozZXmWio5miPApaeeFn_bKu8fADpKk9U57lFh2YltPJSe3S3X482aHG0b38x';
  Map<String, String> _data = {'title': 'Hello', 'body': 'I\'m suhyun'};

  String _messageId = DateTime.now().millisecond.toString();
  String? _messageType;
  String _collapseKey = 'com.hgu.herehear';

  void sendMessage(String msg) async {
    FirebaseMessaging.instance.sendMessage(
        to: pushToken,
        data: _data,
        collapseKey: _collapseKey,
        messageId: _messageId,
        messageType: _messageType,
        ttl: 0);
  }

  // RemoteMessage msg;
  /* ????????????
  FirebaseMessaging fm = FirebaseMessaging.getInstance();
  fm.send(new RemoteMessage.Builder(SENDER_ID + "@fcm.googleapis.com")
          .setMessageId(Integer.toString(messageId))
          .addData("my_message", "Hello World")
          .addData("my_action","SAY_HELLO")
          .build());
   */

  @override
  Widget build(BuildContext context) {
    printToken();
    return Scaffold(
      appBar: AppBar(
        title: Text('Notify'),
        brightness: Brightness.dark,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'App for capturing Firebase Push Notifications',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 16.0),
          NotificationBadge(totalNotifications: _totalNotifications),
          SizedBox(height: 16.0),
          // TODO: add the notification text here
          _notificationInfo != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TITLE: ${_notificationInfo!.dataTitle ?? _notificationInfo!.title}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'BODY: ${_notificationInfo!.dataBody ?? _notificationInfo!.body}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                )
              : Container(),
          TextButton(
              onPressed: () {
                sendMessage('');
              },
              child: Text('msg send')),
        ],
      ),
    );
  }

  void registerNotification() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();

    // 2. Instantiate Firebase Messaging
    // _messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      // TODO: handle the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        PushNotificationModel notification = PushNotificationModel(
          title: message.notification?.title,
          body: message.notification?.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });

        if (_notificationInfo != null) {
          // For displaying the notification as an overlay
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            leading: NotificationBadge(totalNotifications: _totalNotifications),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.cyan.shade700,
            duration: Duration(seconds: 2),
          );
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotificationModel notification = PushNotificationModel(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
        dataTitle: initialMessage.data['title'],
        dataBody: initialMessage.data['body'],
      );
      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    }
  }
}

class NotificationBadge extends StatelessWidget {
  final int totalNotifications;

  const NotificationBadge({required this.totalNotifications});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: new BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$totalNotifications',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}


Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}
