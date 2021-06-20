import 'package:influx_alerter/models/alert.dart';
import 'package:influx_alerter/models/target.dart';

class Configuration {
  String org;
  String token;
  String server;
  Iterable<Alert> alerts;
  Iterable<MessageTarget> targets;
}
