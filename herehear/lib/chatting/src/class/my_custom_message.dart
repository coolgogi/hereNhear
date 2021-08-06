import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'my_message.dart';
import 'package:herehear/chatting/util.dart';
import 'package:herehear/users/data/user_model.dart';
import 'package:meta/meta.dart';


/// A class that represents custom message. Use [metadata] to store anything
/// you want.
@immutable
class MyCustomMessage extends MyMessage {
  /// Creates a custom message.
  const MyCustomMessage({
    required UserModel author,
    int? createdAt,
    required String id,
    Map<String, dynamic>? metadata,
    String? roomId,
    MyStatus? myStatus,
    int? updatedAt,
  }) : super(
    author,
    createdAt,
    id,
    metadata,
    roomId,
    myStatus,
    MyMessageType.custom,
    updatedAt,
  );

  /// Creates a custom message from a map (decoded JSON).
  MyCustomMessage.fromJson(Map<String, dynamic> json)
      : super(
    UserModel.fromJson(json['author'] as Map<String, dynamic>),
    json['createdAt'] as int?,
    json['id'] as String,
    json['metadata'] as Map<String, dynamic>?,
    json['roomId'] as String?,
    getMyStatusFromString(json['myStatus'] as String?),
    MyMessageType.custom,
    json['updatedAt'] as int?,
  );

  /// Converts a custom message to the map representation,
  /// encodable to JSON.
  @override
  Map<String, dynamic> toJson() => {
    'author': author.toJson(),
    'createdAt': createdAt,
    'id': id,
    'metadata': metadata,
    'roomId': roomId,
    'myStatus': myStatus?.toString().split('.').last,
    'type': MyMessageType.custom.toMyShortString(),
    'updatedAt': updatedAt,
  };

  /// Creates a copy of the custom message with an updated data.
  /// [metadata] with null value will nullify existing metadata, otherwise
  /// both metadatas will be merged into one Map, where keys from a passed
  /// metadata will overwite keys from the previous one.
  /// [previewData] is ignored for this message type.
  /// [status] with null value will be overwritten by the previous status.
  /// [text] is ignored for this message type.
  /// [updatedAt] with null value will nullify existing value.
  @override
 MyMessage copyWith({
    Map<String, dynamic>? metadata,
    PreviewData? previewData,
    MyStatus? myStatus,
    String? text,
    int? updatedAt,
  }) {
    return MyCustomMessage(
      author: author,
      createdAt: createdAt,
      id: id,
      metadata: metadata == null
          ? null
          : {
        ...this.metadata ?? {},
        ...metadata,
      },
      roomId: roomId,
      myStatus: myStatus ?? this.myStatus,
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
    roomId,
    myStatus,
    updatedAt,
  ];
}
