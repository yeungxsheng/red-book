import 'dart:math';

import 'package:flutter/material.dart';

class CardWidget extends StatefulWidget {
  final Widget image;
  final Widget avatar;
  final Widget desc;
  final String name;
  const CardWidget({
    Key key,
    this.image,
    this.avatar,
    this.desc,
    this.name,
  }) : super(key: key);
  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  // var lastTapDown = 0;
  // @override
  // void initState() {
  //   // 滚动出视野组件被销毁了
  //   print("card 加载");
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    Color _disabledColor = _theme.disabledColor;
    TextStyle textStyle = TextStyle(
      color: _disabledColor,
      fontSize: _theme.textTheme.bodyText1.fontSize - 2,
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
      ),
      child: GestureDetector(
        onTap: () {
          print("点击进去");
        },
        /* onTapUp: (details) {
          print('Tap!');
        },
        // 模拟双击效果 
        onTapDown: (details) {
          var now = DateTime.now().millisecondsSinceEpoch;
          if (now - lastTapDown < 200) {
            print("Double Tap!");
          }
          lastTapDown = now;
        }, */
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.0),
                  topRight: Radius.circular(5.0)),
              // 在线获取图片
              child: widget
                  .image, /*  FadeInImage.assetNetwork(
                image:
                    "https://picsum.photos/360/${randomHeight(minUnit: 3, maxUnit: 4)}?random=${widget.key}",
                fit: BoxFit.cover,
                placeholder: 'assets/images/my_head.jpg' /* 占位图 */,
              ), */
              // 测试容器用的widget
              /* child: Container(
                width: 360.0,
                height: randomHeight(minUnit: 3, maxUnit: 6) * .5,
                color: Colors.green,
                child: Center(
                  child: Text(
                    '${widget.key}',
                    style: TextStyle(
                      fontSize: 50.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ), */
            ),
            // 描述文字
            widget.desc,
            Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      // color: Colors.pink,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 用户头像
                          widget.avatar,
                          SizedBox(
                            width: 5,
                          ),
                          // 用户名
                          Expanded(
                            child: Text(
                              widget.name,
                              style: textStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 收藏按钮
                  FavoriteBtn(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 把按钮组件拿出来,不然每次点击收藏更新widget的时候会把card widget也一起刷新了
// 这样会造成不必要的多次渲染和请求
// 只需要重新渲染当前的按钮widget就够了
class FavoriteBtn extends StatefulWidget {
  @override
  _FavoriteBtnState createState() => _FavoriteBtnState();
}

class _FavoriteBtnState extends State<FavoriteBtn>
    with AutomaticKeepAliveClientMixin {
  //不会被销毁,占内存中
  bool get wantKeepAlive => true;
  bool liked = false;
  int howLiked = Random().nextInt(5000);
  @override
  Widget build(BuildContext context) {
    super.build(context);
    ThemeData _theme = Theme.of(context);
    Color _disabledColor = _theme.disabledColor;
    TextStyle textStyle = TextStyle(
      color: _disabledColor,
      fontSize: _theme.textTheme.bodyText1.fontSize - 2,
    );
    return GestureDetector(
      onTap: () {
        setState(() {
          this.liked = !this.liked;
          if (this.liked)
            this.howLiked++;
          else
            --this.howLiked;
        });
      },
      child: Container(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              this.liked ? Icons.favorite : Icons.favorite_border,
              color: this.liked ? _theme.primaryColor : _disabledColor,
              size: IconTheme.of(context).size - 6,
            ),
            SizedBox(
              width: 3,
            ),
            Text("${this.howLiked}", style: textStyle)
          ],
        ),
      ),
    );
  }
}
