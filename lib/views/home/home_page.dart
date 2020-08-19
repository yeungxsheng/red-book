import 'dart:math';

import 'package:flutter/material.dart';
import 'package:red_book/views/home/components/card_model.dart';
import 'package:red_book/views/home/components/card_widget.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 默认选中的tab 0开始
  int _currentTab = 1;

  // 多少个card
  int _itemCount = 10;

  // 用一个key来保存下拉刷新控件RefreshIndicator
  GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  // 承载listView的滚动视图
  ScrollController _scrollController = ScrollController();
  // 数据源
  List<String> _dataSource = List<String>();
  // 当前加载的页数
  int _pageSize = 0;

  // 加载数据
  void _loadData(int index) {
    for (int i = 0; i < 15; i++) {
      _dataSource.add((i + 15 * index).toString());
    }
  }

  // 下拉刷新
  Future<Null> _onRefresh() {
    return Future.delayed(Duration(seconds: 2), () {
      print("正在刷新...");
      _pageSize = 0;
      _dataSource.clear();
      setState(() {
        _loadData(_pageSize);
      });
    });
  }

  // 加载更多
  Future<Null> _loadMoreData() {
    return Future.delayed(Duration(seconds: 1), () {
      print("正在加载更多...");

      setState(() {
        _pageSize++;
        _loadData(_pageSize);
      });
    });
  }

  // 刷新
  showRefreshLoading() {
    new Future.delayed(const Duration(seconds: 0), () {
      _refreshKey.currentState.show().then((e) {});
      return true;
    });
  }

  @override
  void initState() {
    print('home加载');
    /*  showRefreshLoading();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreData();
      }
    }); */
    super.initState();
  }

  // tabs item
  Widget buildAppBarTabsItem(String text, int index) {
    return AppBarTabsItem(
      text: text,
      active: this._currentTab == index,
      onTap: () {
        setState(() {
          this._currentTab = index;
        });
      },
    );
  }

  // tabs 容器
  Widget buildAppBarTabs() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildAppBarTabsItem('关注', 0),
        buildAppBarTabsItem('发现', 1),
        buildAppBarTabsItem('定位', 2),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (TapDownDetails details) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          // 阴影
          elevation: 0,
          //backgroundColor: Colors.white,
          backgroundColor: Colors.white,
          centerTitle: true,
          // title widget两边不留间隙
          // Defaults to [NavigationToolbar.kMiddleSpacing].
          // titleSpacing: 0.0,
          title: Container(
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 0,
                  child: Icon(
                    Icons.alternate_email,
                    color: Colors.black,
                  ),
                ),
                buildAppBarTabs(),
              ],
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          // padding: EdgeInsets.symmetric(
          //   // 同appBar的titleSpacing一致
          //   horizontal: NavigationToolbar.kMiddleSpacing,
          // ),
          decoration: BoxDecoration(
              // scolor: Colors.pink,
              ),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                  // 同appBar的titleSpacing一致
                  horizontal: NavigationToolbar.kMiddleSpacing,
                  vertical: 5.0,
                ),
                child: Stack(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 35,
                      ),
                      child: TextField(
                        /// 设置字体
                        style: TextStyle(),

                        /// 设置输入框样式
                        decoration: InputDecoration(
                          hintText: 'GTR',

                          /// 边框
                          // border: OutlineInputBorder(
                          //   borderSide: BorderSide(width: 10, color: Colors.red),
                          //   borderRadius: BorderRadius.all(
                          //     /// 里面的数值尽可能大才是左右半圆形，否则就是普通的圆角形
                          //     Radius.circular(50),
                          //   ),
                          // ),

                          // border: InputBorder.none, //去掉输入框的边框,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                            borderSide: BorderSide.none,
                          ),
                          // fillColor: Theme.of(context).disabledColor,
                          // fillColor: Colors.grey[200],

                          // 是否使用填充色
                          filled: true,

                          ///设置内容内边距
                          // contentPadding: EdgeInsets.only(
                          //   top: 0,
                          //   bottom: 0,
                          // ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 4.0),

                          /// 前缀图标
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  key: _refreshKey,
                  onRefresh: _onRefresh,
                  child: WaterfallFlow.builder(
                    controller: _scrollController,
                    padding:
                        EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 30),
                    itemCount: this._itemCount,
                    gridDelegate:
                        SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                      // 主轴个数
                      crossAxisCount: 2,

                      /// 主轴间距
                      mainAxisSpacing: 5.0,

                      /// 纵轴间距
                      crossAxisSpacing: 5.0,
                      // 元素回收时候的回调
                      collectGarbage: (List<int> garbages) {},
                    ),
                    itemBuilder: (BuildContext bcontext, int index) {
                      CardModel cm = CardModel();
                      return CardWidget(
                        image: FadeInImage.assetNetwork(
                          image: cm.cardImg,
                          fit: BoxFit.cover,
                          placeholder: 'assets/images/my_head.jpg' /* 占位图 */,
                        ),
                        avatar: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FadeInImage.assetNetwork(
                            image: cm.cardAvatar,
                            width: 20,
                            fit: BoxFit.cover,
                            placeholder: 'assets/images/my_head.jpg' /* 占位图 */,
                          ),
                        ),
                        desc: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(10.0),
                          child: Text(cm.cardDesc),
                        ),
                        name: cm.cardName,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

randomNum(number) {
  return Random().nextInt(number);
}

// 随机生成 $min00 - $max99 的数字
// minUnit最小个位数  maxUnit最大个位数
randomHeight({minUnit: 1, maxUnit: 9}) {
  var f = Random().nextInt(9);
  var m = Random().nextInt(99);
  return int.parse(
      '${f > minUnit ? f < maxUnit ? f : maxUnit : minUnit}${m < 10 ? '00' : m}');
}

class AppBarTabsItem extends StatelessWidget {
  const AppBarTabsItem({Key key, this.text, this.onTap, this.active})
      : super(key: key);

  final String text;
  final GestureTapCallback onTap;
  final bool active;
  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    return GestureDetector(
      onTap: this.onTap,
      child: Column(
        children: [
          Container(
            // color: Colors.pink,
            padding: EdgeInsets.only(top: 5, bottom: 5),
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 2.0,
                  // 如果不用透明色，就会出现文字偏移现象
                  // 因为border没有的情况下容器里只有文字的元素，所以高度会比有border的元素少一点
                  color: this.active ? _theme.primaryColor : Colors.transparent,
                ),
              ),
            ),
            child: Text(
              this.text,
              style: TextStyle(
                color: this.active ? Colors.black : _theme.disabledColor,
                fontSize: _theme.textTheme.bodyText1.fontSize + 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
