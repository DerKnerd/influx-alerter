import 'package:logging/logging.dart';
import 'package:influx_alerter/models/alert.dart';
import 'package:influx_alerter/models/config.dart';
import 'package:influx_alerter/models/target.dart';
import 'package:influx_alerter/models/target/smtpTarget.dart';
import 'package:influx_alerter/models/target/telegramTarget.dart';

Future<Configuration> parseConfig(Map yaml) async {
  final logger = Logger('Config parser');
  final config = Configuration();
  final alerts = yaml['alerts'];
  final targets = yaml['targets'];

  final configAlerts = <Alert>[];
  final configTargets = <MessageTarget>[];
  logger.info('Parse alerts');
  for (final alert in alerts) {
    configAlerts.add(_parseAlert(alert));
  }

  logger.info('Parse targets');
  for (final target in targets) {
    configTargets.add(_parseTarget(target));
  }

  config.targets = configTargets;
  config.alerts = configAlerts;

  logger.info('Parse influx fields');
  config.org = yaml['org'].toString();
  config.token = yaml['token'].toString();
  config.server = yaml['server'].toString();

  return config;
}

MessageTarget _parseTarget(dynamic yaml) {
  final type = yaml['type'].toString();
  if (type == 'telegram') {
    final target = TelegramTarget();
    final chatIds = <String>[];
    target.botToken = yaml['botToken'].toString();

    for (final chatId in yaml['chatIds']) {
      chatIds.add(chatId.toString());
    }

    target.chatIds = chatIds;

    return target;
  } else if (type == 'smtp') {
    final target = SmtpTarget();
    target.from = yaml['from'].toString();
    target.password = yaml['password'].toString();
    target.to = yaml['to'].toString();
    target.username = yaml['username'].toString();
    target.host = yaml['host'].toString();
    target.port = int.tryParse(yaml['port'].toString());

    return target;
  }

  throw 'Invalid message target type $type';
}

Alert _parseAlert(dynamic yaml) {
  final type = yaml['type'].toString();
  if (type == 'hourRange') {
    final alert = HourRangeAlert();
    alert.afterHour = int.tryParse(yaml['afterHour'].toString());
    alert.beforeHour = int.tryParse(yaml['beforeHour'].toString());
    alert.flux = yaml['flux'].toString();
    alert.name = yaml['name'].toString();
    alert.message = yaml['message'].toString();
    alert.threshold = int.tryParse(yaml['threshold'].toString());
    if (yaml['thresholdType'].toString() == 'below') {
      alert.thresholdType = ThresholdType.below;
    } else {
      alert.thresholdType = ThresholdType.above;
    }

    return alert;
  } else if (type == 'deadman') {
    final alert = DeadManAlert();
    alert.message = yaml['message'].toString();
    alert.flux = yaml['flux'].toString();
    alert.name = yaml['name'].toString();

    return alert;
  } else if (type == 'value') {
    final alert = ValueAlert();
    alert.flux = yaml['flux'].toString();
    alert.name = yaml['name'].toString();
    alert.message = yaml['message'].toString();
    alert.threshold = int.tryParse(yaml['threshold'].toString());
    if (yaml['thresholdType'].toString() == 'below') {
      alert.thresholdType = ThresholdType.below;
    } else {
      alert.thresholdType = ThresholdType.above;
    }

    return alert;
  }

  throw 'Invalid alert type $type';
}
