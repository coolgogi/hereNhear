import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:herehear/users/data/user_model.dart';
import 'package:meta/meta.dart';
import 'my_message.dart';
import '../../util.dart';

import '../util.dart' show getStatusFromString;

/// A class that represents unsupported message. Used for backwards
/// compatibility. If chat's end user doesn't update to a new version
/// where new message types are being sent, some of them will result
/// to unsupported.
@immutable
class MyUnsupportedMessage extends MyMessage {
  /// Creates an unsupported message.
  const MyUnsupportedMessage({
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
    MyMessageType.unsupported,
    updatedAt,
  );

  /// Creates an unsupported message from a map (decoded JSON).
  MyUnsupportedMessage.fromJson(Map<String, dynamic> json)
      : super(
    UserModel.fromJson(json['author'] as Map<String, dynamic>),
    json['createdAt'] as int?,
    json['id'] as String,
    json['metadata'] as Map<String, dynamic>?,
    json['roomId'] as String?,
    getMyStatusFromString(json['myStatus'] as String?),
    MyMessageType.unsupported,
    json['updatedAt'] as int?,
  );

  /// Converts an unsupported message to the map representation,
  /// encodable to JSON.
  @override
  Map<String, dynamic> toJson() => {
    'author': author.toJson(),
    'createdAt': createdAt,
    'id': id,
    'metadata': metadata,
    'roomId': roomId,
    'status': myStatus?.toMyShortString(),
    'type': MyMessageType.unsupported.toMyShortString(),
    'updatedAt': updatedAt,
  };

  /// Creates a copy of the unsupported message with an updated data.
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
    return MyUnsupportedMessage(
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
