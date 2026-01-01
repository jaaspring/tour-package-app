import 'package:flutter/material.dart';
import 'tour_package_detail_page.dart';

class TourPackagePage extends StatelessWidget {
  final List<Map<String, String>> tourPackages = [
    {
      'code': 'Tour A',
      'title': 'Phi Phi Island Paradise',
      'image': 'assets/A1.jpg',
      'price': '299.99',
    },
    {
      'code': 'Tour B',
      'title': 'Krabi Island Hopping Adventure',
      'image': 'assets/B1.jpg',
      'price': '249.99',
    },
    {
      'code': 'Tour C',
      'title': 'Hong Island 7-Island Adventure',
      'image': 'assets/C1.jpg',
      'price': '399.99',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tour Packages')),
      body: ListView.builder(
        itemCount: tourPackages.length,
        itemBuilder: (context, index) {
          final tour = tourPackages[index];
          return Card(
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Image.asset(
                    tour['image']!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text(
                      tour['title']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${tour['code']} - MYR ${tour['price']}",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TourPackageDetailPage(tourCode: tour['code']!),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
