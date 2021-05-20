abstract class Alert {
  String flux;
  String message;
  String name;
}

enum ThresholdType { above, below }

class HourRangeAlert extends Alert {
  int beforeHour;
  int afterHour;
  int threshold;
  ThresholdType thresholdType;
}

class DeadManAlert extends Alert {}

class ValueAlert extends Alert {
  int threshold;
  ThresholdType thresholdType;
}
