import 'package:bagreportun/model/reading.dart';

class ReadingWithCount {
  final Reading reading;
  final int count;
  final String readingCountTimestamp;

  ReadingWithCount({
    required this.reading,
    required this.count,
    required this.readingCountTimestamp,
  });

  factory ReadingWithCount.fromMap(Map<String, dynamic> map) {
    return ReadingWithCount(
      reading: Reading.fromJson(map),
      count: map['count'] ?? 0,
      readingCountTimestamp: map['readingCountTimestamp'] ?? '',
    );
  }
}