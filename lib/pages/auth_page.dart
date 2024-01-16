import 'package:anjali/util/global_keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({
    super.key,
    required this.loginStatus,
    required this.setLoginState,
  });

  final bool loginStatus;
  final Function setLoginState;

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  int _selectedIndex = 0;
  bool _showPassword = false;
  late bool toRender;

  @override
  void initState() {
    super.initState();
    if (_auth.currentUser == null) {
      setState(() {
        toRender = true;
      });
    } else {
      setState(() {
        toRender = false;
      });
    }
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  register() async {
    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        UserCredential res = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        User user = res.user!;
        user.updateDisplayName(_nameController.text);
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 2000),
            closeIconColor: Color(0x001b1b1b),
            backgroundColor: Colors.green,
            padding: EdgeInsets.all(5),
            behavior: SnackBarBehavior.floating,
            showCloseIcon: true,
            content: Text(
              'Your account is created',
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 163, 26), fontSize: 14),
            ),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
            const SnackBar(
              duration: Duration(milliseconds: 2000),
              closeIconColor: Color.fromARGB(255, 255, 163, 26),
              backgroundColor: Colors.red,
              padding: EdgeInsets.all(5),
              behavior: SnackBarBehavior.floating,
              showCloseIcon: true,
              content: Text(
                'The password provided is too weak',
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 163, 26), fontSize: 14),
              ),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
            const SnackBar(
              duration: Duration(milliseconds: 2000),
              closeIconColor: Color.fromARGB(255, 255, 163, 26),
              backgroundColor: Colors.red,
              padding: EdgeInsets.all(5),
              behavior: SnackBarBehavior.floating,
              showCloseIcon: true,
              content: Text(
                'The account already exists for that email',
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 163, 26), fontSize: 14),
              ),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 2000),
          closeIconColor: Color.fromARGB(255, 255, 163, 26),
          backgroundColor: Colors.red,
          padding: EdgeInsets.all(5),
          behavior: SnackBarBehavior.floating,
          showCloseIcon: true,
          content: Text(
            'Password and Confirm Password does not match',
            style: TextStyle(
                color: Color.fromARGB(255, 255, 163, 26), fontSize: 14),
          ),
        ),
      );
    }
  }

  login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      widget.setLoginState(true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 2000),
            closeIconColor: Color.fromARGB(255, 255, 163, 26),
            backgroundColor: Colors.red,
            padding: EdgeInsets.all(5),
            behavior: SnackBarBehavior.floating,
            showCloseIcon: true,
            content: Text(
              'No user found for that email',
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 163, 26), fontSize: 14),
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 2000),
            closeIconColor: Color.fromARGB(255, 255, 163, 26),
            backgroundColor: Colors.red,
            padding: EdgeInsets.all(5),
            behavior: SnackBarBehavior.floating,
            showCloseIcon: true,
            content: Text(
              'Wrong password provided for that user',
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 163, 26), fontSize: 14),
            ),
          ),
        );
      }
    }
  }

  Widget loginWidget() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "LOGIN",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 255, 163, 26),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 255, 163, 26),
                ),
              ),
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 255, 163, 26),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: _passwordController,
              obscureText: !_showPassword,
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 255, 163, 26),
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
                labelText: 'Password',
                labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 255, 163, 26),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                      color: const Color.fromARGB(255, 255, 163, 26)),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      login();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 163, 26),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 163, 26),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget registerWidget() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
              "REGISTER",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 255, 163, 26),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
                labelText: 'Name',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 255, 163, 26),
                ),
              ),
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 255, 163, 26),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 255, 163, 26),
                ),
              ),
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 255, 163, 26),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 255, 163, 26),
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
                labelText: 'Password',
                labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 255, 163, 26),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color.fromARGB(255, 255, 163, 26)),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _confirmPasswordController,
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 255, 163, 26),
              ),
              obscureText: !_isConfirmPasswordVisible,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
                labelText: 'Confirm Password',
                labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 255, 163, 26),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: const Color.fromARGB(255, 255, 163, 26),
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                    onPressed: () {
                      register();
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 163, 26),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 163, 26),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: toRender
              ? _selectedIndex == 0
                  ? loginWidget()
                  : registerWidget()
              : const Text(
                  "You are already logged in, please proceed with my app.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 163, 26),
                  ),
                ),
        ),
      ),
    );
  }
}
