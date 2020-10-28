/*
 * @Author: your name
 * @Date: 2020-10-09 12:04:48
 * @LastEditTime: 2020-10-28 11:46:55
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter_jdshop/lib/pages/Search.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter_jdshop/services/ScreenAdapter.dart';
import 'package:flutter_jdshop/services/SearchServices.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> _searchList = [
    '漂亮女装',
    '可爱童装',
    '修身男装',
    '精选孕妇装',
    '端庄老年装',
  ];

  //搜索字段
  String _keywords;

  List _searchHistoryList = [];
  @override
  void initState() {
    super.initState();
    this._getSearchHistoryList();
  }

  _getSearchHistoryList() async {
    var _searchHistoryList = await SearchServices.getHistoryList();
    setState(() {
      this._searchHistoryList = _searchHistoryList;
    });
  }

  // ! 搜索
  Widget _searchWidget() {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          margin: EdgeInsets.all(ScreenAdapter.width(10)),
          decoration: BoxDecoration(
            color: Color.fromRGBO(233, 233, 233, 0.9),
            borderRadius: BorderRadius.circular(ScreenAdapter.height(30)),
          ),
          child: Text(
            '漂亮女装',
            style: TextStyle(
              fontSize: ScreenAdapter.size(28),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          margin: EdgeInsets.all(ScreenAdapter.width(10)),
          decoration: BoxDecoration(
            color: Color.fromRGBO(233, 233, 233, 0.9),
            borderRadius: BorderRadius.circular(ScreenAdapter.height(30)),
          ),
          child: Text(
            '可爱童装',
            style: TextStyle(
              fontSize: ScreenAdapter.size(28),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          margin: EdgeInsets.all(ScreenAdapter.width(10)),
          decoration: BoxDecoration(
            color: Color.fromRGBO(233, 233, 233, 0.9),
            borderRadius: BorderRadius.circular(ScreenAdapter.height(30)),
          ),
          child: Text(
            '修身男装',
            style: TextStyle(
              fontSize: ScreenAdapter.size(28),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          margin: EdgeInsets.all(ScreenAdapter.width(10)),
          decoration: BoxDecoration(
            color: Color.fromRGBO(233, 233, 233, 0.9),
            borderRadius: BorderRadius.circular(ScreenAdapter.height(30)),
          ),
          child: Text(
            '精选孕妇装',
            style: TextStyle(
              fontSize: ScreenAdapter.size(28),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          margin: EdgeInsets.all(ScreenAdapter.width(10)),
          decoration: BoxDecoration(
            color: Color.fromRGBO(233, 233, 233, 0.9),
            borderRadius: BorderRadius.circular(ScreenAdapter.height(30)),
          ),
          child: Text(
            '端庄老年装',
            style: TextStyle(
              fontSize: ScreenAdapter.size(28),
            ),
          ),
        ),
      ],
    );
  }

  // !历史搜索
  Widget _searchHistoryWidget() {
    return this._searchHistoryList.length > 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                width: double.infinity,
                height: ScreenAdapter.height(20),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(233, 233, 233, 0.9),
                  border: Border.all(color: Colors.black12, width: 1),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                padding: EdgeInsets.all(ScreenAdapter.width(10)),
                child:
                    Text('历史搜索', style: Theme.of(context).textTheme.headline6),
              ),
              Column(
                children: this
                    ._searchHistoryList
                    .map<Widget>((e) => Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            ListTile(
                              title: Text('$e'),
                              onLongPress: () {
                                this._showAlertDialog('$e');
                              },
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                width: ScreenAdapter.getScreenWidth() - 20,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.5,
                                        color:
                                            Color.fromRGBO(200, 200, 200, 1))),
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ),
              SizedBox(
                height: ScreenAdapter.height(50),
              ),
              this._delegateSearchHistoryWidget(),
            ],
          )
        : Text('');
  }

  // ! 提示框
  _showAlertDialog(keywords) async {
    var result = await showDialog(
        barrierDismissible: false, //表示点击灰色背景的时候是否消失弹出框
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("提示信息!"),
            content: Text("您确定要删除吗?"),
            actions: <Widget>[
              FlatButton(
                child: Text("取消"),
                onPressed: () {
                  print("取消");
                  Navigator.pop(context, 'Cancle');
                },
              ),
              FlatButton(
                child: Text("确定"),
                onPressed: () async {
                  //注意异步
                  await SearchServices.removeHistoryList(keywords);
                  this._getSearchHistoryList();
                  Navigator.pop(context, "Ok");
                },
              )
            ],
          );
        });

    //  print(result);
  }

  // ! 删除搜索历史
  Widget _delegateSearchHistoryWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () async {
            await SearchServices.clearHistoryList();
            this._getSearchHistoryList();
          },
          child: Container(
            margin: EdgeInsets.only(left: ScreenAdapter.width(50)),
            width: ScreenAdapter.getScreenWidth() - ScreenAdapter.width(100),
            height: ScreenAdapter.height(64),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black45,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.delete_outline), Text('清空搜索历史')],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: '笔记本',
              contentPadding: EdgeInsets.all(10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ScreenAdapter.height(30)),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (e) {
              setState(() {
                this._keywords = e;
              });
            },
          ),
          height: ScreenAdapter.height(60),
          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
          decoration: BoxDecoration(
            color: Color.fromRGBO(233, 233, 233, 0.8),
            borderRadius: BorderRadius.circular(ScreenAdapter.height(30)),
          ),
        ),
        actions: [
          Container(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.only(right: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '搜索',
                            style: TextStyle(
                                fontSize: ScreenAdapter.size(28),
                                color: Colors.black54),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      SearchServices.setHistoryList(this._keywords);
                      Navigator.pushReplacementNamed(context, '/productList',
                          arguments: {
                            'keywords': this._keywords,
                          });
                    },
                  ),
                ),
              ],
            ),
          )
        ],
        elevation: 0,
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(ScreenAdapter.width(10)),
            child: Text('热搜', style: Theme.of(context).textTheme.headline6),
          ),
          Divider(),
          this._searchWidget(),
          this._searchHistoryWidget(),
        ],
      ),
    );
  }
}
