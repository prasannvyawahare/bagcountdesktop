class Reading {
  int? id;
  String timestamp;
  String value;

  Reading({
    this.id,
    required this.timestamp,
    required this.value
  });

  // Convert Reading to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp,
      'value': value
    };
  }

  // Convert Map to Reading
  factory Reading.fromMap(Map<String, dynamic> map) {
    return Reading(
      id: map['id'],
      timestamp: map['timestamp'],
      value: map['value']
    );
  }
}
