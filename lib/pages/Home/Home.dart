/*
 * @Author: your name
 * @Date: 2020-10-09 11:41:51
 * @LastEditTime: 2020-10-10 16:46:33
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter_jdshop/lib/pages/Home/Home.dart
 */
import 'package:flutter/material.dart';
import '../../model/FocusModel.dart';
import '../../model/ProductModel.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../../services/ScreenAdapter.dart';
import 'package:dio/dio.dart';
import '../../config/Config.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  List _focusDataList = []; //轮播列表
  List _relatedProductDataList = []; //猜你喜欢列表
  List _hotProductDataList = []; //热门推荐
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getFocusData();
    _getRelatedProduct();
    _hotRelatedProduct();
  }

  //!获取轮播图数据
  _getFocusData() async {
    String api = '${Config.domain}api/focus';
    var response = await Dio().get(api);
    var focusList = FocusModel.fromJson(response.data);
    setState(() {
      this._focusDataList = focusList.result;
    });
  }

  //!获取猜你喜欢数据
  _getRelatedProduct() async {
    String api = '${Config.domain}api/plist?is_hot=1';
    var response = await Dio().get(api);
    var relatedProductList = ProductModel.fromJson(response.data);
    setState(() {
      this._relatedProductDataList = relatedProductList.result;
    });
  }

  //!获取猜你喜欢数据
  _hotRelatedProduct() async {
    String api = '${Config.domain}api/plist?is_best=1';
    var response = await Dio().get(api);
    var hotProductList = ProductModel.fromJson(response.data);
    setState(() {
      this._hotProductDataList = hotProductList.result;
    });
  }

  //! 轮播图
  Widget _swiperWidget() {
    if (this._focusDataList.length > 0) {
      return Container(
        child: AspectRatio(
          aspectRatio: 2 / 1,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              FocusItemModel itemModel = this._focusDataList[index];
              return Image.network(
                '${Config.domain}${itemModel.pic.replaceAll('\\', '/')}',
                fit: BoxFit.cover,
              );
            },
            itemCount: this._focusDataList.length,
            pagination: new SwiperPagination(),
            autoplay: true,
          ),
        ),
      );
    } else {
      return Text('加载中....');
    }
  }

  //! 猜你喜欢
  Widget _relatedProductListWidget() {
    if (this._relatedProductDataList.length > 0) {
      return Container(
        height: ScreenAdapter.height(210),
        padding: EdgeInsets.all(ScreenAdapter.width(20)),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: this._relatedProductDataList.length,
          itemBuilder: (BuildContext context, int index) {
            ProductItemModel productItemModel =
                this._relatedProductDataList[index];
            return Column(
              children: <Widget>[
                Container(
                  width: ScreenAdapter.width(140),
                  height: ScreenAdapter.height(140),
                  margin: EdgeInsets.only(right: ScreenAdapter.width(20)),
                  child: Image.network(
                    '${Config.domain}${productItemModel.sPic.replaceAll('\\', '/')}',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: ScreenAdapter.height(10)),
                  height: ScreenAdapter.height(34),
                  child: Text(
                    '¥${productItemModel.price}',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    } else {
      return Text('加载中...');
    }
  }

  //! 热门推荐
  Widget _hotProductListWidget() {
    if (this._hotProductDataList.length > 0) {
      var itemWidth =
          (ScreenAdapter.getScreenWidth() - ScreenAdapter.width(50)) / 2.0;
      return Container(
        width: ScreenAdapter.getScreenWidth(),
        padding: EdgeInsets.all(ScreenAdapter.width(20)),
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          runSpacing: ScreenAdapter.width(10),
          spacing: ScreenAdapter.width(10),
          children: this._hotProductDataList.map((e) {
            ProductItemModel hotProductItemModel = e;
            return Container(
              padding: EdgeInsets.all(ScreenAdapter.width(15)),
              width: itemWidth,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromRGBO(233, 233, 233, 0.9),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Image.network(
                        '${Config.domain}${hotProductItemModel.sPic.replaceAll('\\', '/')}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    child: Text(
                      '${hotProductItemModel.title}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                    padding: EdgeInsets.only(top: ScreenAdapter.height(20)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenAdapter.width(10)),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '¥${hotProductItemModel.price}',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '¥${hotProductItemModel.oldPrice}',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    } else {
      return Text('加载中...');
    }
  }

  //! 红线+标题样式部件
  Widget _titleWidget(e) {
    return Container(
      height: ScreenAdapter.height(32),
      margin: EdgeInsets.only(left: ScreenAdapter.width(20)),
      padding: EdgeInsets.only(left: ScreenAdapter.width(20)),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Colors.red,
            width: ScreenAdapter.width(10),
          ),
        ),
      ),
      child: Text(
        e,
        style: TextStyle(
          color: Colors.black54,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return ListView(
      children: [
        _swiperWidget(),
        SizedBox(height: ScreenAdapter.height(10)),
        _titleWidget('猜你喜欢'),
        _relatedProductListWidget(),
        _titleWidget('热门商品'),
        _hotProductListWidget(),
      ],
    );
  }
}
