import 'dart:math';

import 'package:flutter/material.dart';

// 首页card的数据数据模型
class CardModel {
  // 卡片展示图
  String cardImg =
      'https://picsum.photos/360/${randomHeight(minUnit: 3, maxUnit: 4)}?random=${randomNum(999)}';
  // 卡片描述文字
  String cardDesc = randomChinese(minLength: 3, maxLength: 20);
  // 用户头像
  String cardAvatar = 'https://picsum.photos/360/360?random=${randomNum(999)}';

  // 用户名称
  String cardName = '十一先生';
  // 是否收藏
  bool liked = false;
  // 收藏总数
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

// 随机生成基本汉字 库量20902字
// 编码库范围 4E00-9FA5
String randomChinese({minLength: 1, maxLength: 1}) {
  String str = '';
  // 19968
  final int _min = int.parse('0x4E00');
  // 40869
  final int _max = int.parse('0x9FA5');
  _r(max) {
    return Random().nextInt(max);
  }

  var ma = _r(maxLength);
  // 最少要多少长度
  ma = ma > minLength ? ma : minLength;
  for (var i = 0; i < ma; i++) {
    var r = Random().nextInt(_max);
    // 如果大于第一个汉字编码
    if (r > _min) {
      str = str + String.fromCharCode(r);
    } else {
      var a = _r(4), b = _r(9), c = _r(9), d = _r(9), e = _r(9);
      // 范围一定在1-4
      a = a >= 1 && a <= 4 ? a : 1;
      // 第一位达到最大的情况下,b不能超过0
      b = a == 1 ? 9 : a >= 4 ? 0 : b;
      c = a == 1 ? 9 : a >= 4 ? c <= 8 ? c : 8 : c;
      d = a == 1 ? d >= 6 ? d : 6 : a >= 4 ? d <= 6 ? d : 6 : d;
      e = a == 1 ? e >= 8 ? e : 8 : a >= 4 ? e <= 9 ? e : 9 : e;
      str = str + String.fromCharCode(int.parse('$a$b$c$d$e'));
    }
  }
  return str;
}
