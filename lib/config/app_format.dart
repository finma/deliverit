import 'package:intl/intl.dart';

import '/model/address.dart';

class AppFormat {
  static String date(String stringDate) {
    // 2023-12-31
    DateTime date = DateTime.parse(stringDate);
    return DateFormat('dd MMMM yyyy').format(date); // 31 Desember 2023
  }

  static String dateMonth(String stringDate) {
    // 2023-12-31
    DateTime date = DateTime.parse(stringDate);
    return DateFormat('dd MMMM').format(date); // 31 Desember
  }

  static String currency(double number) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(number);
  }

  static String address(Address address) {
    return '${address.address}, ${address.subdistrict}, ${address.city}, ${address.province}, ${address.postalCode}';
  }
}
