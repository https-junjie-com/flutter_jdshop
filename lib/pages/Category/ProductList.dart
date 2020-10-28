/*
 * @Author: your name
 * @Date: 2020-10-10 17:18:02
 * @LastEditTime: 2020-10-28 10:19:34
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter_jdshop/lib/pages/Category/ProductList.dart
 */
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../config/Config.dart';
import '../../model/ProductModel.dart';
import '../../services/ScreenAdapter.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class SortCondition {
  String name;
  bool isSelected;
  int index;
  SortCondition({this.name, this.isSelected, this.index});
}

// ignore: must_be_immutable
class ProductListPage extends StatefulWidget {
  Map arguments;
  ProductListPage({Key key, this.arguments}) : super(key: key);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  //!筛选
  List<String> _dropDownHeaderItemString = ['综合', '销量', '价格', '筛选'];
  List<SortCondition> _comprehensiveSortConditions = []; //!综合数据
  List<SortCondition> _salesSortConditions = []; //!销量数据
  List<SortCondition> _priceSortConditions = []; //!价格数据
  SortCondition _selectComprehensiveSortCondition; //!选中的综合
  SortCondition _selectSalesSortCondition; //!选中的销量
  SortCondition _selectpriceSortCondition; //!选中的价格
  GZXDropdownMenuController _dropdownMenuController =
      GZXDropdownMenuController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey _stackKey = GlobalKey();

  //!刷新
  var _controller = EasyRefreshController();
  var _scrollController = ScrollController();

  //!请求数据
  int _page = 1;
  String _sort = '';
  List _productDataList = [];
  bool _isMoreData = false;

  //!搜索数据
  var _keywords;
  var _cid;

  //! 上一页面搜索内容
  var _initKeyworldsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    this._cid = widget.arguments['cid'];
    this._keywords = widget.arguments['keywords'];
    //给文本框赋值
    this._initKeyworldsController.text = this._keywords;

    //!综合
    this
        ._comprehensiveSortConditions
        .add(SortCondition(name: '综合排序', isSelected: false));
    this._selectComprehensiveSortCondition =
        this._comprehensiveSortConditions[0];
    //!销量
    this
        ._salesSortConditions
        .add(SortCondition(name: '销量由高到低', isSelected: false));
    this
        ._salesSortConditions
        .add(SortCondition(name: '销量由低到高', isSelected: false));
    this._selectSalesSortCondition = _salesSortConditions[0];
    //!价格
    this
        ._priceSortConditions
        .add(SortCondition(name: '价格由高到低', isSelected: false));
    this
        ._priceSortConditions
        .add(SortCondition(name: '价格由低到高', isSelected: false));

    this._selectpriceSortCondition = this._priceSortConditions[0];

    //!刷新
    this._controller = EasyRefreshController();

