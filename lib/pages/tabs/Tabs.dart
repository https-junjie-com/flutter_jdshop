/*
 * @Author: your name
 * @Date: 2020-10-09 11:31:13
 * @LastEditTime: 2020-10-27 16:17:47
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
      appBar: this._currentIndex != 3
          ? AppBar(
              title: InkWell(
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        size: 15,
                        color: Colors.black54,
                      ),
                      Text(
                        '笔记本',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: Color.fromRGBO(233, 233, 233, 0.8),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 8.0,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/search');
                },
              ),
              elevation: 0,
              leading: IconButton(
                  icon: Icon(
                    Icons.center_focus_weak,
                    size: 30,
                    color: Colors.black54,
                  ),
                  onPressed: () {}),
              actions: [
                Container(
                  child: IconButton(
                      icon: Icon(
                        Icons.message,
                        size: 30,
                        color: Colors.black54,
                      ),
                      onPressed: () {}),
                )
              ],
            )
          : AppBar(
              title: Text('用户中心'),
              elevation: 0,
            ),
      body: PageView(
        controller: this._pageController,
        children: this._pageList,
        onPageChanged: (e) {},
        physics: NeverScrollableScrollPhysics(),
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
