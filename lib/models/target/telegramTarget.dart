import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'package:terrarium_alerting/models/target.dart';

class TelegramTarget extends MessageTarget {
  String botToken;
  Iterable<String> chatIds;

  @override
  Future send(String message) async {
    final teledart = TeleDart(Telegram(botToken), Event());
    for (final id in chatIds) {
      await teledart.telegram.sendMessage(id, message);
    }
  }

  @override
  String get type => 'telegram';
}
