import 'package:influxdb_client/api.dart';
import 'package:logging/logging.dart';
import 'package:terrarium_alerting/models/alert.dart';
import 'package:terrarium_alerting/models/config.dart';
import 'package:terrarium_alerting/models/target.dart';

Future checkAlerts(Configuration configuration) async {
  final logger = Logger('Checker');

  logger.info('Create influx client');
  final influx = InfluxDBClient(
    url: configuration.server,
    token: configuration.token,
    org: configuration.org,
  );

  final queryService = influx.getQueryService();

  logger.info('Iterate through alerts');
  for (final alert in configuration.alerts) {
    logger.info('Check alert ${alert.name}');
    await _checkAlert(alert, configuration.targets, queryService);
  }
}

Future _checkAlert(Alert alert, Iterable<MessageTarget> targets,
    QueryService queryService) async {
  final logger = Logger('Checker');

  logger.info('Query influx with configured flux query');
  if (alert is DeadManAlert) {
    final data = await queryService.query(alert.flux);
    final isEmpty = await data.isEmpty;
    if (isEmpty) {
      logger.info('Notify about dead man');
      await _notify(alert.message, targets);
    }
  } else if (alert is HourRangeAlert) {
    final data = await queryService.query(alert.flux);
    logger.info('Get utc time');
    final utcTime = DateTime.now().toUtc();
    if (utcTime.hour > alert.beforeHour && utcTime.hour < alert.afterHour) {
      logger.info('Alert is in time range');
      await data.forEach((entry) async {
        switch (alert.thresholdType) {
          case ThresholdType.above:
            if (entry['_value'] > alert.threshold) {
              logger.info('Notify about value above threshold');
              await _notify(alert.message, targets);
            }
            break;
          case ThresholdType.below:
            if (entry['_value'] < alert.threshold) {
              logger.info('Notify about value below threshold');
              await _notify(alert.message, targets);
            }
            break;
        }
      });
    }
  } else if (alert is ValueAlert) {
    final data = await queryService.query(alert.flux);
    await data.forEach((entry) async {
      switch (alert.thresholdType) {
        case ThresholdType.above:
          if (entry['_value'] > alert.threshold) {
            logger.info('Notify about value above threshold');
            await _notify(alert.message, targets);
          }
          break;
        case ThresholdType.below:
          if (entry['_value'] < alert.threshold) {
            logger.info('Notify about value below threshold');
            await _notify(alert.message, targets);
          }
          break;
      }
    });
  }
}

Future _notify(String message, Iterable<MessageTarget> targets) async {
  final logger = Logger('Checker');

  for (final target in targets) {
    logger.info('Notify ${target.type}');
    await target.send(message);
  }
}
