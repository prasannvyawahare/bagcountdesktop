class Port {
  final String portName;
  final int baudRate;
  final int dataBits;
  final String parity;
  final int stopBits;
  final bool isConnect;

  Port({
    required this.portName,
    required this.baudRate,
    required this.dataBits,
    required this.parity,
    required this.stopBits,
    required this.isConnect,
  });

  // Factory constructor to create a Port object from a Map
  factory Port.fromMap(Map<String, dynamic> map) {
    return Port(
      portName: map['port_name'],
      baudRate: map['baud_rate'],
      dataBits: map['data_bits'],
      parity: map['parity'],
      stopBits: map['stop_bits'],
      isConnect: map['is_connect'],
    );
  }

  // Method to convert a Port object to a Map
  Map<String, dynamic> toMap() {
    return {
      'port_name': portName,
      'baud_rate': baudRate,
      'data_bits': dataBits,
      'parity': parity,
      'stop_bits': stopBits,
      'is_connect': isConnect,
    };
  }

  // Optional: Override toString for better debugging
  @override
  String toString() {
    return 'Port(portName: $portName, baudRate: $baudRate, dataBits: $dataBits, parity: $parity, stopBits: $stopBits, isConnect: $isConnect)';
  }
}
