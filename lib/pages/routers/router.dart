/*
 * @Author: your name
 * @Date: 2020-10-09 11:52:57
 * @LastEditTime: 2020-10-10 17:21:02
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter_jdshop/lib/routers/router.dart
 */
import 'package:flutter/material.dart';
import '../tabs/Tabs.dart';
import '../Search.dart';
import '../Category/ProductList.dart';

//! 配置路由
final routes = {
  '/': (ontext) => Tabs(),
  '/search': (ontext) => SearchPage(),
  '/productList': (ontext, {arguments}) =>
      ProductListPage(arguments: arguments),
};
//!固定写法
// ignore: top_level_function_literal_block
var onGenerateRoute = (RouteSettings settings) {
  //!统一处理
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null && settings.arguments != null) {
    final Route route = MaterialPageRoute(
        builder: (context) =>
            pageContentBuilder(context, arguments: settings.arguments));
    return route;
  } else {
    final Route route =
        MaterialPageRoute(builder: (context) => pageContentBuilder(context));
    return route;
  }
};
