import 'package:influx_alerter/models/target.dart';
import 'package:teledart/teledart.dart';

class TelegramTarget extends MessageTarget {
  late String botToken;
  late Iterable<String> chatIds;

  @override
  Future send(String message) async {
    final teledart = TeleDart(botToken, Event(''));
    for (final id in chatIds) {
      await teledart.sendMessage(id, message);
    }
  }

  @override
  String get type => 'telegram';
}
