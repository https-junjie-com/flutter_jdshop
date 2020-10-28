/*
 * @Author: your name
 * @Date: 2020-10-09 15:20:57
 * @LastEditTime: 2020-10-27 10:15:54
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter_jdshop/lib/setvices/ScreenAdapter.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenAdapter {
  static init(context) {
    ScreenUtil.init(context,
        designSize: Size(750, 1334), allowFontScaling: false);
  }

  static height(double e) {
    return e.h;
  }

  static width(double e) {
    return e.w;
  }

  static getScreenHeight() {
    return 1.hp;
  }

  static getScreenWidth() {
    return 1.wp;
  }

  static size(double size) {
    return ScreenUtil().setSp(size, allowFontScalingSelf: true);
  }

  static getBarHeight() {
    return ScreenUtil().statusBarHeight;
  }

  static getBottomHeight() {
    return ScreenUtil().bottomBarHeight;
  }
}
