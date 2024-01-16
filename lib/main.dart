import 'package:anjali/pages/auth_page.dart';
import 'package:anjali/pages/home_page.dart';
import 'package:anjali/pages/our_story_page.dart';
import 'package:anjali/util/global_keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
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
    if (index == 2) {
      _auth.signOut();
    }
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
      routes: {
        "/home": (BuildContext context) => const HomeScreen(),
        "/our_story": (BuildContext context) => const OurStory(),
        "/auth": (BuildContext context) => Authenticate(
              loginStatus: loginStatus,
              setLoginState: setLoginState,
            ),
      },
      debugShowCheckedModeBanner: false,
      title: "Anjali, my love",
      theme: ThemeData.from(
        colorScheme: const ColorScheme(
          primary: Color.fromARGB(255, 255, 163, 26),
          secondary: Color.fromARGB(255, 255, 163, 26),
          background: Color.fromARGB(255, 27, 27, 27),
          surface: Color.fromARGB(255, 27, 27, 27),
          error: Colors.red,
          onPrimary: Color(0xff1b1b1b),
          onSecondary: Color(0xff1b1b1b),
          onSurface: Color(0xFFFFFFFF),
          onBackground: Color(0xFFFFFFFF),
          onError: Color(0x001b1b1b),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        key: scaffoldKey,
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              color: const Color(0xFF1b1b1b),
              onPressed: () async {
                await _auth.signOut();
                setState(() {
                  loginStatus = false;
                });
              },
            )
          ],
          title: Text(
            "Completed ${daysBetween(DateTime(2022, 12, 24), DateTime.now())} days of us!",
            style: const TextStyle(
              fontSize: 20,
              color: Color(0xFF1b1b1b),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 255, 163, 26),
          elevation: 10,
        ),
        bottomNavigationBar: BottomNavigationBar(
          key: bottomNavigationBarKey,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          showSelectedLabels: true,
          unselectedIconTheme: const IconThemeData(
            color: Color(0xFFFFFFFF),
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
