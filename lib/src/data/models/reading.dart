class Reading {
  int? id;
  String customerName;
  String customerId;
  String deviceId;
  String meterReading;
  int? status;
  String? readingDate;

  Reading({
    required this.customerName,
    required this.customerId,
    required this.deviceId,
    required this.meterReading,
    this.status,
    this.readingDate,
    this.id,
  });

  factory Reading.fromJson(Map<String, dynamic> json) => Reading(
        id: json['id'],
        customerName: json['customer_name'],
        customerId: json['customer_id'],
        deviceId: json['device_id'],
        meterReading: json['meter_reading'],
        status: json['status'],
        readingDate: json['reading_date'],
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'customerName': customerName,
        'customerId': customerId,
        'deviceId': deviceId,
        'meterReading': meterReading,
        'status': status,
        'readingDate': readingDate,
      };
}
