import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:red_book/views/home/components/card_model.dart';
import 'package:red_book/views/home/components/card_widget.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with TickerProviderStateMixin {
  Widget _bgImage;
  // 默认选中的tab 0开始
  int _currentTab = 0;
  TabController _tabController; // 承载listView的滚动视图
  ScrollController _scrollController = ScrollController();

  // 多少个card
  int _itemCount = 10;
  // tabs item
  Widget buildAppBarTabsItem(String text, int index) {
    return AppBarTabsItem(
      text: text,
      active: this._currentTab == index,
      onTap: () {
        setState(() {
          this._currentTab = index;
        });
        _tabController.animateTo(index);
      },
    );
  }

  // tabs 容器
  Widget buildAppBarTabs(List<String> _tabs) {
    int index = 0;
    return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _tabs.map((String name) {
          Widget _w = buildAppBarTabsItem(name, index);
          index++;
          return _w;
        }).toList());
  }

  @override
  void initState() {
    super.initState();
    this._bgImage = Image.network(
      'https://picsum.photos/${360}/${720}?random=1',
      fit: BoxFit.cover,
      width: double.infinity,
    );
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      var index = _tabController.index;
      var previewIndex = _tabController.previousIndex;
      print('index:$index, preview:$previewIndex');
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _tabs = ['笔记', '收藏', '赞过'];
    Size size = MediaQuery.of(context).size;
    // 写在build内是为了求出SliverAppBar.toolbarHeight
    SliverAppBar _sliverAppBar = SliverAppBar(
      leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.share),
        )
      ],
      pinned: true,
      expandedHeight: size.height / 2.7,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            this._bgImage,
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ],
        ),
        title: Container(
          height: size.height / 2.7,
          width: double.infinity,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 头像
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  'assets/images/my_head.jpg',
                  width: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              // 昵称/小红书好/各种信息
              Expanded(
                  child: Column(
                children: [
                  Text('YEEVEN'),
                ],
              ))
            ],
          ),
        ),
      ),
    );
    return DefaultTabController(
      length: _tabs.length, // This is the number of tabs.
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          // These are the slivers that show up in the "outer" scroll view.
          return <Widget>[
            SliverOverlapAbsorber(
              // This widget takes the overlapping behavior of the SliverAppBar,
              // and redirects it to the SliverOverlapInjector below. If it is
              // missing, then it is possible for the nested "inner" scroll view
              // below to end up under the SliverAppBar even when the inner
              // scroll view thinks it has not been scrolled.
              // This is not necessary if the "headerSliverBuilder" only builds
              // widgets that do not overlap the next sliver.
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: _sliverAppBar,
            ),
          ];
        },
        body: Container(
          /// 这里要求出margin的高度
          /// 获取MediaQuery.of(context).padding.top)
          /// +
          /// 获取SliverAppBar.toolbarHeight
          margin: EdgeInsets.only(
              top: _sliverAppBar.toolbarHeight +
                  MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              /* TabBar(
                isScrollable: false,
                unselectedLabelColor: Theme.of(context).disabledColor,
                indicatorWeight: 5.0,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: EdgeInsets.all(0.0),
                indicator: BoxDecoration(
                  // borderRadius: BorderRadius.circular(50),
                  color: Theme.of(context).primaryColor,
                  border: Border(
                    bottom: BorderSide(
                      width: 2.0,
                      // 如果不用透明色，就会出现文字偏移现象
                      // 因为border没有的情况下容器里只有文字的元素，所以高度会比有border的元素少一点
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                // These are the widgets to put in each tab in the tab bar.
                tabs: _tabs
                    .map(
                      (String name) => Tab(
                        child: Container(
                          width: 200.0,
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(50),
                            border: Border(
                              bottom: BorderSide(
                                width: 2.0,
                                // 如果不用透明色，就会出现文字偏移现象
                                // 因为border没有的情况下容器里只有文字的元素，所以高度会比有border的元素少一点
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(name),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ), */
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 8.0, top: 5.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    buildAppBarTabs(_tabs),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  // These are the contents of the tab views, below the tabs.
                  children: _tabs.map((String name) {
                    return WaterfallFlow.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.only(
                          top: 5, left: 5, right: 5, bottom: 30),
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
                              placeholder:
                                  'assets/images/my_head.jpg' /* 占位图 */,
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
                    );
                    /* SafeArea(
                      top: false,
                      bottom: false,
                      child: Builder(
                        // This Builder is needed to provide a BuildContext that is
                        // "inside" the NestedScrollView, so that
                        // sliverOverlapAbsorberHandleFor() can find the
                        // NestedScrollView.
                        builder: (BuildContext context) {
                          return CustomScrollView(
                            // The "controller" and "primary" members should be left
                            // unset, so that the NestedScrollView can control this
                            // inner scroll view.
                            // If the "controller" property is set, then this scroll
                            // view will not be associated with the NestedScrollView.
                            // The PageStorageKey should be unique to this ScrollView;
                            // it allows the list to remember its scroll position when
                            // the tab view is not on the screen.
                            key: PageStorageKey<String>(name),
                            slivers: <Widget>[
                              SliverOverlapInjector(
                                // This is the flip side of the SliverOverlapAbsorber
                                // above.
                                handle: NestedScrollView
                                    .sliverOverlapAbsorberHandleFor(context),
                              ),
                              SliverPadding(
                                padding: const EdgeInsets.all(8.0),
                                // In this example, the inner scroll view has
                                // fixed-height list items, hence the use of
                                // SliverFixedExtentList. However, one could use any
                                // sliver widget here, e.g. SliverList or SliverGrid.
                                sliver: SliverFixedExtentList(
                                  // The items in this example are fixed to 48 pixels
                                  // high. This matches the Material Design spec for
                                  // ListTile widgets.
                                  itemExtent: 48.0,
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      // This builder is called for each child.
                                      // In this example, we just number each list item.
                                      return ListTile(
                                        title: Text('Item $index'),
                                      );
                                    },
                                    // The childCount of the SliverChildBuilderDelegate
                                    // specifies how many children this inner list
                                    // has. In this example, each tab has a list of
                                    // exactly 30 items, but this is arbitrary.
                                    childCount: 30,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ); */
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
