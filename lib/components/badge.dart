import 'package:flutter/material.dart';

// 消息小红点widget
class BadgeWidget extends StatelessWidget {
  final Widget child;

  const BadgeWidget({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        this.child,
        Positioned(
          right: 0.0,
          child: Container(
            width: 7.0,
            height: 7.0,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(7.0),
            ),
          ),
        ),
      ],
    );
  }
}
