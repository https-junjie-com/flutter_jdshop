/*
 * @Author: your name
 * @Date: 2020-10-09 11:31:13
 * @LastEditTime: 2020-10-10 17:02:28
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter_jdshop/lib/pages/tabs/Tab.dart
 */
import 'package:flutter/material.dart';
import '../Home/Home.dart';
import '../Category/Category.dart';
import '../Cart/Cart.dart';
import '../User/User.dart';

class Tabs extends StatefulWidget {
  Tabs({Key key}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 1;
  List<Widget> _pageList = [
    HomePage(),
    CategoryPage(),
    CartPage(),
    UeserPage(),
  ];
  PageController _pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._pageController = PageController(initialPage: this._currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('京东'),
      ),
      body: PageView(
        controller: this._pageController,
        children: this._pageList,
        onPageChanged: (e) {},
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this._currentIndex,
        onTap: (e) {
          setState(() {
            this._currentIndex = e;
            this._pageController.jumpToPage(e);
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: '分类'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: '购物车'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: '我的'),
        ],
        selectedItemColor: Colors.red,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
    );
  }
}
