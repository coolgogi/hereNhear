import 'package:equatable/equatable.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:herehear/chatting/src/class/my_custom_message.dart';
import 'package:herehear/chatting/src/class/my_file_message.dart';
import 'package:herehear/chatting/src/class/my_image_message.dart';
import 'package:herehear/chatting/src/class/my_text_message.dart';
import 'my_unsupported_message.dart';
import 'package:herehear/users/data/user_model.dart';
import 'package:meta/meta.dart';



/// All possible message types.
enum MyMessageType { custom, file, image, text, unsupported }

/// Extension with one [toShortString] method
extension MyMessageTypeToShortString on MyMessageType {
  /// Converts enum to the string equal to enum's name
  String toMyShortString() {
    return toString().split('.').last;
  }
}

/// All possible statuses message can have.
enum MyStatus { delivered, error, seen, sending, sent }

/// Extension with one [toShortString] method
extension MyStatusToShortString on MyStatus {
  /// Converts enum to the string equal to enum's name
  String toMyShortString() {
    return toString().split('.').last;
  }
}

/// An abstract class that contains all variables and methods
/// every message will have.
@immutable
abstract class MyMessage extends Equatable {
  const MyMessage(
      this.author,
      this.createdAt,
      this.id,
      this.metadata,
      this.roomId,
      this.myStatus,
      this.type,
      this.updatedAt,
      );

  /// Creates a particular message from a map (decoded JSON).
  /// Type is determined by the `type` field.
  factory MyMessage.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;

    switch (type) {
      case 'custom':
        return MyCustomMessage.fromJson(json);
      case 'file':
        return MyFileMessage.fromJson(json);
      case 'image':
        return MyImageMessage.fromJson(json);
      case 'text':
        return MyTextMessage.fromJson(json);
      default:
        return MyUnsupportedMessage.fromJson(json);
    }
  }

  /// Creates a copy of the message with an updated data
  /// [metadata] with null value will nullify existing metadata, otherwise
  /// both metadatas will be merged into one Map, where keys from a passed
  /// metadata will overwite keys from the previous one.
  /// [previewData] will be only set for the text message type.
  /// [status] with null value will be overwritten by the previous status.
  /// [text] will be only set for the text message type. Null value will be
  /// overwritten by the previous text (can't be empty).
  /// [updatedAt] with null value will nullify existing value.
  MyMessage copyWith({
    Map<String, dynamic>? metadata,
    PreviewData? previewData,
    MyStatus? myStatus,
    String? text,
    int? updatedAt,
  });

  /// Converts a particular message to the map representation, encodable to JSON.
  Map<String, dynamic> toJson();

  /// User who sent this message
  final UserModel author;

  /// Created message timestamp, in ms
  final int? createdAt;

  /// Unique ID of the message
  final String id;

  /// Additional custom metadata or attributes related to the message
  final Map<String, dynamic>? metadata;

  /// ID of the room where this message is sent
  final String? roomId;

  /// Message [Status]
  final MyStatus? myStatus;

  /// [MessageType]
  final MyMessageType type;

  /// Updated message timestamp, in ms
  final int? updatedAt;
}
