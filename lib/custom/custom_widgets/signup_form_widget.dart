import 'package:flutter/material.dart';

import '../../auth/auth_services/auth_services.dart';
import '../../screens/detail_form.dart';
import '../helper_widgets/helper_functions.dart';

// onSubmit function
void onSubmit(BuildContext context, GlobalKey<FormState> formKey,
    String ownerName, String phoneNumber, String email, String password) async {
  if (formKey.currentState!.validate()) {
    formKey.currentState!.save();

    print('Email after form validation: $email');

    try {
      await createUserWithEmailAndPassword(
        email: email,
        password: password,
        ownerName: ownerName,
        phoneNumber: phoneNumber,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User account created successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create user account: $e')),
      );
    }
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  String ownerName = '';
  String phoneNumber = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  AuthServices authServices = AuthServices();

  bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(height: 55),
        Text(
          'Create a new account',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.5),
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
              opacity: 0.9,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // TextFormField(
                      //   decoration: const InputDecoration(
                      //     labelText: 'Admin Name',
                      //     border: OutlineInputBorder(),
                      //   ),
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'Please enter owner name.';
                      //     }
                      //     return null;
                      //   },
                      //   onSaved: (value) {
                      //     ownerName = value!;
                      //   },
                      // ),
                      // const SizedBox(height: 10.0),
                      // TextFormField(
                      //   decoration: const InputDecoration(
                      //     labelText: 'Phone Number',
                      //     border: OutlineInputBorder(),
                      //   ),
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'Please enter a phone number.';
                      //     }
                      //     return null;
                      //   },
                      //   onSaved: (value) {
                      //     phoneNumber = value!;
                      //   },
                      // ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email-Id',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an email.';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          email = value!;
                        },
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Create Password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          password = value!;
                        },
                        obscureText: true,
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please confirm your password.';
                          }
                          if (value != confirmPassword) {
                            return 'Passwords do not match.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          confirmPassword = value;
                        },
                        obscureText: true,
                      ),
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
                        onPressed: () {
                          onSubmit(context, _formKey, ownerName, phoneNumber,
                              email, password);
                        },
                        child: const Text(
                          'Sign Up',
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
                              'Log In ',
                              style: TextStyle(
                                color: theme.colorScheme.secondary,
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
                        icon: const Icon(Icons.g_mobiledata),
                        label: const Text(
                          'SignUp with Google',
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
