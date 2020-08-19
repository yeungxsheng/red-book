import 'package:flutter/material.dart';
import 'package:red_book/components/badge.dart';
import 'package:red_book/views/message/message_model.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  // 承载listView的滚动视图
  ScrollController _scrollController = ScrollController();
  // tabs 容器
  Widget buildAppBarTabs() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AppBarTabsItem(
          icon: Icons.favorite,
          text: "赞和收藏",
          color: Theme.of(context).primaryColor.withOpacity(0.8),
        ),
        AppBarTabsItem(
          icon: Icons.person,
          text: "新增关注",
          color: Colors.blue.withOpacity(0.9),
        ),
        AppBarTabsItem(
          icon: Icons.face,
          text: "评论和@",
          color: Colors.green.withOpacity(0.7),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 阴影
        elevation: 1,
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
              Text(
                "消息",
                style: TextStyle(color: Colors.black),
              ),
              Positioned(
                right: 0,
                child: Icon(
                  Icons.translate,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 10.0),
              padding: EdgeInsets.symmetric(
                // 同appBar的titleSpacing一致
                horizontal: NavigationToolbar.kMiddleSpacing,
                vertical: 20.0,
              ),
              child: buildAppBarTabs(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                padding: EdgeInsets.symmetric(
                    // vertical: 5.0,
                    // horizontal: NavigationToolbar.kMiddleSpacing,
                    ),
                itemBuilder: (BuildContext listViewContext, int index) {
                  MessageModel mm = MessageModel();
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey[100]),
                      ),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.network(
                          mm.tileAvatar,
                          fit: BoxFit.cover,
                          width: 40.0,
                          height: 40.0,
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(mm.tileTime),
                          index % 2 == 0
                              ? BadgeWidget(
                                  child: Container(
                                    height: 7.0,
                                    width: 7.0,
                                  ),
                                )
                              : Container(
                                  height: 7.0,
                                  width: 7.0,
                                )
                        ],
                      ),
                      title: Text(mm.tileName),
                      subtitle: Text(mm.tileContent),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppBarTabsItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const AppBarTabsItem({Key key, this.icon, this.text, this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
              color: this.color, borderRadius: BorderRadius.circular(6.0)),
          child: Icon(
            this.icon,
            size: IconTheme.of(context).size - 6,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(this.text),
      ],
    );
  }
}
