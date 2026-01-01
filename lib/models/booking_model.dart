class Booking {
  final int? bookid;
  final int userid;
  final String bookdate;
  final String booktime;
  final String tourstartdate;
  final String tourenddate;
  final String tourpackage;
  final int nopeople;
  final double price;

  Booking({
    this.bookid,
    required this.userid,
    required this.bookdate,
    required this.booktime,
    required this.tourstartdate,
    required this.tourenddate,
    required this.tourpackage,
    required this.nopeople,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'bookid': bookid,
      'userid': userid,
      'bookdate': bookdate,
      'booktime': booktime,
      'tourstartdate': tourstartdate,
      'tourenddate': tourenddate,
      'tourpackage': tourpackage,
      'nopeople': nopeople,
      'price': price,
    };
  }
}