    //! 获取商品列表
    this._getProductDataList();
  }

  //! 获取商品列表
  Future _getProductDataList() async {
    SVProgressHUD.show(' 加载中... ');
    SVProgressHUD.dismissWithDelay(10000);
    String api;

    if (this._keywords == null) {
      api =
          '${Config.domain}api/plist?cid=${this._cid}&sort=${this._sort}&page=${this._page}&pageSize=${Config.pageSize}';
    } else {
      api =
          '${Config.domain}api/plist?search=${this._keywords}&sort=${this._sort}&page=${this._page}&pageSize=${Config.pageSize}';
    }
    var response = await Dio().get(api);
    var productDataList = ProductModel.fromJson(response.data);
    setState(
      () {
        if (productDataList.result.length == 0 && this._page == 1) {
          SVProgressHUD.showError('未找到相关数据');
        } else {
          SVProgressHUD.dismiss();
        }
        this._isMoreData =
            productDataList.result.length < Config.pageSize ? false : true;
        this._controller.finishLoad(noMore: !this._isMoreData);
        this._productDataList.addAll(productDataList.result);
      },
    );
  }

  //!选择框配置
  Widget _selectMenuBarWidget() {
    return GZXDropDownHeader(
      controller: this._dropdownMenuController,
      stackKey: this._stackKey,
      items: [
        GZXDropDownHeaderItem(this._dropDownHeaderItemString[0]),
        GZXDropDownHeaderItem(this._dropDownHeaderItemString[1]),
        GZXDropDownHeaderItem(this._dropDownHeaderItemString[2]),
        GZXDropDownHeaderItem(this._dropDownHeaderItemString[3],
            iconData: Icons.search_rounded, iconSize: 18),
      ],
      onItemTap: (index) {
        if (index == 3) {
          this._dropdownMenuController.hide();
          this._scaffoldKey.currentState.openEndDrawer();
        }
      },
      // 头部的高度
      height: 44,
      // 头部背景颜色
      color: Colors.white,
      // 头部边框宽度
      borderWidth: 1,
      // 头部边框颜色
      borderColor: Colors.transparent,
      // 分割线高度
      dividerHeight: 20,
      // 分割线颜色
      dividerColor: Colors.transparent,
      // 文字样式
      style: TextStyle(color: Colors.black87, fontSize: 13),
      // 下拉时文字样式
      dropDownStyle: TextStyle(
        fontSize: 13,
        color: Colors.black87,
      ),
      // 图标大小
      iconSize: 20,
      // 图标颜色
      iconColor: Colors.black87,
      // 下拉时图标颜色
      iconDropDownColor: Colors.black87,
    );
  }

  //!下拉菜单
  Widget _dropDownMenuWidget() {
    return GZXDropDownMenu(
      controller: this._dropdownMenuController,
      animationMilliseconds: 300,
      menus: [
        GZXDropdownMenuBuilder(
          dropDownHeight: 40.0 * this._comprehensiveSortConditions.length,
          dropDownWidget: _buildSortConditionListWidget(
            this._comprehensiveSortConditions,
            (value) {
              this._selectComprehensiveSortCondition = value;
              this._dropDownHeaderItemString[0] =
                  this._selectComprehensiveSortCondition.name;
              this._dropDownHeaderItemString[1] = '销量';
              this._dropDownHeaderItemString[2] = '价格';
              this._dropdownMenuController.hide();
              setState(() {
                this._dropDownActionRequest(0, value.index);
              });
            },
          ),
        ),
        GZXDropdownMenuBuilder(
          dropDownHeight: 40.0 * this._salesSortConditions.length,
          dropDownWidget: _buildSortConditionListWidget(
            this._salesSortConditions,
            (value) {
              this._selectSalesSortCondition = value;
              this._dropDownHeaderItemString[0] = '综合';
              this._dropDownHeaderItemString[1] =
                  this._selectSalesSortCondition.name;
              this._dropDownHeaderItemString[2] = '价格';
              this._dropdownMenuController.hide();
              setState(() {
                this._dropDownActionRequest(1, value.index);
              });
            },
          ),
        ),
        GZXDropdownMenuBuilder(
          dropDownHeight: 40.0 * this._priceSortConditions.length,
          dropDownWidget: _buildSortConditionListWidget(
            this._priceSortConditions,
            (value) {
              this._selectpriceSortCondition = value;
              this._dropDownHeaderItemString[0] = '综合';
              this._dropDownHeaderItemString[1] = '销量';
              this._dropDownHeaderItemString[2] =
                  this._selectpriceSortCondition.name;
              this._dropdownMenuController.hide();
              setState(() {
                this._dropDownActionRequest(2, value.index);
              });
            },
          ),
        ),
      ],
    );
  }

  //!下拉菜单点击后,重新请求数据
  _dropDownActionRequest(int dropDownId, int dropDownSelect) {
    this._page = 1;
    this._productDataList.clear();
    if (dropDownId == 0) {
      //综合排序
      this._sort = '';
    }
    if (dropDownId == 1) {
      if (dropDownSelect == 0) {
        //销量由高到低
        this._sort = 'salecount_1';
      } else {
        //销量由低到高
        this._sort = 'salecount_1';
      }
    }
    if (dropDownId == 2) {
      if (dropDownSelect == 0) {
        //价格由高到低
        this._sort = 'price_-1';
      } else {
        //价格由低到高
        this._sort = 'price_1';
      }
    }
    this._getProductDataList();
  }

  //! 下拉菜单点击方法
  Widget _buildSortConditionListWidget(
      List<SortCondition> items, void itemOnTap(SortCondition sortCondition)) {
    return ListView.separated(
      controller: this._scrollController,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      separatorBuilder: (BuildContext context, int index) => Divider(height: 1),
      itemBuilder: (BuildContext context, int index) {
        SortCondition sortCondition = items[index];
        return GestureDetector(
          onTap: () {
            for (var value in items) {
              value.isSelected = false;
            }
            sortCondition.isSelected = true;
            sortCondition.index = index;
            //!一定要把点击的sortCondition返回回去
            itemOnTap(sortCondition);
            //!点击筛选按钮,列表返回顶部
            this._scrollController.animateTo(0,
                duration: Duration(microseconds: 500),
                curve: Curves.decelerate);
          },
          child: Container(
            height: 40,
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    sortCondition.name,
                    style: TextStyle(
                      color: sortCondition.isSelected
                          ? Colors.blueAccent
                          : Colors.black,
                    ),
                  ),
                ),
                sortCondition.isSelected
                    ? Container(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.check,
                          color: Colors.blueAccent,
                          size: 16,
                        ),
                      )
                    : SizedBox(
                        width: 10,
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  //! 商品列表
  Widget _prductListWidget() {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.all(ScreenAdapter.width(10)),
        child: EasyRefresh(
          enableControlFinishRefresh: true,
          enableControlFinishLoad: true,
          taskIndependence: true,
          controller: _controller,
          scrollController: _scrollController,
          topBouncing: true,
          bottomBouncing: true,
          header: ClassicalHeader(
            enableInfiniteRefresh: false,
            enableHapticFeedback: true,
            bgColor: null,
            infoColor: Colors.black87,
            float: false,
            refreshText: '下拉刷新',
            refreshReadyText: '释放刷新',
            refreshingText: '正在刷新',
            refreshedText: '刷新完成',
            refreshFailedText: '刷新失败',
            noMoreText: '没有更多数据...',
            infoText: '更新于 %T',
          ),
          footer: ClassicalFooter(
            enableInfiniteLoad: false,
            enableHapticFeedback: true,
            infoColor: Colors.black87,
            loadText: '上拉加载更多',
            loadReadyText: '释放加载',
            loadingText: '正在加载',
            loadedText: '加载完成',
            loadFailedText: '加载失败',
            noMoreText: '我是有底线的',
            infoText: '更新于 %T',
          ),
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 1), () {
              if (mounted) {
                setState(() {
                  this._page = 1;
                  this._getProductDataList();
                });
              }
              this._controller.resetLoadState();
              this._controller.finishRefresh();
            });
          },
          onLoad: () async {
            await Future.delayed(Duration(seconds: 1), () {
              if (mounted) {
                setState(
                  () {
                    if (this._isMoreData) {
                      this._page++;
                      this._getProductDataList();
                    }
                  },
                );
              }
            });
          },
          child: ListView.builder(
            controller: this._scrollController,
            itemCount: this._productDataList.length,
            itemBuilder: (BuildContext context, int index) {
              ProductItemModel productItemModel = this._productDataList[index];
              return Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: ScreenAdapter.width(180),
                          height: ScreenAdapter.width(180),
                          child: Image.network(
                            '${Config.domain}${productItemModel.pic.replaceAll('\\', '/')}',
                            fit: BoxFit.cover,
                            // color: Colors.white,
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Container(
                              height: ScreenAdapter.width(180),
                              margin: EdgeInsets.only(
                                  left: ScreenAdapter.width(15)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '${productItemModel.title}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Container(
                                    height: ScreenAdapter.height(30),
                                    margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.fromLTRB(
                                        ScreenAdapter.height(10),
                                        ScreenAdapter.height(4),
                                        ScreenAdapter.height(10),
                                        ScreenAdapter.height(4)),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(230, 230, 230, 0.9),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '标签',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '¥${productItemModel.price}',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  Divider(
                    height: ScreenAdapter.height(25),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: this._scaffoldKey,
      appBar: AppBar(
        title: Container(
          child: TextField(
            controller: this._initKeyworldsController,
            autofocus: false,
            decoration: InputDecoration(
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
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                      this._dropDownActionRequest(0, 0);
                    },
                  ),
                ),
              ],
            ),
          )
        ],
        elevation: 0,
      ),
      endDrawer: Container(
        height: ScreenAdapter.getScreenHeight(),
        margin:
            EdgeInsets.only(left: ScreenAdapter.getScreenWidth() / 4, top: 0),
        color: Colors.white,
        child: Container(
          child: Container(
            padding: EdgeInsets.all(ScreenAdapter.height(8)),
            color: Colors.white,
            child: TextField(),
          ),
        ),
      ),
      body: Stack(
        key: this._stackKey,
        children: [
          Column(
            children: <Widget>[
              this._selectMenuBarWidget(),
              this._prductListWidget(),
            ],
          ),
          this._dropDownMenuWidget(),
        ],
      ),
    );
  }
}
