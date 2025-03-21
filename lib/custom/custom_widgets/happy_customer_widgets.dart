import 'package:flutter/material.dart';

import 'designer_container_widget.dart';

class HappyCustomerWidget extends StatefulWidget {
  const HappyCustomerWidget({super.key});

  @override
  State<HappyCustomerWidget> createState() => _HappyCustomerWidgetState();
}

class _HappyCustomerWidgetState extends State<HappyCustomerWidget> {
  @override
  Widget build(BuildContext context) {
    return BeautifiedContainer(
      height: 500,
      width: 1,
      color: Colors.indigo.shade50,
      child: Stack(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 500,
            width: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Happy Customers',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 45,
                      wordSpacing: 5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Our AI-based marketing strategy tools guarantee minimum performance and provide reliable data, giving our customers a significant competitive advantage in the industry.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to sales data conversion page
                  },
                  child: const Text('View All Testimonials'),
                ),
              ],
            ),
          ),
          Positioned(
            right: 120,
            top: 10,
            child: Image.asset(
              'asset/8.jpg',
              scale: 2.5,
              //height: 200,
            ),
          ),
        ],
      ),
    );
  }
}
