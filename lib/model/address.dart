class Address {
  String? name;
  String? phoneNumber;
  String? province;
  String? city;
  String? subdistrict;
  String? postalCode;
  String? address;
  int? isMain;

  Address({
    this.name,
    this.phoneNumber,
    this.province,
    this.city,
    this.subdistrict,
    this.postalCode,
    this.address,
    this.isMain,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        name: json["name"],
        phoneNumber: json["no_hp"],
        province: json["province"],
        city: json["city"],
        subdistrict: json["subdistrict"],
        postalCode: json["postalCode"],
        address: json["address"],
        isMain: json["is_main"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "no_hp": phoneNumber,
        "province": province,
        "city": city,
        "subdistrict": subdistrict,
        "postalCode": postalCode,
        "address": address,
        "is_main": isMain,
      };
}
