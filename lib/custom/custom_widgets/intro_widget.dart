import 'package:flutter/material.dart';

import '../../screens/service screen/service_screen.dart';

class IntroWidget extends StatelessWidget {
  const IntroWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context); // Access the current theme

    return Container(
      padding: const EdgeInsets.all(16),
      height: 700,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 900,
                child: Text(
                  '''AI-powered Marketing & Management Strategy Tools for Industry''',
                  style: theme.textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 106.0),
              Text(
                'Dominate the marketing sector with Alphacentauric’s AI-powered tools that \nguarantee minimum performance and provide reliable data \nfor strategic decision-making.',
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontSize: 18.50,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 25.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.indigo.shade300),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ServiceScreen();
                  }));
                },
                child: const Text(
                  'View All Services',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          // Positioned(
          //   right: 550,
          //   top: 300,
          //   child: Image.asset(
          //     'asset/ff (2).jpg',
          //     scale: 2,
          //   ),
          // ),
          Positioned(
            right: 1,
            top: 50,
            child: Image.asset(
              'asset/ff (2).jpg',
              scale: 2,
              height: 550,
            ),
          )
        ],
      ),
    );
  }
}
