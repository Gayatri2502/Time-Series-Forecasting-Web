import 'package:flutter/material.dart';

import '../custom/custom_widgets/app_bar_widget.dart';
import '../custom/custom_widgets/login_form_widget.dart';
import '../custom/custom_widgets/signup_form_widget.dart';

class BusinessOwnerForm extends StatefulWidget {
  BusinessOwnerForm({super.key, required this.isLogin});
  bool isLogin;

  @override
  _BusinessOwnerFormState createState() => _BusinessOwnerFormState();
}

class _BusinessOwnerFormState extends State<BusinessOwnerForm> {
  @override
  void initState() {
    widget.isLogin = !widget.isLogin;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: desktopAppBarOpen(context, true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(50),
                        width: 850,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '''Data Dynamo: Transforming Complexity into Captivating Visual Stories! 🚀 ''',
                              style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.indigo.shade900),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              '''Empowering Your Business with Data-Driven Insights and Success Strategies!!!''',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Positioned(
                              left: 1,
                              bottom: 25,
                              child: Image.network(
                                'asset/cubics.gif',
                                scale: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          // Image.asset(
                          //   'asset/24.png',
                          //   scale: 1,
                          // ),
                          // Image.asset(
                          //   'asset/17.png',
                          //   scale: 1.5,
                          // ),
                        ],
                      )
                      // Image.asset('asset/35 (3).jpeg')
                    ],
                  ),
                  widget.isLogin ? const LoginForm() : const SignupForm(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
