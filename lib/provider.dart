// For password visibility in Login Page

import 'package:flutter_riverpod/flutter_riverpod.dart';

final passwordVisibilityProviderLogin = StateProvider<bool>((ref) {
  return false;
});
// For password visibility in Sign up Page
final passwordVisibilityProviderSignUp = StateProvider<bool>((ref) {
  return false;
});

// For confirm password visibility in Sign up Page
final confirmPasswordVisibilityProviderSignUp = StateProvider<bool>((ref) {
  return false;
});



// Query entered by user in Search bar
final searchQuery = StateProvider<String>((ref) {
  return '';
});

//Query matched with data

List<String> data = ['Hassan', 'Ali', 'Taha', 'SomeOne', 'Adams'];
List<String> searchResults = [];
