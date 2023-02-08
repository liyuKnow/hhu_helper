class UpdateLocation {
  final int? id;
  final String lat;
  final String long;
  final int? readingId;
  final String? updatedAt;

  const UpdateLocation({
    required this.lat,
    required this.long,
    this.readingId,
    this.updatedAt,
    this.id,
  });

  factory UpdateLocation.fromJson(Map<String, dynamic> json) => UpdateLocation(
        id: json['id'],
        lat: json['lat'],
        long: json['long'],
        readingId: json['readingId'],
        updatedAt: json['updatedAt'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'lat': lat,
        'long': long,
        'readingId': readingId,
        'updatedAt': updatedAt,
      };
}
