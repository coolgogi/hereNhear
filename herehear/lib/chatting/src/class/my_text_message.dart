import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'my_message.dart';
import 'package:herehear/chatting/util.dart';
import 'package:herehear/users/data/user_model.dart';
import 'package:meta/meta.dart';



/// A class that represents text message.
@immutable
class MyTextMessage extends MyMessage {
  /// Creates a text message.
  const MyTextMessage({
    required UserModel author,
    int? createdAt,
    required String id,
    Map<String, dynamic>? metadata,
    this.previewData,
    String? roomId,
    MyStatus? myStatus,
    required this.text,
    int? updatedAt,
  }) : super(
    author,
    createdAt,
    id,
    metadata,
    roomId,
    myStatus,
    MyMessageType.text,
    updatedAt,
  );

  /// Creates a full text message from a partial one.
  MyTextMessage.fromPartial({
    required UserModel author,
    int? createdAt,
    required String id,
    Map<String, dynamic>? metadata,
    required PartialText partialText,
    String? roomId,
    MyStatus? myStatus,
    int? updatedAt,
  })  : previewData = null,
        text = partialText.text,
        super(
        author,
        createdAt,
        id,
        metadata,
        roomId,
        myStatus,
        MyMessageType.text,
        updatedAt,
      );

  /// Creates a text message from a map (decoded JSON).
  MyTextMessage.fromJson(Map<String, dynamic> json)
      : previewData = json['previewData'] == null
      ? null
      : PreviewData.fromJson(json['previewData'] as Map<String, dynamic>),
        text = json['text'] as String,
        super(
        UserModel.fromJson(json['author'] as Map<String, dynamic>),
        json['createdAt'] as int?,
        json['id'] as String,
        json['metadata'] as Map<String, dynamic>?,
        json['roomId'] as String?,
        getMyStatusFromString(json['myStatus'] as String?),
        MyMessageType.text,
        json['updatedAt'] as int?,
      );

  /// Converts a text message to the map representation, encodable to JSON.
  @override
  Map<String, dynamic> toJson() => {
    'author': author.toJson(),
    'createdAt': createdAt,
    'id': id,
    'metadata': metadata,
    'previewData': previewData?.toJson(),
    'roomId': roomId,
    'myStatus': myStatus?.toMyShortString(),
    'text': text,
    'type': MyMessageType.text.toMyShortString(),
    'updatedAt': updatedAt,
  };

  /// Creates a copy of the text message with an updated data
  /// [metadata] with null value will nullify existing metadata, otherwise
  /// both metadatas will be merged into one Map, where keys from a passed
  /// metadata will overwite keys from the previous one.
  /// [status] with null value will be overwritten by the previous status.
  /// [updatedAt] with null value will nullify existing value.
  @override
  MyMessage copyWith({
    Map<String, dynamic>? metadata,
    PreviewData? previewData,
    MyStatus? myStatus,
    String? text,
    int? updatedAt,
  }) {
    return MyTextMessage(
      author: author,
      createdAt: createdAt,
      id: id,
      metadata: metadata == null
          ? null
          : {
        ...this.metadata ?? {},
        ...metadata,
      },
      previewData: previewData,
      roomId: roomId,
      myStatus: myStatus ?? this.myStatus,
      text: text ?? this.text,
      updatedAt: updatedAt,
    );
  }

  /// Equatable props
  @override
  List<Object?> get props => [
    author,
    createdAt,
    id,
    metadata,
    previewData,
    roomId,
    myStatus,
    text,
    updatedAt,
  ];

  /// See [PreviewData]
  final PreviewData? previewData;

  /// User's message
  final String text;
}
