import 'package:chat_app/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import 'login_page.dart';
import 'signup_page.dart';

class AuthGate extends StatelessWidget {
  final _scrollController = FixedExtentScrollController();
  AuthGate({super.key});

  void scrollToIndex(int index) {
    _scrollController.animateToItem(
      index,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePage();
        } else {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: AppColors.lightBlue,
            body: SafeArea(
              child: Center(
                child: ListWheelScrollView(
                  controller: _scrollController,
                  itemExtent: 520,

                  diameterRatio: 1.5, // Adjust the "wheel" curvature
                  perspective: 0.003,
                  children: [
                    LoginPage(onSwitch: () => scrollToIndex(1)),
                    SignupPage(onSwitch: () => scrollToIndex(0)),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
