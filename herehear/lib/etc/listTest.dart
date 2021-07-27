import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/bottomNavigationBar/create_broadcast.dart';
import 'package:herehear/bottomNavigationBar/create_groupcall.dart';
import 'package:herehear/appBar/searchBar.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InfiniteScrollController());
  }
}

class InfiniteScrollView extends GetView<InfiniteScrollController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Herehear'),
          actions: <Widget>[
            IconButton(
                onPressed: _showMyDialog,
                color: Colors.amber,
                icon: Icon(Icons.add_circle)),
            IconButton(
                onPressed: null,
                color: Colors.black87,
                icon: Icon(Icons.notifications_none_outlined)),
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black87,
              ),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: PostSearchDelegate(),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 18.0),
          child: Obx(
            () => ListView.separated(
              shrinkWrap: false,
              controller: controller.scrollController.value,
              itemBuilder: (_, index) {
                print(controller.hasMore.value);
                if (index < controller.data.length) {
                  var datum = controller.data[index];
                  return
                      // Material(
                      // elevation: 10.0,
                      // child:
                      Container(
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            leading:
                                Icon(Icons.circle_rounded, color: Colors.amber),
                            title: Text('$datum 번째 Group Call'),
                            trailing: Icon(Icons.arrow_forward_outlined),
                            onTap: _joinDialog,
                          ));
                  // );
                }
                if (controller.hasMore.value || controller.isLoading.value) {
                  return Center(child: RefreshProgressIndicator());
                }
                return Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text('데이터의 마지막 입니다'),
                        IconButton(
                          onPressed: () {
                            controller.reload();
                          },
                          icon: Icon(Icons.refresh_outlined),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, index) => Divider(
                height: 1,
              ),
              itemCount: controller.data.length + 1,
            ),
          ),
        ));
  }

  Future<void> _showMyDialog() async {
    return Get.defaultDialog(
      title: '소리 시작하기',
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextButton(
              child: Text(
                '개인 라이브',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              onPressed: () => Get.off(() => CreateBroadcastPage()),
            ),
            TextButton(
              child: Text(
                '그룹 대화',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              onPressed: () => Get.off(() => CreateGroupCallPage()),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _joinDialog() async {
    return Get.defaultDialog(
      title: '소리 참여하기',
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextButton(
              child: Text(
                '확인',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              onPressed: () => Get.off(() => CreateBroadcastPage()),
            ),
          ],
        ),
      ),
      onCancel: () => Get.off(() => Container()),
      cancelTextColor: Colors.red,
      textCancel: '취소',
    );
  }
}

class InfiniteScrollController extends GetxController {
  var scrollController = ScrollController().obs;
  var data = <int>[].obs;
  var isLoading = false.obs;
  var hasMore = false.obs;
  @override
  void onInit() {
    _getData();
    this.scrollController.value.addListener(() {
      if (this.scrollController.value.position.pixels ==
              this.scrollController.value.position.maxScrollExtent &&
          this.hasMore.value) {
        _getData();
      }
    });
    super.onInit();
  }

  _getData() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2));
    int offset = data.length;
    var appendData = List<int>.generate(10, (i) => i + 1 + offset);
    data.addAll(appendData);
    isLoading.value = false;
    hasMore.value = data.length < 30;
  }

  reload() async {
    isLoading.value = true;
    data.clear();
    await Future.delayed(Duration(seconds: 2));
    _getData();
  }
}
