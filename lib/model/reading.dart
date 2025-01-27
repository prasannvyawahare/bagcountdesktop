class Reading {
  int? id;
  String timestamp;
  double value;
  String unit;

  Reading({
    this.id,
    required this.timestamp,
    required this.value,
    required this.unit,
  });

  // Convert Reading to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp,
      'value': value,
      'unit': unit,
    };
  }

  // Convert Map to Reading
  factory Reading.fromMap(Map<String, dynamic> map) {
    return Reading(
      id: map['id'],
      timestamp: map['timestamp'],
      value: map['value'],
      unit: map['unit'],
    );
  }
}
