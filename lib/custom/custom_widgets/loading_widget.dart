import 'package:flutter/material.dart';

import '../theme/custom_theme.dart';

class LoadAndNavigateWidget {
  static void showLoadingAndNavigate(
      BuildContext context, Widget destinationScreen) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertBox(
            isDark: Theme.of(context).brightness == Brightness.dark);
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close the loading dialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => destinationScreen),
      );
    });
  }
}

class AlertBox extends StatelessWidget {
  final bool isDark;

  const AlertBox({
    Key? key,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        isDark ? CustomThemeProvider.darkTheme : CustomThemeProvider.lightTheme;

    return AlertDialog(
      backgroundColor:
          isDark ? theme.scaffoldBackgroundColor : theme.dialogBackgroundColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              isDark ? theme.primaryColor : theme.indicatorColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading...',
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
        ],
      ),
    );
  }
}
