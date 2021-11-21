class Alarm {
  final int id;
  final DateTime alarmAt;
  final bool isActive;
  final bool isRepeat;

  Alarm(this.id, this.alarmAt, this.isActive, this.isRepeat);

  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
      json['id'].toInt(),
      DateTime.fromMillisecondsSinceEpoch(json['alarm_at']),
      json['is_active'],
      json['is_repeat']);

  @override
  String toString() => {
        "id": id.toString(),
        "alarm_at": alarmAt.millisecondsSinceEpoch,
        "is_active": isActive,
        "is_repeate": isRepeat
      }.toString();
}
