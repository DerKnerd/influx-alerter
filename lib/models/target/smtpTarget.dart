import 'package:logging/logging.dart';
import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server.dart';
import 'package:influx_alerter/models/target.dart';

class SmtpTarget extends MessageTarget {
  String host;
  int port;
  String username;
  String password;
  String from;
  String to;
  SmtpServer _server;
  Logger logger = Logger('SmtpTarget');

  SmtpServer _getServer() {
    _server ??= SmtpServer(
      host,
      port: port ?? 25,
      username: username,
      password: password,
      allowInsecure: true,
    );

    return _server;
  }

  @override
  Future send(String message) async {
    final mailMessage = mailer.Message()
      ..from = from
      ..envelopeTos = [to]
      ..subject = 'Alert triggered'
      ..text = message;
    try {
      final sendReport = await mailer.send(mailMessage, _getServer());
      logger.info('Message sent: ' + sendReport.toString());
    } on mailer.MailerException catch (e) {
      logger.info('Message not sent.');
      for (var p in e.problems) {
        logger.info('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  @override
  String get type => 'smtp';
}
