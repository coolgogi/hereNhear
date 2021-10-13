import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:herehear/agora/agoraEventController.dart';
import 'package:herehear/bottomNavigationBar/home/scroll_controller.dart';
import 'package:herehear/broadcast/data/broadcast_model.dart';
import 'package:herehear/chatting/my_firebase_chat.dart';
import 'package:herehear/chatting/src/conditional/conditional.dart';
import 'package:herehear/chatting/src/models/date_header.dart';
import 'package:herehear/chatting/src/models/message_spacer.dart';
import 'package:herehear/chatting/src/models/preview_image.dart';
import 'package:herehear/chatting/src/util.dart';
import 'package:herehear/chatting/src/widgets/chat_list.dart';
import 'package:herehear/chatting/src/widgets/inherited_chat_theme.dart';
import 'package:herehear/chatting/src/widgets/inherited_l10n.dart';
import 'package:herehear/chatting/src/widgets/inherited_user.dart';
import 'package:herehear/chatting/src/widgets/message.dart';
import 'package:herehear/users/controller/user_controller.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:herehear/users/data/user_model.dart' as types;
import '../class/my_message.dart' as types;
import 'package:herehear/chatting/src/class/my_text_message.dart' as types;
import 'package:herehear/chatting/src/class/my_image_message.dart' as types;
import 'package:herehear/chatting/src/widgets/input.dart' as myInput;
import '../chat_theme.dart' as chatTheme;
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ChatController extends GetxController {
  RxBool isKeyBoardActive = false.obs;
  RxBool isHostAudioActive = true.obs;
  RxBool isFavoriteRoom = false.obs;
}

/// Entry widget, represents the complete chat
class MyChat extends StatefulWidget {

  /// Creates a chat widget
  const MyChat({
    Key? key,
    required this.roomData,
    this.buildCustomMessage,
    this.customDateHeaderText,
    this.dateFormat,
    this.dateLocale,
    this.disableImageGallery,
    this.isAttachmentUploading,
    this.isLastPage,
    this.l10n = const ChatL10nEn(),
    required this.messages,
    this.onAttachmentPressed,
    this.onEndReached,
    this.onEndReachedThreshold,
    this.onMessageLongPress,
    this.onMessageTap,
    this.onPreviewDataFetched,
    required this.onSendPressed,
    this.onTextChanged,
    this.showUserAvatars = false,
    this.showUserNames = false,
    this.theme = const DefaultChatTheme(),
    this.timeFormat,
    this.usePreviewData = true,
    required this.user,
  }) : super(key: key);


  final BroadcastModel roomData;

  /// See [Message.buildCustomMessage]
  final Widget Function(types.MyMessage)? buildCustomMessage;

  /// If [dateFormat], [dateLocale] and/or [timeFormat] is not enough to
  /// customize date headers in your case, use this to return an arbitrary
  /// string based on a [DateTime] of a particular message. Can be helpful to
  /// return "Today" if [DateTime] is today. IMPORTANT: this will replace
  /// all default date headers, so you must handle all cases yourself, like
  /// for example today, yesterday and before. Or you can just return the same
  /// date header for any message.
  final String Function(DateTime)? customDateHeaderText;

  /// Allows you to customize the date format. IMPORTANT: only for the date,
  /// do not return time here. See [timeFormat] to customize the time format.
  /// [dateLocale] will be ignored if you use this, so if you want a localized date
  /// make sure you initialize your [DateFormat] with a locale. See [customDateHeaderText]
  /// for more customization.
  final DateFormat? dateFormat;

  /// Locale will be passed to the `Intl` package. Make sure you initialized
  /// date formatting in your app before passing any locale here, otherwise
  /// an error will be thrown. Also see [customDateHeaderText], [dateFormat], [timeFormat].
  final String? dateLocale;

  /// Disable automatic image preview on tap.
  final bool? disableImageGallery;

  /// See [Input.isAttachmentUploading]
  final bool? isAttachmentUploading;

  /// See [ChatList.isLastPage]
  final bool? isLastPage;

  /// Localized copy. Extend [ChatL10n] class to create your own copy or use
  /// existing one, like the default [ChatL10nEn]. You can customize only
  /// certain variables, see more here [ChatL10nEn].
  final ChatL10n l10n;

  /// List of [types.Message] to render in the chat widget
  final List<types.MyMessage> messages;

  /// See [Input.onAttachmentPressed]
  final void Function()? onAttachmentPressed;

  /// See [ChatList.onEndReached]
  final Future<void> Function()? onEndReached;

  /// See [ChatList.onEndReachedThreshold]
  final double? onEndReachedThreshold;

  /// See [Message.onMessageLongPress]
  final void Function(types.MyMessage)? onMessageLongPress;

  /// See [Message.onMessageTap]
  final void Function(types.MyMessage)? onMessageTap;

  /// See [Message.onPreviewDataFetched]
  final void Function(types.MyTextMessage, types.PreviewData)?
      onPreviewDataFetched;

