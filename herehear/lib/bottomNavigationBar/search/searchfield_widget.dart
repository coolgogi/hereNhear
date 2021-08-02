import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField(this.controller, this.focusNode);

  final TextEditingController controller;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 25.0.w,
          top: 10.h,
          right: 22.0.w,
          bottom: 20.h
      ),
      child: Container(
        height: 33.0.h,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: true,
          style: TextStyle(fontSize: 16.sp, color: Colors.grey[600],),
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFE9E9E9),
            hintText: '검색어를 입력하세요',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)
              ),
              borderSide: BorderSide(
                color: Color(0xFFE9E9E9),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)
              ),
              borderSide: BorderSide(
                color: Color(0xFFE9E9E9),
              ),
            ),
            suffixIcon: Image.asset('assets/icons/search2.png'),
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