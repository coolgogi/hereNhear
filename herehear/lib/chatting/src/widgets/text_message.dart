import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_link_previewer/flutter_link_previewer.dart'
    show LinkPreview, REGEX_LINK;
import '../util.dart';
import 'inherited_chat_theme.dart';
import 'inherited_user.dart';
import 'package:herehear/users/data/user_model.dart' as types;
import 'package:herehear/chatting/src/class/my_text_message.dart' as types;
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A class that represents text message widget with optional link preview
class TextMessage extends StatelessWidget {
  /// Creates a text message widget from a [types.TextMessage] class
  const TextMessage({
    Key? key,
    required this.message,
    this.onPreviewDataFetched,
    required this.usePreviewData,
    required this.showName,
  }) : super(key: key);

  /// [types.TextMessage]
  final types.MyTextMessage message;

  /// See [LinkPreview.onPreviewDataFetched]
  final void Function(types.MyTextMessage, types.PreviewData)?
      onPreviewDataFetched;

  /// Show user name for the received message. Useful for a group chat.
  final bool showName;

  /// Enables link (URL) preview
  final bool usePreviewData;

  void _onPreviewDataFetched(types.PreviewData previewData) {
    if (message.previewData == null) {
      onPreviewDataFetched?.call(message, previewData);
    }
  }

  Widget _linkPreview(
    types.UserModel user,
    double width,
    BuildContext context,
  ) {
    final bodyTextStyle = user.uid == message.author.id
        ? InheritedChatTheme.of(context).theme.sentMessageBodyTextStyle
        : InheritedChatTheme.of(context).theme.receivedMessageBodyTextStyle;
    final linkDescriptionTextStyle = user.id == message.author.id
        ? InheritedChatTheme.of(context)
            .theme
            .sentMessageLinkDescriptionTextStyle
        : InheritedChatTheme.of(context)
            .theme
            .receivedMessageLinkDescriptionTextStyle;
    final linkTitleTextStyle = user.id == message.author.id
        ? InheritedChatTheme.of(context).theme.sentMessageLinkTitleTextStyle
        : InheritedChatTheme.of(context)
            .theme
            .receivedMessageLinkTitleTextStyle;

    final color = getUserAvatarNameColor(message.author,
        InheritedChatTheme.of(context).theme.userAvatarNameColors);
    final name = getUserName(message.author);

    return LinkPreview(
      enableAnimation: true,
      header: showName ? name : null,
      headerStyle: InheritedChatTheme.of(context)
          .theme
          .userNameTextStyle
          .copyWith(color: color),
      linkStyle: bodyTextStyle,
      metadataTextStyle: linkDescriptionTextStyle,
      metadataTitleStyle: linkTitleTextStyle,
      onPreviewDataFetched: _onPreviewDataFetched,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      previewData: message.previewData,
      text: message.text,
      textStyle: bodyTextStyle,
      width: width,
    );
  }

  Widget _textWidget(types.UserModel user, BuildContext context) {
    final color = getUserAvatarNameColor(message.author,
        InheritedChatTheme.of(context).theme.userAvatarNameColors);
    final name = getUserName(message.author);

    return Container(
      constraints: BoxConstraints(maxWidth: 180.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showName)
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(
                name,
                maxLines: 10,
                textAlign: TextAlign.justify,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Theme.of(context).colorScheme.surface),
              ),
            ),
          Text(
            message.text,
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
            style: user.id == message.author.id
                ? Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).colorScheme.surface)
                : Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).colorScheme.surface),
            // textWidthBasis: TextWidthBasis.longestLine,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _user = InheritedUser.of(context).user;
    final _width = MediaQuery.of(context).size.width;

    final urlRegexp = RegExp(REGEX_LINK);
    final matches = urlRegexp.allMatches(message.text.toLowerCase());

    if (matches.isNotEmpty && usePreviewData && onPreviewDataFetched != null) {
      return _linkPreview(_user, _width, context);
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 8.w,
      ),
      child: _textWidget(_user, context),
    );
  }
}
