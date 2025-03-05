import 'package:chat_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider.dart';
import '../utils/validators.dart';
import '../widgets/custom_input_field_auth.dart';

class LoginPage extends StatelessWidget {
  final VoidCallback onSwitch;
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  LoginPage({super.key, required this.onSwitch});

  final email = TextEditingController();

  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.veryLightBlue,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlue,
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 30,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: TextStyle(
                color: AppColors.darkBlue,
                fontSize: 40,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              validator: emailValidator,
              decoration: customInputFieldDecoration(
                'Email',
                IconButton(onPressed: () {}, icon: Icon(Icons.mail)),
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                final isPasswordVisible = ref.watch(
                  passwordVisibilityProviderLogin,
                );
                return TextFormField(
                  controller: password,
                  obscureText: !isPasswordVisible,
                  validator: passwordValidator,
                  keyboardType: TextInputType.text,
                  decoration: customInputFieldDecoration(
                    'Password',
                    IconButton(
                      onPressed: () {
                        ref
                            .read(passwordVisibilityProviderLogin.notifier)
                            .state = !isPasswordVisible;
                      },
                      icon:
                          isPasswordVisible
                              ? Icon(Icons.remove_red_eye)
                              : Icon(Icons.visibility_off),
                    ),
                  ),
                );
              },
            ),
            Consumer(
              builder: (context, ref, child) {
                return GestureDetector(
                  onTap: () {
                    if (formKey.currentState!.validate()) {}
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.darkBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Log in',
                      style: TextStyle(color: AppColors.veryLightBlue),
                    ),
                  ),
                );
              },
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account? "),
                GestureDetector(
                  onTap: onSwitch,
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      color: AppColors.darkBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
