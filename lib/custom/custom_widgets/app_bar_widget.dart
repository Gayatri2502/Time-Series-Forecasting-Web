import 'package:alpha_forecast_app/custom/custom_widgets/loading_widget.dart';
import 'package:alpha_forecast_app/custom/custom_widgets/pageroute_animation_widget.dart';
import 'package:alpha_forecast_app/screens/desktop_home_screen.dart';
import 'package:alpha_forecast_app/screens/detail_form.dart';
import 'package:alpha_forecast_app/screens/responsive_home_screen/desktop_home_body.dart';
import 'package:flutter/material.dart';

import '../../screens/about_screen/about_screen.dart';
import '../../screens/auth screens/auuth_screen.dart';
import '../../screens/contact_screen/contact_screen.dart';
import '../../screens/service screen/service_screen.dart';
import '../theme/custom_theme.dart';
import 'search_bar_widget.dart';

AppBar desktopAppBar(BuildContext context, bool isDarkMode) => AppBar(
      backgroundColor: isDarkMode
          ? darkAppBarTheme.backgroundColor
          : lightAppBarTheme.backgroundColor,
      leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.dehaze_sharp,
            color: isDarkMode
                ? darkAppBarTheme.iconTheme!.color
                : lightAppBarTheme.iconTheme!.color,
          )),
      title: Text(
        'Alphacentauric Business Intelligence',
        style: isDarkMode
            ? darkAppBarTheme.titleTextStyle
            : lightAppBarTheme.titleTextStyle,
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const DesktopHomeScreen();
                  }));
                },
                child: const Row(
                  children: [
                    Text(
                      'Home',
                      style: TextStyle(fontSize: 14.5, color: Colors.white),
                    ),
                    Icon(Icons.arrow_drop_down)
                  ],
                )),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const DesktopHomePage();
                  }));
                },
                child: const Row(
                  children: [
                    Text(
                      'Businesses',
                      style: TextStyle(fontSize: 14.5, color: Colors.white),
                    ),
                    Icon(Icons.arrow_drop_down)
                  ],
                )),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const ServiceScreen();
                  }));
                },
                child: const Row(
                  children: [
                    Text(
                      'Services',
                      style: TextStyle(fontSize: 14.5, color: Colors.white),
                    ),
                    Icon(Icons.arrow_drop_down)
                  ],
                )),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const ServiceScreen();
                  }));
                },
                child: const Row(
                  children: [
                    Text(
                      'Implementation Guide',
                      style: TextStyle(fontSize: 14.5, color: Colors.white),
                    ),
                    Icon(Icons.arrow_drop_down)
                  ],
                )),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const AboutScreen();
                  }));
                },
                child: const Row(
                  children: [
                    Text(
                      'About',
                      style: TextStyle(fontSize: 14.5, color: Colors.white),
                    ),
                    Icon(Icons.arrow_drop_down)
                  ],
                )),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const ServiceScreen();
                  }));
                },
                child: const Row(
                  children: [
                    Text(
                      'Blogs',
                      style: TextStyle(fontSize: 14.5, color: Colors.white),
                    ),
                    Icon(Icons.arrow_drop_down)
                  ],
                )),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const ServiceScreen();
                  }));
                },
                child: const Row(
                  children: [
                    Text(
                      'FAQs',
                      style: TextStyle(fontSize: 14.5, color: Colors.white),
                    ),
                    Icon(Icons.arrow_drop_down)
                  ],
                )),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const ContactScreen();
                  }));
                },
                child: const Row(
                  children: [
                    Text(
                      'Contact Us',
                      style: TextStyle(fontSize: 14.5, color: Colors.white),
                    ),
                    Icon(Icons.arrow_drop_down)
                  ],
                )),
          ],
        ),
      ),
      actions: [
        SearchWidget(),
        const SizedBox(
          width: 40,
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const DesktopHomePage();
              }));
            },
            child: Row(
              children: [
                const Icon(Icons.person),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'My Account',
                  style: TextStyle(
                      fontSize: 14.5,
                      color: isDarkMode
                          ? darkAppBarTheme.iconTheme!.color
                          : lightAppBarTheme.iconTheme!.color),
                ),
              ],
            )),
        const SizedBox(
          width: 40,
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const AuthScreen();
              }));
            },
            child: const Text(
              'Logout',
              style: TextStyle(fontSize: 14.5, color: Colors.black),
            )),
        IconButton(
          onPressed: () {
            // Show search bar
          },
          icon: Icon(
            Icons.search,
            color: isDarkMode
                ? darkAppBarTheme.iconTheme?.color
                : lightAppBarTheme.iconTheme!.color,
          ),
        ),
        PopupMenuButton<String>(
          iconColor: isDarkMode
              ? darkAppBarTheme.iconTheme!.color
              : lightAppBarTheme.iconTheme!.color,
          onSelected: (value) {
            // Handle popup menu selection
          },
          itemBuilder: (context) {
            return ['Profile', 'Contact Us'].map((String option) {
              return PopupMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList();
          },
        ),
      ],
    );

AppBar desktopAppBarOpen(BuildContext context, bool isDarkMode) => AppBar(
      backgroundColor: isDarkMode
          ? darkAppBarTheme.backgroundColor
          : lightAppBarTheme.backgroundColor,
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.dehaze_sharp),
        color: isDarkMode
            ? darkAppBarTheme.iconTheme!.color
            : lightAppBarTheme.iconTheme!.color,
      ),
      title: Text(
        'Alphacentauric Business Intelligence',
        style: isDarkMode
            ? darkAppBarTheme.titleTextStyle
            : lightAppBarTheme.titleTextStyle,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              AnimatedPageTransition(
                destinationPage: DesktopHomePage(),
              ),
            );
          },
          child: Text(
            'Home',
            style: TextStyle(
              fontSize: 17.5,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              AnimatedPageTransition(
                destinationPage: ServiceScreen(),
              ),
            );
          },
          child: Text(
            'Services',
            style: TextStyle(
              fontSize: 17.5,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return AboutScreen();
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOutQuart;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 500),
              ),
            );
          },
          child: Text(
            'About',
            style: TextStyle(
              fontSize: 17.5,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return ContactScreen();
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOutQuart;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 500),
              ),
            );
          },
          child: Text(
            'Contact',
            style: TextStyle(
              fontSize: 17.5,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.indigo,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            textStyle: TextStyle(fontSize: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
            shadowColor: Colors.grey,
            minimumSize: Size(100, 40),
          ),
          onPressed: () {
            LoadAndNavigateWidget.showLoadingAndNavigate(
              context,
              BusinessOwnerForm(isLogin: false),
            );
          },
          child: Text(
            'Log In',
            style: TextStyle(
              fontSize: 15.5,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            // Handle popup menu selection
          },
          itemBuilder: (BuildContext context) {
            return ['Profile', 'Contact Us'].map((String option) {
              return PopupMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList();
          },
        ),
      ],
    );
