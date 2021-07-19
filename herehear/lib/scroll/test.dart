import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/scroll/scroll_controller.dart';



class InfiniteScrollView extends GetView<InfiniteScrollController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Infinite Scroll'),
      ),
      body: Obx(
            () => ListView.separated(
          controller: controller.scrollController.value,
          itemBuilder: (_, index) {
            print(controller.hasMore.value);

            if (index < controller.data.length) {
              var datum = controller.data[index];
              return ListTile(
                title: Text('$datum 번째 데이터'),
              );
            }

            if (controller.hasMore.value || controller.isLoading.value) {
              return Center(child: RefreshProgressIndicator());
            }

            return Container(
              child: Center(
                child: Text('데이터의 마지막 입니다.'),
              ),
            );
          },
          separatorBuilder: (_, index) => Divider(),
          itemCount: controller.data.length + 1,
        ),
      ),
    );
  }
}