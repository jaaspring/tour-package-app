import 'package:flutter/material.dart';

class BookingCard extends StatelessWidget {
  final String tourPackage;
  final String startDate;
  final String endDate;
  final int noPeople;
  final double price;
  final VoidCallback? onDelete;

  const BookingCard({
    Key? key,
    required this.tourPackage,
    required this.startDate,
    required this.endDate,
    required this.noPeople,
    required this.price,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey.shade200, // Placeholder background for image
              child: const Center(
                child: Icon(
                  Icons.image,
                  size: 60,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tourPackage,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start Date: $startDate',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                Text(
                  'End Date: $endDate',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                Text(
                  'People: $noPeople',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                Text(
                  'Price: MYR ${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          if (onDelete != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
