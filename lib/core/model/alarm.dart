import 'dart:ffi';

class Alarm {
  final int id;
  final DateTime alarmAt;
  final bool isActive;
  final bool isRepeat;
  DateTime? responseAt;
  Duration? responseTime;

  Alarm(this.id, this.alarmAt, this.isActive, this.isRepeat,
      {this.responseAt, this.responseTime});

  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
      json['id'],
      DateTime.fromMillisecondsSinceEpoch(json['alarm_at']),
      (json['is_active'] == null) ? false : json['is_active'],
      (json['is_repeat'] == null) ? false : json['is_repeat'],
      responseAt: json["response_at"] == null ? null : DateTime.fromMillisecondsSinceEpoch(json['response_at']),
      responseTime: json['response_time'] == null? Duration.zero : Duration(seconds: json['response_time']));

  @override
  String toString() => {
        "id": id.toUnsigned(32),
        "alarm_at": alarmAt.millisecondsSinceEpoch,
        "is_active": isActive,
        "is_repeat": isRepeat,
        "response_at":
            (responseAt == null) ? 0 : responseAt?.millisecondsSinceEpoch,
        "response_time":
            (responseTime == null) ? Duration.zero.inSeconds : responseTime?.inSeconds
      }.toString();

  Map<String, dynamic> toJson() => {
        "id": id.toUnsigned(32),
        "alarm_at": alarmAt.millisecondsSinceEpoch,
        "is_active": isActive,
        "is_repeat": isRepeat,
        "response_at":
            (responseAt == null) ? 0 : responseAt?.millisecondsSinceEpoch,
        "response_time":
            (responseTime == null) ? Duration.zero.inSeconds : responseTime?.inSeconds
      };
}
