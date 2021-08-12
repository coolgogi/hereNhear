import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:herehear/bottomNavigationBar/search/searchBar_controller.dart';

class SearchTextField extends StatelessWidget {
  final searchController = Get.put(SearchBarController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: 25.0.w, top: 10.h, right: 22.0.w, bottom: 14.h),
      child: Container(
        height: 33.0.h,
        child: TextField(
          keyboardType: TextInputType.text,
          controller: searchController.textController.value,
          focusNode: searchController.searchBarFocusNode.value,
          onChanged: (value) {
            searchController.text.value =
                searchController.textController.value.text;
          },
          autofocus: true,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFE9E9E9),

            hintText: '검색어를 입력하세요',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: Color(0xFFE9E9E9),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: Color(0xFFE9E9E9),
              ),
            ),
            suffixIconConstraints: BoxConstraints(
              maxWidth: 33.0.w,
              maxHeight: 22.0.h,
            ),
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 13.w),
              child: Obx(() => InkWell(
                  child: searchController.text.isEmpty? Image.asset('assets/icons/search.png') 
                      : Icon(Icons.close, color: Theme.of(context).colorScheme.primaryVariant.withOpacity(0.5), size: 20.w),
                  onTap: (){
                    searchController.history.insert(0, searchController.textController.value.text);
                    searchController.saveHistory();
                    searchController.textController.value.clear();
                  })),
            ),
            contentPadding: EdgeInsets.only(
              left: 16.w,
              right: 25.w,
            ),
          ),
        ),
      ),
    );
  }
}
