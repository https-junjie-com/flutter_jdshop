/*
 * @Author: your name
 * @Date: 2020-10-09 11:43:01
 * @LastEditTime: 2020-10-10 17:26:52
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter_jdshop/lib/pages/Category.dart
 */
import 'package:flutter/material.dart';
import '../../services/ScreenAdapter.dart';
import '../../model/CategoryModel.dart';
import 'package:dio/dio.dart';
import '../../config/Config.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with AutomaticKeepAliveClientMixin {
  int _selectIndex = 0;
  List _leftCategoryDataList = [];
  List _rightCategoryDataList = [];
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getLeftCategoryData();
  }

  // !左侧数据
  _getLeftCategoryData() async {
    String api = '${Config.domain}api/pcate';
    var response = await Dio().get(api);
    var leftCategoryList = CategoryModel.fromJson(response.data);
    setState(() {
      this._leftCategoryDataList = leftCategoryList.result;
    });
    _getRightCategoryData(leftCategoryList.result[0].sId);
  }

  // !右侧数据
  _getRightCategoryData(pid) async {
    String api = '${Config.domain}api/pcate?pid=$pid';
    var response = await Dio().get(api);
    var rightCategoryList = CategoryModel.fromJson(response.data);
    setState(() {
      this._rightCategoryDataList = rightCategoryList.result;
    });
  }

  // !左侧选择栏
  Widget _leftSelectionBar(leftWidth) {
    if (this._leftCategoryDataList.length > 0) {
      return Container(
        width: leftWidth,
        height: double.infinity,
        child: ListView.builder(
          itemCount: this._leftCategoryDataList.length,
          itemBuilder: (BuildContext context, int index) {
            CategoryItemModel leftCategoryItemModel =
                this._leftCategoryDataList[index];
            return Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    setState(() {
                      this._selectIndex = index;
                      this._getRightCategoryData(leftCategoryItemModel.sId);
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: ScreenAdapter.height(84),
                    padding: EdgeInsets.only(top: ScreenAdapter.height(24)),
                    color: this._selectIndex == index
                        ? Color.fromRGBO(240, 246, 246, 0.9)
                        : Colors.white,
                    child: Text(
                      '${leftCategoryItemModel.title}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                ),
              ],
            );
          },
        ),
      );
    } else {
      return Container(width: leftWidth, height: double.infinity);
    }
  }

  // !右侧选择栏
  Widget _rightSelectionBar(rightItemWidth, rightItemHeight) {
    if (this._rightCategoryDataList.length > 0) {
      return Expanded(
        flex: 1,
        child: Container(
          padding: EdgeInsets.all(10),
          height: double.infinity,
          color: Color.fromRGBO(240, 246, 246, 0.9),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: rightItemWidth / rightItemHeight,
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: this._rightCategoryDataList.length,
            itemBuilder: (context, index) {
              CategoryItemModel rightCategoryItemModel =
                  this._rightCategoryDataList[index];
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/productList', arguments: {
                    'sid': rightCategoryItemModel.sId,
                  });
                },
                child: Container(
                  child: Column(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Image.network(
                          '${Config.domain}${rightCategoryItemModel.pic.replaceAll('\\', '/')}',
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        color: Color.fromRGBO(246, 240, 240, 0),
                        height: ScreenAdapter.height(28),
                        width: double.infinity,
                        child: Text(
                          '${rightCategoryItemModel.title}',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      return Expanded(
          flex: 1,
          child: Container(
              padding: EdgeInsets.all(10),
              height: double.infinity,
              color: Color.fromRGBO(240, 246, 246, 0.9)));
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    //计算右侧GridView宽高比
    //左侧宽度
    var leftWidth = ScreenAdapter.getScreenWidth() / 4;
    //右侧每一项宽度=（总宽度-左侧宽度-GridView外侧元素左右的Padding值-GridView中间的间距）/3
    var rightItemWidth =
        (ScreenAdapter.getScreenWidth() - leftWidth - 20 - 20) / 3;
    //获取计算后的宽度
    rightItemWidth = ScreenAdapter.width(rightItemWidth);
    //获取计算后的高度
    var rightItemHeight = rightItemWidth + ScreenAdapter.height(28);
    return Row(
      children: [
        _leftSelectionBar(leftWidth),
        _rightSelectionBar(rightItemWidth, rightItemHeight),
      ],
    );
  }
}
