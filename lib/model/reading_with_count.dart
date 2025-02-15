class ReadingWithCount {
  final int id;
  final String timestamp;
  final String bay;
  final String truckNo;
  final String brand;
  final String mrp;
  final String ton;
  final String allottedBag;
  final String count;
  final String readingCountTimestamp;

  ReadingWithCount({
    required this.id,
    required this.timestamp,
    required this.bay,
    required this.truckNo,
    required this.brand,
    required this.mrp,
    required this.ton,
    required this.allottedBag,
    required this.count,
    required this.readingCountTimestamp,
  });

  factory ReadingWithCount.fromJson(Map<String, dynamic> json) {
    return ReadingWithCount(
      id: json['id'],
      timestamp: json['timestamp'].toString(),
      bay: json['bay'].toString(),
      truckNo: json['truckNo'].toString(),
      brand: json['brand'].toString(),
      mrp: json['mrp'].toString(),
      ton: json['ton'].toString(),
      allottedBag: json['allottedBag'].toString(),
      count: json['count'].toString(),
      readingCountTimestamp: json['readingCountTimestamp'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "timestamp": timestamp,
      "bay": bay,
      "truckNo": truckNo,
      "brand": brand,
      "mrp": mrp,
      "ton": ton,
      "allottedBag": allottedBag,
      "count": count,
      "readingCountTimestamp": readingCountTimestamp,
    };
  }
}