  /// See [myInput.Input.onSendPressed]
  final void Function(types.PartialText) onSendPressed;

  /// See [myInput.Input.onTextChanged]
  final void Function(String)? onTextChanged;

  /// See [Message.showUserAvatars]
  final bool showUserAvatars;

  /// Show user names for received messages. Useful for a group chat. Will be
  /// shown only on text messages.
  final bool showUserNames;

  /// Chat theme. Extend [ChatTheme] class to create your own theme or use
  /// existing one, like the [DefaultChatTheme]. You can customize only certain
  /// variables, see more here [DefaultChatTheme].
  final ChatTheme theme;

  /// Allows you to customize the time format. IMPORTANT: only for the time,
  /// do not return date here. See [dateFormat] to customize the date format.
  /// [dateLocale] will be ignored if you use this, so if you want a localized time
  /// make sure you initialize your [DateFormat] with a locale. See [customDateHeaderText]
  /// for more customization.
  final DateFormat? timeFormat;

  /// See [Message.usePreviewData]
  final bool usePreviewData;

  /// See [InheritedUser.user]
  final types.UserModel user;

  @override
  _ChatState createState() => _ChatState();
}

/// [Chat] widget state
class _ChatState extends State<MyChat> {
  List<Object> _chatMessages = [];
  List<PreviewImage> _gallery = [];
  int _imageViewIndex = 0;
  bool _isImageViewVisible = false;
  final chatController = Get.put(ChatController());
  // final chatController = Get.put(AgoraEventController.broadcast(channelName: channelName, role: role)));


  @override
  void initState() {
    super.initState();

    didUpdateWidget(widget);
  }

