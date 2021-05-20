import 'package:terrarium_alerting/models/alert.dart';
import 'package:terrarium_alerting/models/target.dart';

class Configuration {
  String org;
  String token;
  String server;
  Iterable<Alert> alerts;
  Iterable<MessageTarget> targets;
}
