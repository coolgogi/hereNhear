import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:herehear/bottomNavigationBar/home/scroll_controller.dart';
import 'package:herehear/users/data/user_model.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:herehear/chatting/my_firebase_chat.dart';
import 'package:herehear/theme/colors.dart';
import 'package:image_picker/image_picker.dart';
import '../broadcast/data/broadcast_model.dart' as types;
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;
import 'src/class/my_message.dart' as types;
import 'src/widgets/my_chat.dart';
import 'package:herehear/chatting/src/class/my_file_message.dart' as types;
import 'package:herehear/chatting/src/class/my_text_message.dart' as types;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatPage extends StatefulWidget {
  late final docId;

  //late final roomData;
  late final room;

  // late final Map<String, dynamic> roomData;
  ChatPage(this.room);

  @override
  _ChatPageState createState() => _ChatPageState(room);
}

class _ChatPageState extends State<ChatPage> {
  late types.BroadcastModel room;
  _ChatPageState(this.room);

  bool _isAttachmentUploading = false;
  bool noticeActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            fit: BoxFit.contain,
            image: AssetImage('assets/suhyun.jpg'), // <-- 이미지 넣기!!
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(26.w, 70.h, 24.w, 8.h),
                  child: Container(
                    height: 53.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.surface.withOpacity(0.4)),
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 2.h, right: 10.0.w),
                            child: Container(
                              width: 38.w,
                              height: 38.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Theme.of(context).colorScheme.primary),
                                image: DecorationImage(
                                  image: AssetImage('assets/images/me.jpg'), // <-- 호스트 프로필 사진
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(room.roomInfo.hostInfo.nickName!, style: Theme.of(context).textTheme.headline4!.copyWith(color: Theme.of(context).colorScheme.surface)),
                                  SizedBox(width: 6.w),
                                  Padding(
                                    padding: EdgeInsets.only(top: 3.5.h),
                                    child: Image.asset('assets/images/rive_red.png', width: 43.w, height: 16.w,),
                                  ),
                                ]
                              ),
                              SizedBox(height: 4.h),
                              Text('팔로우 숫자', style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).colorScheme.surface)),
                            ],
                          ),
                          Expanded(child: Container()),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.people,
                                    size: 17.w,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    ' ${widget.room.users.length.toString()}',
                                    style:
                                    Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Icon(
                                    Icons.favorite,
                                    size: 14.w,
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 15.w),
                                    child: Text(
                                      ' ${widget.room.like.toString()}',
                                      style:
                                      Theme.of(context).textTheme.subtitle1!.copyWith(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(26.w, 5.h, 24.w, 5.h),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 37.h,
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).colorScheme.surface.withOpacity(0.3)),
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                            borderRadius: BorderRadius.all(Radius.circular(5.r)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(15.0.w, 9.h, 15.w, 0.h) ,
                            child: Text(room.roomInfo.title, style: Theme.of(context).textTheme.headline4!.copyWith(color: Theme.of(context).colorScheme.surface)),
                          ),
                        ),
                      ]
                  ),
                ),
                Expanded(
                  child: Container(
                      color: Colors.transparent,
                      child: StreamBuilder<types.BroadcastModel>(
                          initialData: widget.room,
                          stream: MyFirebaseChatCore.instance.room(widget.room.channelName),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return StreamBuilder<List<types.MyMessage>>(
                                  initialData: const [],
                                  stream: MyFirebaseChatCore.instance.messages(snapshot.data!),
                                  builder: (context, snapshot) {
                                    return MyChat(
                                        isAttachmentUploading: _isAttachmentUploading,
                                        messages: snapshot.data ?? [],
                                        onAttachmentPressed: _handleAtachmentPressed,
                                        onMessageTap: _handleMessageTap,
                                        onPreviewDataFetched: _handlePreviewDataFetched,
                                        onSendPressed: _handleSendPressed,
                                        user: types.UserModel(
                                          id: MyFirebaseChatCore.instance.firebaseUser?.uid ?? '',
                                        ),
                                      );
                                  });
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          }),
              ),
            ),
              ],
            ),
            Positioned(
              left: noticeActive? 220.w : 321.5.w,
              top: noticeActive? 130.h : 133.3.h,
              child: noticeActive? Container(
                width: 140.w,
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.surface.withOpacity(0.3)),
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15.0.w, 9.h, 10.w, 9.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '공지',
                              maxLines: 5,
                              textAlign: TextAlign.justify,
                              overflow: TextOverflow.ellipsis,
                              // softWrap: true,
                              // overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).colorScheme.primary)),
                          Expanded(child: Container()),
                          InkWell(
                              onTap: (() {
                                setState(() {
                                  noticeActive = !noticeActive;
                                });
                              }),
                              child: Image.asset('assets/icons/notice.png', width: 20.w, height: 20.w)),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                          room.roomInfo.notice!,
                          maxLines: 5,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          // softWrap: true,
                          // overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).colorScheme.surface)),
                    ],
                  ),
                ),
              ) : GestureDetector(
                onTap: (() {
                  setState(() {
                    noticeActive = !noticeActive;
                  });
                }),
                child: Container(
                  width: 30.h,
                  height: 30.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).colorScheme.surface.withOpacity(0.3)),
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  child: Center(child: Image.asset('assets/icons/notice.png', width: 20.w, height: 20.w),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //+ button
  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: 144,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleImageSelection();
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Photo'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleFileSelection();
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('File'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final name = result.files.single.name;
      final filePath = result.files.single.path;
      final file = File(filePath ?? '');

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialFile(
          mimeType: lookupMimeType(filePath ?? ''),
          name: name,
          size: result.files.single.size,
          uri: uri,
        );

        MyFirebaseChatCore.instance.sendMessage(message, widget.room.id);
        _setAttachmentUploading(false);
      } on FirebaseException catch (e) {
        _setAttachmentUploading(false);
        print(e);
      }
    }
  }

  // void _setAttachmentUploading(bool uploading) {
  //   setState(() {
  //     _isAttachmentUploading = uploading;
  //   });
  // }

  void _handleImageSelection() async {
    final result = await ImagePicker().getImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.path; //.name;

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          name: name,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        MyFirebaseChatCore.instance.sendMessage(
          message,
          widget.room.id,
        );
        _setAttachmentUploading(false);
      } on FirebaseException catch (e) {
        _setAttachmentUploading(false);
        print(e);
      }
    }
  }

  void _handleMessageTap(types.MyMessage message) async {
    if (message is types.MyFileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        final client = http.Client();
        final request = await client.get(Uri.parse(message.uri));
        final bytes = request.bodyBytes;
        final documentsDir = (await getApplicationDocumentsDirectory()).path;
        localPath = '$documentsDir/${message.name}';

        if (!File(localPath).existsSync()) {
          final file = File(localPath);
          await file.writeAsBytes(bytes);
        }
      }

      await OpenFile.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.MyTextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    MyFirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
  }

  void _handleSendPressed(types.PartialText message) {
    print('send');
    MyFirebaseChatCore.instance.sendMessage(
      message,
      widget.room.channelName,
    );
    print('complete!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }
}

@immutable
class GreenChatTheme extends ChatTheme {
  /// Creates a dark chat theme. Use this constructor if you want to
  /// override only a couple of variables, otherwise create a new class
  /// which extends [ChatTheme]
  const GreenChatTheme({
    Widget? attachmentButtonIcon,
    Color backgroundColor = const Color(0xffffffff),
    TextStyle dateDividerTextStyle = const TextStyle(
      color: Color(0x00ffffff),
      fontFamily: 'Avenir',
      fontSize: 12,
      fontWeight: FontWeight.w800,
      height: 1.333,
    ),
    Widget? deliveredIcon,
    Widget? documentIcon,
    TextStyle emptyChatPlaceholderTextStyle = const TextStyle(
      color: Color(0x00ffffff),
      fontFamily: 'Avenir',
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
    ),
    Color errorColor = ERROR,
    Widget? errorIcon,
    Color inputBackgroundColor = PrimaryColorLight,
    BorderRadius inputBorderRadius = const BorderRadius.vertical(
      top: Radius.circular(20),
    ),
    Color inputTextColor = const Color(0xffffffff),
    TextStyle inputTextStyle = const TextStyle(
      fontFamily: 'Avenir',
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
    ),
    double messageBorderRadius = 20.0,
    Color primaryColor = SecondaryLight,
    TextStyle receivedMessageBodyTextStyle = const TextStyle(
      color: BackgroundLight,
      fontFamily: 'Avenir',
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
    ),
    TextStyle receivedMessageCaptionTextStyle = const TextStyle(
      color: Color(0x00ffffff),
      fontFamily: 'Avenir',
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.333,
    ),
    Color receivedMessageDocumentIconColor = const Color(0x00ffffff),
    TextStyle receivedMessageLinkDescriptionTextStyle = const TextStyle(
      color: BackgroundLight,
      fontFamily: 'Avenir',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.428,
    ),
    TextStyle receivedMessageLinkTitleTextStyle = const TextStyle(
      color: Color(0x00ffffff),
      fontFamily: 'Avenir',
      fontSize: 16,
      fontWeight: FontWeight.w800,
      height: 1.375,
    ),
    Color secondaryColor = PrimaryColorLight,
    Widget? seenIcon,
    Widget? sendButtonIcon,
    TextStyle sentMessageBodyTextStyle = const TextStyle(
      color: BackgroundLight,
      fontFamily: 'Avenir',
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
    ),
    TextStyle sentMessageCaptionTextStyle = const TextStyle(
      color: Color(0x00ffffff),
      fontFamily: 'Avenir',
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.333,
    ),
    Color sentMessageDocumentIconColor = const Color(0x00ffffff),
    TextStyle sentMessageLinkDescriptionTextStyle = const TextStyle(
      color: BackgroundLight,
      fontFamily: 'Avenir',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.428,
    ),
    TextStyle sentMessageLinkTitleTextStyle = const TextStyle(
      color: Color(0x00ffffff),
      fontFamily: 'Avenir',
      fontSize: 16,
      fontWeight: FontWeight.w800,
      height: 1.375,
    ),
    List<Color> userAvatarNameColors = COLORS,
    TextStyle userAvatarTextStyle = const TextStyle(
      color: Color(0x00ffffff),
      fontFamily: 'Avenir',
      fontSize: 12,
      fontWeight: FontWeight.w800,
      height: 1.333,
    ),
    TextStyle userNameTextStyle = const TextStyle(
      fontFamily: 'Avenir',
      fontSize: 12,
      fontWeight: FontWeight.w800,
      height: 1.333,
    ),
  }) : super(
          attachmentButtonIcon: attachmentButtonIcon,
          backgroundColor: backgroundColor,
          dateDividerTextStyle: dateDividerTextStyle,
          deliveredIcon: deliveredIcon,
          documentIcon: documentIcon,
          emptyChatPlaceholderTextStyle: emptyChatPlaceholderTextStyle,
          errorColor: errorColor,
          errorIcon: errorIcon,
          inputBackgroundColor: inputBackgroundColor,
          inputBorderRadius: inputBorderRadius,
          inputTextColor: inputTextColor,
          inputTextStyle: inputTextStyle,
          messageBorderRadius: messageBorderRadius,
          primaryColor: primaryColor,
          receivedMessageBodyTextStyle: receivedMessageBodyTextStyle,
          receivedMessageCaptionTextStyle: receivedMessageCaptionTextStyle,
          receivedMessageDocumentIconColor: receivedMessageDocumentIconColor,
          receivedMessageLinkDescriptionTextStyle:
              receivedMessageLinkDescriptionTextStyle,
          receivedMessageLinkTitleTextStyle: receivedMessageLinkTitleTextStyle,
          secondaryColor: secondaryColor,
          seenIcon: seenIcon,
          sendButtonIcon: sendButtonIcon,
          sentMessageBodyTextStyle: sentMessageBodyTextStyle,
          sentMessageCaptionTextStyle: sentMessageCaptionTextStyle,
          sentMessageDocumentIconColor: sentMessageDocumentIconColor,
          sentMessageLinkDescriptionTextStyle:
              sentMessageLinkDescriptionTextStyle,
          sentMessageLinkTitleTextStyle: sentMessageLinkTitleTextStyle,
          userAvatarNameColors: userAvatarNameColors,
          userAvatarTextStyle: userAvatarTextStyle,
          userNameTextStyle: userNameTextStyle,
        );
}
