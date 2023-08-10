enum PayloadSize { small, medium, large }

class Payload {
  String name;
  PayloadSize size;
  int qty;

  Payload({
    required this.name,
    required this.size,
    this.qty = 0,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        name: json["name"],
        size: json["size"],
        qty: json["qty"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "size": size,
        "qty": qty,
      };

  static String sizeToString(PayloadSize size) {
    switch (size) {
      case PayloadSize.small:
        return 'kecil';
      case PayloadSize.medium:
        return 'sedang';
      case PayloadSize.large:
        return 'besar';
      default:
        throw Exception('Invalid payload size: $size');
    }
  }

  static PayloadSize stringToSize(String size) {
    switch (size) {
      case 'kecil':
        return PayloadSize.small;
      case 'sedang':
        return PayloadSize.medium;
      case 'besar':
        return PayloadSize.large;
      default:
        throw Exception('Invalid payload size: $size');
    }
  }
}
