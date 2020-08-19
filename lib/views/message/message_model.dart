import 'dart:math';
import 'package:english_words/english_words.dart';

// 消息Message的数据数据模型
class MessageModel {
  // 用户头像
  String tileAvatar = 'https://picsum.photos/360/360?random=${randomNum(999)}';
  // 用户名
  String tileName = WordPair.random().toString();
  // 文本内容
  String tileContent = WordPair.random(maxSyllables: 10).toString();
  // 时间
  String tileTime = '08-19';
  // 是否有新消息
  bool tileNews = randomNum(1) > 0;
}

randomNum(number) {
  return Random().nextInt(number);
}
