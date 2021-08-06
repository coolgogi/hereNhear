import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'my_message.dart';
import 'package:herehear/chatting/util.dart';
import 'package:herehear/users/data/user_model.dart';
import 'package:meta/meta.dart';


/// A class that represents image message.
@immutable
class MyImageMessage extends MyMessage {
  /// Creates an image message.
  const MyImageMessage({
    required UserModel author,
    int? createdAt,
    this.height,
    required String id,
    Map<String, dynamic>? metadata,
    required this.name,
    String? roomId,
    required this.size,
    MyStatus? myStatus,
    int? updatedAt,
    required this.uri,
    this.width,
  }) : super(
    author,
    createdAt,
    id,
    metadata,
    roomId,
    myStatus,
    MyMessageType.image,
    updatedAt,
  );

  /// Creates a full image message from a partial one.
  MyImageMessage.fromPartial({
    required UserModel author,
    int? createdAt,
    required String id,
    Map<String, dynamic>? metadata,
    required PartialImage partialImage,
    String? roomId,
    MyStatus? status,
    int? updatedAt,
  })  : height = partialImage.height,
        name = partialImage.name,
        size = partialImage.size,
        uri = partialImage.uri,
        width = partialImage.width,
        super(
        author,
        createdAt,
        id,
        metadata,
        roomId,
        status,
        MyMessageType.image,
        updatedAt,
      );

  /// Creates an image message from a map (decoded JSON).
  MyImageMessage.fromJson(Map<String, dynamic> json)
      : height = json['height']?.toDouble() as double?,
        name = json['name'] as String,
        size = json['size'].round() as int,
        uri = json['uri'] as String,
        width = json['width']?.toDouble() as double?,
        super(
        UserModel.fromJson(json['author'] as Map<String, dynamic>),
        json['createdAt'] as int?,
        json['id'] as String,
        json['metadata'] as Map<String, dynamic>?,
        json['roomId'] as String?,
        getMyStatusFromString(json['myStatus'] as String?),
        MyMessageType.image,
        json['updatedAt'] as int?,
      );

  /// Converts an image message to the map representation, encodable to JSON.
  @override
  Map<String, dynamic> toJson() => {
    'author': author.toJson(),
    'createdAt': createdAt,
    'height': height,
    'id': id,
    'metadata': metadata,
    'name': name,
    'roomId': roomId,
    'size': size,
    'myStatus': myStatus?.toMyShortString(),
    'type': MyMessageType.image.toMyShortString(),
    'updatedAt': updatedAt,
    'uri': uri,
    'width': width,
  };

  /// Creates a copy of the image message with an updated data
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
    return MyImageMessage(
      author: author,
      createdAt: createdAt,
      height: height,
      id: id,
      name: name,
      metadata: metadata == null
          ? null
          : {
        ...this.metadata ?? {},
        ...metadata,
      },
      roomId: roomId,
      size: size,
      myStatus: myStatus ?? this.myStatus,
      updatedAt: updatedAt,
      uri: uri,
      width: width,
    );
  }

  /// Equatable props
  @override
  List<Object?> get props => [
    author,
    createdAt,
    height,
    id,
    metadata,
    name,
    roomId,
    size,
    myStatus,
    updatedAt,
    uri,
    width,
  ];

  /// Image height in pixels
  final double? height;

  /// The name of the image
  final String name;

  /// Size of the image in bytes
  final int size;

  /// The image source (either a remote URL or a local resource)
  final String uri;

  /// Image width in pixels
  final double? width;
}
