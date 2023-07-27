abstract class Alert {
  late String flux;
  late String message;
  late String name;
}

enum ThresholdType { above, below }

class HourRangeAlert extends Alert {
  int? beforeHour;
  int? afterHour;
  int? threshold;
  late ThresholdType thresholdType;
}

class DeadManAlert extends Alert {}

class ValueAlert extends Alert {
  int? threshold;
  late ThresholdType thresholdType;
}
