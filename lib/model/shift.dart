class Shift {
  int? id;
  String shiftName;
  String startTime;
  String endTime;

  Shift({this.id, required this.shiftName, required this.startTime, required this.endTime});

  // Convert Shift to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shift_name': shiftName,
      'start_time': startTime,
      'end_time': endTime,
    };
  }

  // Convert Map to Shift
  factory Shift.fromMap(Map<String, dynamic> map) {
    return Shift(
      id: map['id'],
      shiftName: map['shift_name'],
      startTime: map['start_time'],
      endTime: map['end_time'],
    );
  }
}
