// actions: <Widget>[
// locationController.count > 0
// ? Badge(
// badgeContent: Text(locationController.count.toString(),
// style: TextStyle(color: Colors.white, fontSize: 11)),
// position: BadgePosition.topEnd(top: 0, end: 5),
// child: IconButton(
// onPressed: () => Get.to(() => NotificationPage()),
// color: Colors.black87,
// icon: Image.asset('assets/icons/notification.png'),
// iconSize: 20.w,
// ),
// )
// : IconButton(
// onPressed: () => Get.to(() => NotificationPage()),
// // => Get.off(() => Notification()),
// color: Colors.black87,
// icon: Image.asset('assets/icons/notification.png'),
// iconSize: 20.w,
// ),
// Padding(
// padding: EdgeInsets.only(right: 8.0.w),
// child: IconButton(
// icon: Image.asset('assets/icons/search.png'),
// iconSize: 20.w,
// onPressed: () {
// showSearch(
// context: context,
// delegate: PostSearchDelegate(),
// );
// },
// ),
// ),
// ],