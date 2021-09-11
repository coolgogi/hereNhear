import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../util.dart';
import 'package:herehear/chatting/src/class/my_custom_message.dart' as types;
import 'package:herehear/chatting/src/class/my_file_message.dart' as types;
import 'package:herehear/chatting/src/class/my_image_message.dart' as types;
import 'package:herehear/chatting/src/class/my_text_message.dart' as types;

import 'file_message.dart';
import 'inherited_chat_theme.dart';
import 'inherited_user.dart';


import '../class/my_message.dart' as types;

import 'image_message.dart';
import 'text_message.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';




/// Base widget for all message types in the chat. Renders bubbles around
/// messages, delivery time and status. Sets maximum width for a message for
/// a nice look on larger screens.
class MyMessage extends StatelessWidget {
  /// Creates a particular message from any message type
  const MyMessage({
    Key? key,
    this.buildCustomMessage,
    required this.message,
    required this.messageWidth,
    this.onMessageLongPress,
    this.onMessageTap,
    this.onPreviewDataFetched,
    required this.roundBorder,
    required this.showAvatar,
    required this.showName,
    required this.showStatus,
    required this.showUserAvatars,
    required this.usePreviewData,
  }) : super(key: key);

  /// Build a custom message inside predefined bubble
  final Widget Function(types.MyMessage)? buildCustomMessage;

  /// Any message type
  final types.MyMessage message;

  /// Maximum message width
  final int messageWidth;

  /// Called when user makes a long press on any message
  final void Function(types.MyMessage)? onMessageLongPress;

  /// Called when user taps on any message
  final void Function(types.MyMessage)? onMessageTap;

  /// See [TextMessage.onPreviewDataFetched]
  final void Function(types.MyTextMessage, types.PreviewData)?
      onPreviewDataFetched;

  /// Rounds border of the message to visually group messages together.
  final bool roundBorder;

  /// Show user avatar for the received message. Useful for a group chat.
  final bool showAvatar;

  /// See [TextMessage.showName]
  final bool showName;

  /// Show message's status
  final bool showStatus;

  /// Show user avatars for received messages. Useful for a group chat.
  final bool showUserAvatars;

  /// See [TextMessage.usePreviewData]
  final bool usePreviewData;

  Widget _buildAvatar(BuildContext context) {
    final color = getUserAvatarNameColor(message.author,
        InheritedChatTheme.of(context).theme.userAvatarNameColors);
    final hasImage = message.author.imageUrl != null;
    final name = getUserName(message.author);

    return showAvatar
        ? Container(
            margin: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              backgroundImage:
                  hasImage ? NetworkImage(message.author.imageUrl!) : null,
              backgroundColor: color,
              radius: 16,
              child: !hasImage
                  ? Text(
                      name.isEmpty ? '' : name[0].toUpperCase(),
                      style: InheritedChatTheme.of(context)
                          .theme
                          .userAvatarTextStyle,
                    )
                  : null,
            ),
          )
        : Container(
            margin: const EdgeInsets.only(right: 40),
          );
  }

  Widget _buildMessage() {
    switch (message.type) {
      case types.MyMessageType.custom:
        final myCustomMessage = message as types.MyCustomMessage;
        return buildCustomMessage != null
            ? buildCustomMessage!(myCustomMessage)
            : const SizedBox();
      case types.MyMessageType.file:
        final myFileMessage = message as types.MyFileMessage;
        return FileMessage(
          message: myFileMessage,
        );
      case types.MyMessageType.image:
        final myImageMessage = message as types.MyImageMessage;
        return ImageMessage(
          message: myImageMessage,
          messageWidth: messageWidth,
        );
      case types.MyMessageType.text:
        final myTextMessage = message as types.MyTextMessage;
        return TextMessage(
          message: myTextMessage,
          onPreviewDataFetched: onPreviewDataFetched,
          showName: showName,
          usePreviewData: usePreviewData,
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildStatus(BuildContext context) {
    switch (message.myStatus) {
      case types.MyStatus.error:
        return InheritedChatTheme.of(context).theme.errorIcon != null
            ? InheritedChatTheme.of(context).theme.errorIcon!
            : Image.asset(
                'assets/icon-error.png',
                color: InheritedChatTheme.of(context).theme.errorColor,
                package: 'flutter_chat_ui',
              );
      case types.MyStatus.sent:
      case types.MyStatus.delivered:
        return InheritedChatTheme.of(context).theme.deliveredIcon != null
            ? InheritedChatTheme.of(context).theme.deliveredIcon!
            : Image.asset(
                'assets/icon-delivered.png',
                color: InheritedChatTheme.of(context).theme.primaryColor,
                package: 'flutter_chat_ui',
              );
      case types.MyStatus.seen:
        return InheritedChatTheme.of(context).theme.seenIcon != null
            ? InheritedChatTheme.of(context).theme.seenIcon!
            : Image.asset(
                'assets/icon-seen.png',
                color: InheritedChatTheme.of(context).theme.primaryColor,
                package: 'flutter_chat_ui',
              );
      case types.MyStatus.sending:
        return Center(
          child: SizedBox(
            height: 10,
            width: 10,
            child: CircularProgressIndicator(
              backgroundColor: Colors.transparent,
              strokeWidth: 1.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                InheritedChatTheme.of(context).theme.primaryColor,
              ),
            ),
          ),
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _user = InheritedUser.of(context).user;
    final _messageBorderRadius =
        InheritedChatTheme.of(context).theme.messageBorderRadius;
    final _borderRadius = BorderRadius.only(
      bottomLeft: Radius.circular(_user.id == message.author.id || roundBorder
          ? _messageBorderRadius
          : 0),
      bottomRight: Radius.circular(_user.id == message.author.id
          ? roundBorder
              ? _messageBorderRadius
              : 0
          : _messageBorderRadius),
      topLeft: Radius.circular(_messageBorderRadius),
      topRight: Radius.circular(_messageBorderRadius),
    );
    final _currentUserIsAuthor = _user.id == message.author.id;

    return Container(
      alignment: Alignment.centerLeft,
      // alignment: _user.id == message.author.id
      //     ? Alignment.centerRight
      //     : Alignment.centerLeft,
      margin: EdgeInsets.only(
        bottom: 10.w,
        left: 25.w,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_currentUserIsAuthor && showUserAvatars) _buildAvatar(context),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: messageWidth.toDouble(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 25.w,
                      height: 25.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/you.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 7.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NickName', style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Theme.of(context).colorScheme.surface)),
                        SizedBox(height: 5.h),
                        GestureDetector(
                          onLongPress: () => onMessageLongPress?.call(message),
                          onTap: () => onMessageTap?.call(message),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                              // color: !_currentUserIsAuthor ||
                              //         message.type == types.MyMessageType.image
                              //     ? Theme.of(context).colorScheme.onBackground.withOpacity(0.5)
                              //     : Theme.of(context).colorScheme.primary,
                            ),
                            child: ClipRRect(
                              borderRadius: _borderRadius,
                              child: _buildMessage(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_currentUserIsAuthor)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Center(
                child: SizedBox(
                  height: 16,
                  width: 16,
                  child: showStatus ? _buildStatus(context) : null,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
