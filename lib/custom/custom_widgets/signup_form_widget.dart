import 'package:flutter/material.dart';

import '../../auth/auth_services/auth_services.dart';
import '../../screens/detail_form.dart';
import '../theme/custom_theme.dart';
// Import your CustomThemeProvider class

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  String businessType = '';
  String servicesProvided = '';
  String ownerName = '';
  String location = '';
  String id = '';
  bool isHovered = false;
  AuthServices authServices = AuthServices();
  final _formKey = GlobalKey<FormState>();

  bool isLogin = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        CustomThemeProvider(); // Initialize your CustomThemeProvider
    final ThemeData theme = themeProvider.getTheme(); // Get the current theme

    return Column(
      children: [
        const SizedBox(
          height: 55,
        ),
        Text(
          'Create a new account',
          style:
              theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          alignment: Alignment.centerRight,
          width: MediaQuery.of(context).size.width * 0.35,
          child: Center(
            child: Opacity(
              opacity: 0.9, // Adjust the opacity as needed
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Company Name ',
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a business type.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          businessType = value!;
                        },
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'ISO ID',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter services provided.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          servicesProvided = value!;
                        },
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Business service ',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter owner name.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          ownerName = value!;
                        },
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Admin Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter owner name.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          ownerName = value!;
                        },
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'phone number',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an ID.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          id = value!;
                        },
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter location.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          location = value!;
                        },
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email-Id',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter official email';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          ownerName = value!;
                        },
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'create password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter owner name.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          ownerName = value!;
                        },
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'confirm password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please .';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          ownerName = value!;
                        },
                      ),
                      const SizedBox(height: 10.0),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.indigo,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          textStyle: TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 4,
                          shadowColor: Colors.grey,
                          minimumSize: Size(100, 40),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isLogin = false;
                              });
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (_) {
                                return BusinessOwnerForm(isLogin: isLogin);
                              }));
                            },
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        "--------------------OR-------------------",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      ElevatedButton.icon(
                        onPressed: () {
                          authServices.signUpWithGoogle(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.secondary,
                        ),
                        icon: const Icon(
                          Icons.g_mobiledata,
                        ),
                        label: const Text(
                          'Sign up with Google',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
