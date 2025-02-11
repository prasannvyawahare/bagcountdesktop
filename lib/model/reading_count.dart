class ReadingCount {
  int? id;
  String count;
  int readingId;
  String timestamp;

  ReadingCount({
    this.id,
    required this.count,
    required this.readingId,
    required this.timestamp,
  });

  // Convert a ReadingCount object into a Map (JSON format)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'count': count,
      'readingId': readingId,
      'timestamp': timestamp,
    };
  }

  // Create a ReadingCount object from a Map (JSON format)
  factory ReadingCount.fromJson(Map<String, dynamic> json) {
    return ReadingCount(
      id: json['id'],
      count: json['count'],
      readingId: json['readingId'],
      timestamp: json['timestamp'],
    );
  }
}
