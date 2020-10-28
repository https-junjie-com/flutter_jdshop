/*
 * @Author: your name
 * @Date: 2020-10-27 19:59:10
 * @LastEditTime: 2020-10-28 11:43:25
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter_jdshop/lib/services/SearchServices.dart
 */
import 'dart:convert';
import '../services/Storage.dart';

class SearchServices {
  static setHistoryList(keywords) async {
    try {
      List searchListData = json.decode(await Storage.getString('searchList'));
      var isHaveData = searchListData.any((element) => element == keywords);
      if (!isHaveData) {
        searchListData.add(keywords);
        await Storage.setString('searchList', json.encode(searchListData));
      }
    } catch (e) {
      List tempList = List();
      tempList.add(keywords);
      await Storage.setString('searchList', json.encode(tempList));
    }
  }

  static getHistoryList() async {
    try {
      List searchListData =
          json.decode(await Storage.getString('searchList')).cast<String>();
      return searchListData;
    } catch (e) {
      return [];
    }
  }

  static removeHistoryList(keywords) async {
    List searchListData =
        json.decode(await Storage.getString('searchList')).cast<String>();
    searchListData.remove(keywords);
    await Storage.setString('searchList', json.encode(searchListData));
  }

  static clearHistoryList() async {
    await Storage.remove('searchList');
  }
}
