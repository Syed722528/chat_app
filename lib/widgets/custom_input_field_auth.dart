import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

InputDecoration customInputFieldDecoration(String hint, IconButton iconButton) {
  return InputDecoration(
    errorStyle: TextStyle(color: AppColors.darkBlue),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.darkBlue),
    ),
    suffixIconColor: AppColors.darkBlue,
    border: OutlineInputBorder(),
    hintText: '$hint . . .',
    fillColor: Colors.white,
    filled: true,
    suffixIcon: iconButton,
  );
}
