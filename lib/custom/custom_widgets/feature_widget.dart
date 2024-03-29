import 'package:flutter/material.dart';

class FeatureWidget extends StatefulWidget {
  const FeatureWidget({Key? key}) : super(key: key);

  @override
  State<FeatureWidget> createState() => _FeatureWidgetState();
}

class _FeatureWidgetState extends State<FeatureWidget> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          //height: 2,
          thickness: 0.2,
          color: Colors.black,
        ),
        const SizedBox(
          height: 100,
        ),
        Text(
          'Features',
          style: theme.textTheme.headline1!.copyWith(
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        SizedBox(
          height: 350,
          width: MediaQuery.of(context).size.width,
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   boxShadow: [
          //     BoxShadow(
          //       color: Colors.grey.withOpacity(0.5),
          //       spreadRadius: 5,
          //       blurRadius: 10,
          //       offset: Offset(0, 3), // changes the shadow position
          //     ),
          //   ],
          // ),
          child: Stack(
            children: [
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      softWrap: true,
                      text: TextSpan(children: [
                        _buildBulletPoint(
                          'Accurate assessment of marketing performance',
                          theme.textTheme.bodyText1!,
                        ),
                        _buildBulletPoint(
                          'Guarantee of minimum performance for potential customers',
                          theme.textTheme.bodyText1!,
                        ),
                        _buildBulletPoint(
                          'Prediction of future market states using AI and ML',
                          theme.textTheme.bodyText1!,
                        ),
                        _buildBulletPoint(
                          'Comprehensive workflow automation and analytics',
                          theme.textTheme.bodyText1!,
                        ),
                        _buildBulletPoint(
                          'Dominance in the marketing sector with an AI-powered marketing tool',
                          theme.textTheme.bodyText1!,
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 35,
                top: 5,
                child: Image.asset(
                  'asset/7.jpg',
                  scale: 2,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  WidgetSpan _buildBulletPoint(String text, TextStyle textStyle) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.add_box,
                  size: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  text,
                  style: textStyle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 25,
            )
          ],
        ),
      ),
    );
  }
}
