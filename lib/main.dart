import 'dart:io';

import 'package:anjali/pages/auth_page.dart';
import 'package:anjali/pages/home_page.dart';
import 'package:anjali/pages/our_story_page.dart';
import 'package:anjali/util/global_keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restart_app/restart_app.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
  sleep(
    const Duration(milliseconds: 2500),
  );
  FlutterNativeSplash.remove();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late bool loginStatus;

  final routes = [
    const MyApp(),
    const OurStory(),
  ];

  changeIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    if (_auth.currentUser == null) {
      setState(() {
        loginStatus = false;
      });
    } else {
      setState(() {
        loginStatus = true;
      });
    }

    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          loginStatus = false;
        });
      } else {
        setState(() {
          loginStatus = true;
        });
      }
    });
  }

  String daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round().toString();
  }

  setLoginState(bool status) {
    setState(() {
      loginStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Anjali, my love",
      themeMode: ThemeMode.light,
      theme: ThemeData(
        textTheme: GoogleFonts.gloriaHallelujahTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.blue,
        colorScheme: const ColorScheme.light(
          background: Colors.white,
          primary: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        key: scaffoldKey,
        appBar: AppBar(
          foregroundColor: Colors.blue[900],
          surfaceTintColor: Colors.blue[900],
          shadowColor: Colors.blue[100],
          actions: loginStatus ? [
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              color: const Color.fromARGB(255, 13, 71, 161),
              onPressed: () {
                _auth.signOut();
                Restart.restartApp();
              },
            )
          ] : [],
          title: Text(
            "Completed ${daysBetween(DateTime(2022, 12, 24), DateTime.now())} days of us!",
            style: const TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 13, 71, 161),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 10,
        ),
        bottomNavigationBar: BottomNavigationBar(
          key: bottomNavigationBarKey,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          showSelectedLabels: true,
          selectedIconTheme: const IconThemeData(
            color: Colors.blue,
          ),
          unselectedIconTheme: const IconThemeData(
            color: Color.fromARGB(255, 13, 71, 161),
          ),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded),
              label: "Our Story",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lock_rounded),
              label: "Auth",
            ),
          ],
        ),
        body: loginStatus == false
            ? Authenticate(
                loginStatus: loginStatus,
                setLoginState: setLoginState,
              )
            : _selectedIndex == 0
                ? const HomeScreen()
                : _selectedIndex == 1
                    ? const OurStory()
                    : Authenticate(
                        loginStatus: loginStatus,
                        setLoginState: setLoginState,
                      ),
      ),
    );
  }
}
