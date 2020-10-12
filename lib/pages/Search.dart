/*
 * @Author: your name
 * @Date: 2020-10-09 12:04:48
 * @LastEditTime: 2020-10-09 12:06:01
 * @LastEditors: your name
 * @Description: In User Settings Edit
 * @FilePath: /flutter_jdshop/lib/pages/Search.dart
 */
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('搜索'),
      ),
      body: Text('搜索'),
    );
  }
}