  @override
  void didUpdateWidget(covariant MyChat oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.messages.isNotEmpty) {
      final result = calculateChatMessages(
        widget.messages,
        widget.user,
        customDateHeaderText: widget.customDateHeaderText,
        dateFormat: widget.dateFormat,
        dateLocale: widget.dateLocale,
        showUserNames: widget.showUserNames,
        timeFormat: widget.timeFormat,
      );

      _chatMessages = result[0] as List<Object>;
      _gallery = result[1] as List<PreviewImage>;
    }
  }

  Widget _buildImageGallery() {
    return Dismissible(
      key: const Key('photo_view_gallery'),
      direction: DismissDirection.down,
      onDismissed: (direction) => _onCloseGalleryPressed(),
      child: Stack(
        children: [
          PhotoViewGallery.builder(
            builder: (BuildContext context, int index) =>
                PhotoViewGalleryPageOptions(
              imageProvider: Conditional().getProvider(_gallery[index].uri),
            ),
            itemCount: _gallery.length,
            loadingBuilder: (context, event) =>
                _imageGalleryLoadingBuilder(context, event),
            onPageChanged: _onPageChanged,
            pageController: PageController(initialPage: _imageViewIndex),
            scrollPhysics: const ClampingScrollPhysics(),
          ),
          Positioned(
            right: 16,
            top: 56,
            child: CloseButton(
              color: Colors.white,
              onPressed: _onCloseGalleryPressed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Object object) {
    // if (object is DateHeader) {
    //   return Container(
    //     alignment: Alignment.center,
    //     margin: const EdgeInsets.only(
    //       bottom: 32,
    //       top: 16,
    //     ),
    //     child: Text(
    //       object.text,
    //       style: widget.theme.dateDividerTextStyle,
    //     ),
    //   );
    // } else
      if (object is MessageSpacer) {
      return SizedBox(
        height: object.height,
      );
    } else {
      final map = object as Map<String, Object>;
      final message = map['message']! as types.MyMessage;
      final _messageWidth =
          widget.showUserAvatars && message.author.id != widget.user.id
              ? min(MediaQuery.of(context).size.width * 0.72, 440).floor()
              : min(MediaQuery.of(context).size.width * 0.78, 440).floor();

      return MyMessage(
        key: ValueKey(message.id),
        buildCustomMessage: widget.buildCustomMessage,
        message: message,
        messageWidth: _messageWidth,
        onMessageLongPress: widget.onMessageLongPress,
        onMessageTap: (tappedMessage) {
          if (tappedMessage is types.MyImageMessage &&
              widget.disableImageGallery != true) {
            _onImagePressed(tappedMessage);
          }

          widget.onMessageTap?.call(tappedMessage);
        },
        onPreviewDataFetched: _onPreviewDataFetched,
        roundBorder: map['nextMessageInGroup'] == true,
        showAvatar:
            widget.showUserAvatars && map['nextMessageInGroup'] == false,
        showName: map['showName'] == true,
        showStatus: map['showStatus'] == true,
        showUserAvatars: widget.showUserAvatars,
        usePreviewData: widget.usePreviewData,
      );
    }
  }

  Widget _imageGalleryLoadingBuilder(
    BuildContext context,
    ImageChunkEvent? event,
  ) {
    return Center(
      child: SizedBox(
        width: 20.0,
        height: 20.0,
        child: CircularProgressIndicator(
          value: event == null || event.expectedTotalBytes == null
              ? 0
              : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
        ),
      ),
    );
  }

  void _onCloseGalleryPressed() {
    setState(() {
      _isImageViewVisible = false;
    });
  }

  void _onImagePressed(types.MyImageMessage message) {
    setState(() {
      _imageViewIndex = _gallery.indexWhere(
        (element) => element.id == message.id && element.uri == message.uri,
      );
      _isImageViewVisible = true;
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _imageViewIndex = index;
    });
  }

  void _onPreviewDataFetched(
    types.MyTextMessage message,
    types.PreviewData previewData,
  ) {
    widget.onPreviewDataFetched?.call(message, previewData);
  }


  @override
  Widget build(BuildContext context) {
    return InheritedUser(
      user: widget.user,
      child: InheritedChatTheme(
        theme: widget.theme,
        child: InheritedL10n(
          l10n: widget.l10n,
          child: Stack(
            children: [
              Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Flexible(
                      child: widget.messages.isEmpty
                          ? SizedBox.expand(
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                // child: Text(
                                //   widget.l10n.emptyChatPlaceholder,
                                //   style: widget
                                //       .theme.emptyChatPlaceholderTextStyle,
                                //   textAlign: TextAlign.center,
                                // ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () => FocusManager.instance.primaryFocus
                                  ?.unfocus(),
                              child: MyChatList(
                                isLastPage: widget.isLastPage,
                                itemBuilder: (item, index) =>
                                    _buildMessage(item),
                                items: _chatMessages,
                                onEndReached: widget.onEndReached,
                                onEndReachedThreshold:
                                widget.onEndReachedThreshold,
                              )
                            ),
                    ),
                    Obx(() => chatController.isKeyBoardActive.value?
                    WillPopScope(
                        child: myInput.Input(
                          isAttachmentUploading: widget.isAttachmentUploading,
                          onAttachmentPressed: widget.onAttachmentPressed,
                          onSendPressed: widget.onSendPressed,
                          onTextChanged: widget.onTextChanged,
                        ),
                        onWillPop: () {
                          setState(() {
                            chatController.isKeyBoardActive.value = false;
                          });
                          return Future(() => false);
                        })
                        : Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(15.w, 12.h, 17.w, 12.h),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: (() {
                                  setState(() {
                                    chatController.isHostAudioActive.value = !(chatController.isHostAudioActive.value);

                                  });
                                }),
                                child: Container(
                                  width: 30.h,
                                  height: 30.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: chatController.isHostAudioActive.value? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.primaryVariant,
                                  ),
                                  child: Center(child: Image.asset(chatController.isHostAudioActive.value? 'assets/icons/mic_fill_black.png' : 'assets/icons/mic_off.png', width: 20.h, height: 20.h)),
                                ),
                              ),
                              SizedBox(width: 15.w),
                              GestureDetector(
                                onTap: (() {
                                  setState(() {
                                    chatController.isKeyBoardActive.value = true;
                                  });
                                }),
                                child: Container(
                                  width: 30.h,
                                  height: 30.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).colorScheme.background,
                                  ),
                                  child: Center(child: Image.asset('assets/icons/chat_black.png', width: 20.h, height: 20.h)),
                                ),
                              ),
                              Expanded(child: Container()),
                              InkWell(
                                onTap: (() {
                                  setState(() {
                                    chatController.isFavoriteRoom.value = !(chatController.isFavoriteRoom.value);
                                    print('CheckChatKeyBoard().isFavoriteRoom: ${chatController.isFavoriteRoom.value}');




                                    //if(widget.roomData.likedPeople == null  || widget.roomData.likedPeople!.contains(UserController.to.myProfile.value.uid) == false ){
                                    if(chatController.isFavoriteRoom.value == true){
                                  //    widget.roomData.likedPeople!.add(UserController.to.myProfile.value.uid!);
                                      widget.roomData.like++;
                                      MyFirebaseChatCore.instance.updateLike(widget.roomData.roomInfo.channelName,chatController.isFavoriteRoom.value);
                                    }
                                    else{
                                   //   widget.roomData.likedPeople!.remove(UserController.to.myProfile.value.uid!);
                                      widget.roomData.like--;
                                      MyFirebaseChatCore.instance.updateLike(widget.roomData.roomInfo.channelName,chatController.isFavoriteRoom.value);
                                    }

                                  });
                                }),
                                child: Container(
                                  width: 30.h,
                                  height: 30.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).colorScheme.background,
                                  ),
                                  child: Center(child: Image.asset(
                                      chatController.isFavoriteRoom.value? 'assets/icons/heart_fill.png' : 'assets/icons/heart.png', width: 20.h, height: 20.h)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),)
                  ],
                ),
              ),
              if (_isImageViewVisible) _buildImageGallery(),
            ],
          ),
        ),
      ),
    );
  }
}
