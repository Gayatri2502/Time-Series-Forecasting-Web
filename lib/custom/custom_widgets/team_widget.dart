import 'package:flutter/material.dart';

class TeamWidget extends StatefulWidget {
  final bool isDark;

  TeamWidget({this.isDark = false}) : super();

  @override
  State<TeamWidget> createState() => _TeamWidgetState();
}

class _TeamWidgetState extends State<TeamWidget> {
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = widget.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Team',
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Founded by a team of experienced marketers and AI experts, Alphacentauric aims to revolutionize the marketing industry by providing cutting-edge AI-based marketing strategy tools.',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            wordSpacing: 2,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'asset/5.jpg',
              scale: 10,
            ),
            const SizedBox(
              width: 30,
            ),
            SizedBox(
              height: 400,
              width: 250,
              child: Column(
                children: [
                  Text(
                    'GAYATRI SAMAL',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'With an exceptional understanding of artificial intelligence and machine learning, Annie’s expertise in developing advanced algorithms and data analytics empowers Alphacentauric to deliver accurate predictions and valuable insights to our customers.',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      wordSpacing: 2,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 150,
            ),
            Image.asset(
              'asset/6.jpg',
              scale: 10,
            ),
            const SizedBox(
              width: 30,
            ),
            SizedBox(
              height: 400,
              width: 250,
              child: Column(
                children: [
                  Text(
                    'GAYATRI SAMAL',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'With a wealth of knowledge in marketing strategy and a keen eye for market trends, Jamie skillfully leads Alphacentauric, ensuring our AI-based tools revolutionize the industry and drive success for our clients',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      wordSpacing: 2,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
