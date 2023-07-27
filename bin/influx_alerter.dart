import 'dart:io';

import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:influx_alerter/alerts/checker.dart';
import 'package:influx_alerter/models/parser.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;

void main(List<String> arguments) async {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((event) {
    print(event);
  });

  final logger = Logger('App');

  final command = ArgParser();
  command.addOption(
    'config-file',
    abbr: 'c',
    defaultsTo:
        p.join(Directory.current.absolute.path, 'config', 'config.yaml'),
  );

  final result = command.parse(arguments);
  logger.info('Parse config');
  var config;

  final file = File(result['config-file']);
  final doc = loadYaml(await file.readAsString());

  try {
    config = await parseConfig(doc);
  } catch (e, s) {
    logger.severe(e, e, s);
    exit(1);
  }

  logger.info('Check alerts');
  await checkAlerts(config);
  exit(0);
}
