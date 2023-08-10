class Payload {
  String name;
  String size;
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
}
