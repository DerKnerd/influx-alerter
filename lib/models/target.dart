abstract class MessageTarget {
  Future send(String message);
  String get type;
}
