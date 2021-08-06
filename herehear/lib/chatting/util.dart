// import 'message.dart' show Status;
// import 'user.dart' show Role;
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:herehear/broadcast/broadcast_model.dart' show MyRoomType;
import 'package:herehear/users/data/user_model.dart' show MyRole;
import 'package:herehear/chatting/src/class/my_message.dart';

/// Converts [stringStatus] to the [Status] enum.
MyStatus? getMyStatusFromString(String? stringStatus) {
  for (final myStatus in MyStatus.values) {
    if (myStatus.toString() == 'Status.$stringStatus') {
      return myStatus;
    }
  }

  return null;
}

/// Converts [stringRole] to the [Role] enum.
MyRole? getMyRoleFromString(String? stringRole) {
  for (final myRole in MyRole.values) {
    if (myRole.toString() == 'Role.$stringRole') {
      return myRole;
    }
  }

  return null;
}

/// Converts [stringRoomType] to the [RoomType] enum.
MyRoomType getMyRoomTypeFromString(String stringRoomType) {
  for (final myRoomType in MyRoomType.values) {
    if (myRoomType.toString() == 'MyRoomType.$stringRoomType') {
      return myRoomType;
    }
  }

  return MyRoomType.unsupported;
}
