class Reading {
  int? id;                // Optional field for the ID
  String timestamp;       // Timestamp of the reading   // Unit of the reading (e.g., kilograms, liters)
  String bay;             // Bay where the reading was taken
  String truckNo;         // Truck number
  String brand;           // Brand associated with the reading
  double mrp;             // Maximum retail price
  double ton;
    int allottedBag;// Ton value associated with the reading


  // Constructor for initializing the Reading object
  Reading({
    this.id,
    required this.timestamp,
    required this.bay,
    required this.truckNo,
    required this.brand,
    required this.mrp,
    required this.ton,
   required this.allottedBag
  });

  // Factory method to create a Reading object from a JSON map
  factory Reading.fromJson(Map<String, dynamic> json) {
    return Reading(
      id: json['id'],                    // Parse the optional 'id'
      timestamp: json['timestamp'],       // Parse the 'timestamp
      bay: json['bay'],                   // Parse the 'bay'
      truckNo: json['truckNo'],           // Parse the 'truckNo'
      brand: json['brand'],               // Parse the 'brand'
      mrp: json['mrp'],                   // Parse the 'mrp'
      ton: json['ton'],
       allottedBag: json['allottedBag']
    );
  }

  // Method to convert the Reading object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,                           // Convert 'id' to JSON
      'timestamp': timestamp,             // Convert 'timestamp' to JSON// Convert 'unit' to JSON
      'bay': bay,                         // Convert 'bay' to JSON
      'truckNo': truckNo,                 // Convert 'truckNo' to JSON
      'brand': brand,                     // Convert 'brand' to JSON
      'mrp': mrp,                         // Convert 'mrp' to JSON
      'ton': ton,
    'allottedBag':allottedBag
    };
  }

  // Override toString method to provide a formatted string of the Reading object
  @override
  String toString() {
    return 'Reading(id: $id, timestamp: $timestamp, bay: $bay, truckNo: $truckNo, brand: $brand, mrp: $mrp, ton: $ton,'
       ' allottedBag:$allottedBag'
        ')';
  }
}
