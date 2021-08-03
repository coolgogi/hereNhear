import 'package:flutter/cupertino.dart';

class SearchHistoryModel {
  List<String>? searchHistoryList;

  SearchHistoryModel({
    this.searchHistoryList
  });

  Map<String, dynamic> toMap() {
    return {
      'searchHistoryList': this.searchHistoryList,
    };
  }

  SearchHistoryModel.fromJson(Map<String, dynamic> json, String docId)
      : searchHistoryList = json['searchHistoryList'] as List<String>;
}

List<String>? searchHistoryExample = [
  '한동대',
  '친목도모',
  '유리한 녀석들',
  '캡스톤',
  '우리 모두 파이팅',
  '여름이였다',
  '여행',
  '가고 싶다',
  '바다',
  '인브리즈 커피 굿',
];
