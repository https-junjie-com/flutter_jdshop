/*
 * @Author: your name
 * @Date: 2020-10-10 17:18:02
 * @LastEditTime: 2020-10-12 16:20:45
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter_jdshop/lib/pages/Category/ProductList.dart
 */
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../config/Config.dart';
import '../../services/ScreenAdapter.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';

class SortCondition {
  String name;
  bool isSelected;
  SortCondition({this.name, this.isSelected});
}

// ignore: must_be_immutable
class ProductListPage extends StatefulWidget {
  Map arguments;
  ProductListPage({Key key, this.arguments}) : super(key: key);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
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

  @override
  void initState() {
    super.initState();
    //!综合
    this
        ._comprehensiveSortConditions
        .add(SortCondition(name: '综合排序', isSelected: true));
    this
        ._comprehensiveSortConditions
        .add(SortCondition(name: '评分排序', isSelected: false));
    this._selectComprehensiveSortCondition =
        this._comprehensiveSortConditions[0];
    //!销量
    this
        ._salesSortConditions
        .add(SortCondition(name: '销量由高到低', isSelected: true));
    this
        ._salesSortConditions
        .add(SortCondition(name: '销量由低到高', isSelected: false));
    this._selectSalesSortCondition = _salesSortConditions[0];
    //!价格
    this
        ._priceSortConditions
        .add(SortCondition(name: '价格由高到低', isSelected: true));
    this
        ._priceSortConditions
        .add(SortCondition(name: '价格由低到高', isSelected: false));

    this._selectpriceSortCondition = this._priceSortConditions[0];
  }

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
      height: 44,
      borderWidth: 1,
      dividerHeight: 20,
      dividerColor: Colors.black12,
      style: TextStyle(color: Color(0xFF666666), fontSize: 14),
      dropDownStyle: TextStyle(
        fontSize: 14,
        color: Theme.of(context).primaryColor,
      ),
      iconSize: 20,
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
                this._comprehensiveSortConditions, (value) {
              this._selectComprehensiveSortCondition = value;
              this._dropDownHeaderItemString[0] =
                  this._selectComprehensiveSortCondition.name;
              this._dropdownMenuController.hide();
              setState(() {});
            })),
        GZXDropdownMenuBuilder(
            dropDownHeight: 40.0 * this._salesSortConditions.length,
            dropDownWidget: _buildSortConditionListWidget(
                this._salesSortConditions, (value) {
              this._selectSalesSortCondition = value;
              this._dropDownHeaderItemString[1] =
                  this._selectSalesSortCondition.name;
              this._dropdownMenuController.hide();
              setState(() {});
            })),
        GZXDropdownMenuBuilder(
            dropDownHeight: 40.0 * this._priceSortConditions.length,
            dropDownWidget: _buildSortConditionListWidget(
                this._priceSortConditions, (value) {
              this._selectpriceSortCondition = value;
              this._dropDownHeaderItemString[2] =
                  this._selectpriceSortCondition.name;
              this._dropdownMenuController.hide();
              setState(() {});
            })),
      ],
    );
  }

  //! 商品列表
  Widget _prductListWidget() {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.all(ScreenAdapter.width(10)),
        child: ListView.builder(
          itemCount: 20,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                Container(
                  child: Row(
                    children: [
                      Container(
                        width: ScreenAdapter.width(180),
                        height: ScreenAdapter.width(180),
                        child: Image.network(
                          'http://pic.netbian.com/uploads/allimg/200410/213246-1586525566e909.jpg',
                          fit: BoxFit.cover,
                          // color: Colors.white,
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Container(
                            height: ScreenAdapter.width(180),
                            margin:
                                EdgeInsets.only(left: ScreenAdapter.width(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'D.Va拥有一部强大的机甲，它具有两台全自动的近距离聚变机炮、可以使机甲飞跃敌人或障碍物的推进器、 还有可以抵御来自正面的远程攻击的防御矩阵。',
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
                                    '宅女',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Text(
                                  '¥998',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: this._scaffoldKey,
      appBar: AppBar(
        title: Text('商品列表'),
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

Widget _buildSortConditionListWidget(
    List<SortCondition> items, void itemOnTap(SortCondition sortCondition)) {
  return ListView.separated(
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
    itemCount: items.length,
    separatorBuilder: (BuildContext context, int index) => Divider(height: 1),
    itemBuilder: (BuildContext context, int index) {
      SortCondition sortCondition = items[index];
      return GestureDetector(
        onTap: () {
          print('更新选择的数据');
          for (var value in items) {
            value.isSelected = false;
          }
          sortCondition.isSelected = true;
          //!一定要把点击的sortCondition返回回去
          itemOnTap(sortCondition);
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
                        ? Theme.of(context).primaryColor
                        : Colors.black,
                  ),
                ),
              ),
              sortCondition.isSelected
                  ? Container(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.check,
                        color: Theme.of(context).primaryColor,
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
