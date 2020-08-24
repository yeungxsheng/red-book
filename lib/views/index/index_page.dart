import 'package:flutter/material.dart';
import 'package:red_book/components/badge.dart';
import 'package:red_book/views/home/home_page.dart';
import 'package:red_book/views/message/message_page.dart';
import 'package:red_book/views/my/my_page.dart';
import 'package:red_book/views/store/store.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  var _current = 3;

  List<Widget> _list;
  @override
  void initState() {
    super.initState();
    this._list = [
      HomePage(),
      StorePage(),
      MessagePage(),
      MyPage(),
    ];
  }

  // 底部按钮构造widget
  Widget buildBottomAppBarButton(IconData icon, int index, {badge: false}) {
    Icon ico = Icon(
      icon,
      color: _current != index ? Theme.of(context).disabledColor : null,
    );
    return IconButton(
      icon: badge
          ? BadgeWidget(
              child: ico,
            )
          : ico,
      onPressed: () {
        setState(() {
          _current = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /**
       * 
       * IndexedStack继承自Stack，
       * 它的作用是显示第index个child，
       * 其它child在页面上是不可见的，但所有child的状态都被保持，所以这个Widget可以实现我们的需求，
       * 我们只需要将现在的body用IndexedStack包裹一层即可
       */
      body: IndexedStack(
        index: this._current,
        children: this._list,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(), //圆形缺口
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(child: buildBottomAppBarButton(Icons.home, 0)),
            Expanded(child: buildBottomAppBarButton(Icons.store, 1)),
            Expanded(child: SizedBox()),
            Expanded(
                child: buildBottomAppBarButton(Icons.message, 2, badge: true)),
            Expanded(child: buildBottomAppBarButton(Icons.person, 3)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
