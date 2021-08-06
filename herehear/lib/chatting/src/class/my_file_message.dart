import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'my_message.dart';
import 'package:herehear/chatting/util.dart';
import 'package:herehear/users/data/user_model.dart';
import 'package:meta/meta.dart';



/// A class that represents file message.
@immutable
class MyFileMessage extends MyMessage {
  /// Creates a file message.
  const MyFileMessage({
    required UserModel author,
    int? createdAt,
    required String id,
    Map<String, dynamic>? metadata,
    this.mimeType,
    required this.name,
    String? roomId,
    required this.size,
    MyStatus? myStatus,
    int? updatedAt,
    required this.uri,
  }) : super(
    author,
    createdAt,
    id,
    metadata,
    roomId,
    myStatus,
    MyMessageType.file,
    updatedAt,
  );

  /// Creates a full file message from a partial one.
  MyFileMessage.fromPartial({
    required UserModel author,
    int? createdAt,
    required String id,
    Map<String, dynamic>? metadata,
    required PartialFile partialFile,
    String? roomId,
    MyStatus? myStatus,
    int? updatedAt,
  })  : mimeType = partialFile.mimeType,
        name = partialFile.name,
        size = partialFile.size,
        uri = partialFile.uri,
        super(
        author,
        createdAt,
        id,
        metadata,
        roomId,
        myStatus,
        MyMessageType.file,
        updatedAt,
      );

  /// Creates a file message from a map (decoded JSON).
  MyFileMessage.fromJson(Map<String, dynamic> json)
      : mimeType = json['mimeType'] as String?,
        name = json['name'] as String,
        size = json['size'].round() as int,
        uri = json['uri'] as String,
        super(
        UserModel.fromJson(json['author'] as Map<String, dynamic>),
        json['createdAt'] as int?,
        json['id'] as String,
        json['metadata'] as Map<String, dynamic>?,
        json['roomId'] as String?,
        getMyStatusFromString(json['myStatus'] as String?),
        MyMessageType.file,
        json['updatedAt'] as int?,
      );

  /// Converts a file message to the map representation, encodable to JSON.
  @override
  Map<String, dynamic> toJson() => {
    'author': author.toJson(),
    'createdAt': createdAt,
    'id': id,
    'metadata': metadata,
    'mimeType': mimeType,
    'name': name,
    'roomId': roomId,
    'size': size,
    'myStatus': myStatus?.toMyShortString(),
    'type': MyMessageType.file.toMyShortString(),
    'updatedAt': updatedAt,
    'uri': uri,
  };

  /// Creates a copy of the file message with an updated data.
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
    return MyFileMessage(
      author: author,
      createdAt: createdAt,
      id: id,
      metadata: metadata == null
          ? null
          : {
        ...this.metadata ?? {},
        ...metadata,
      },
      mimeType: mimeType,
      name: name,
      roomId: roomId,
      size: size,
      myStatus: myStatus ?? this.myStatus,
      updatedAt: updatedAt,
      uri: uri,
    );
  }

  /// Equatable props
  @override
  List<Object?> get props => [
    author,
    createdAt,
    id,
    metadata,
    mimeType,
    name,
    roomId,
    size,
    myStatus,
    updatedAt,
    uri,
  ];

  /// Media type
  final String? mimeType;

  /// The name of the file
  final String name;

  /// Size of the file in bytes
  final int size;

  /// The file source (either a remote URL or a local resource)
  final String uri;
}
