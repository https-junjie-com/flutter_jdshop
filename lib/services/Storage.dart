/*
 * @Author: your name
 * @Date: 2020-10-27 17:24:04
 * @LastEditTime: 2020-10-27 20:07:33
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter_jdshop/lib/services/Storage.dart
 */
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future<void> setString(key, value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(key, value);
  }

  static Future<String> getString(key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  static Future<void> remove(key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove(key);
  }

  static Future<void> clear() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }
}
