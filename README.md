# Influx alerter

The influx alerter is a small utility created by Imanuel Ulbricht. The purpose of this tool is to allow influxdb 2.0
instances to send alert messages via smtp and telegram.

## Installation

Currently the influx alerter is available as docker image, you can find it
here: https://hub.docker.com/repository/docker/iulbricht/influx-alerter. The version is increased every time a new build
is triggered.

It is planned to provide a linux binary. You can of course get the code and run it using dart directly.

## Configuration

```yaml
org: The organization of your influx instance
token: The access token for your influx instance
server: The server of your influx instance
logLevel: The loglevel can
targets:
  - type: telegram
    botToken: The token of your telegram bot, use @Botfather to get it
    chatIds:
      - A list of chat ids used by telegram
  - type: smtp
    from: The from email address
    host: The host of your mail server
    port: The port of your mail server
    username: The username of your mail server
    password: The password of your mail server
    to: The address the alerter should send messages to
alerts:
  - type: hourRange
    flux: A flux query that gets the threshold value for the given range
    threshold: The threshold the flux query result should be checked against
    thresholdType: The threshold type, can be either above or below
    message: The message to send via smtp or telegram
    name: The name of the check
    afterHour: The hour after which this check should run
    beforeHour: The hour before which this check should run
  - type: value
    flux: A flux query that gets the threshold value for the given range
    threshold: The threshold the flux query result should be checked against
    thresholdType: The threshold type, can be either above or below
    message: The message to send via smtp or telegram
    name: The name of the check
  - type: deadman
    flux: A flux query that gets the threshold value for the given range
    message: The message to send via smtp or telegram
    name: The name of the check
```

## Found a bug?

If you found a bug feel free to create an issue on Github or on my personal Taiga
instance: https://taiga.imanuel.dev/project/influx-alerter/

## License

Like all other projects I create, the k8s IVC is distributed under the MIT License.
