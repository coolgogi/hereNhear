import 'package:flutter/widgets.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:herehear/users/data/user_model.dart' as types;

/// Used to make provided [types.User] class available through the whole package
class InheritedUser extends InheritedWidget {
  /// Creates [InheritedWidget] from a provided [types.User] class
  const InheritedUser({
    Key? key,
    required this.user,
    required Widget child,
  }) : super(key: key, child: child);

  /// Represents current logged in user. Used to determine message's author.
  final types.UserModel user;

  static InheritedUser of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedUser>()!;
  }

  @override
  bool updateShouldNotify(InheritedUser oldWidget) =>
      user.uid != oldWidget.user.uid;
}
