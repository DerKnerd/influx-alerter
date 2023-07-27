import 'package:influx_alerter/models/alert.dart';
import 'package:influx_alerter/models/target.dart';

class Configuration {
  late String org;
  late String token;
  late String server;
  late Iterable<Alert> alerts;
  late Iterable<MessageTarget> targets;
}
