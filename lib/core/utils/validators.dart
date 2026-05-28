import '../constants/app_constants.dart';

/// Form field validators used across auth and profile screens.
class Validators {
  Validators._();

  static String? displayName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Display name is required';
    final trimmed = value.trim();
    if (trimmed.length < AppConstants.displayNameMinLength) {
      return 'Must be at least ${AppConstants.displayNameMinLength} characters';
    }
    if (trimmed.length > AppConstants.displayNameMaxLength) {
      return 'Must be at most ${AppConstants.displayNameMaxLength} characters';
    }
    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(trimmed)) {
      return 'Only letters and spaces allowed';
    }
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.isEmpty) return 'Username is required';
    final v = value.startsWith('@') ? value.substring(1) : value;
    if (v.length < AppConstants.usernameMinLength) {
      return 'Must be at least ${AppConstants.usernameMinLength} characters';
    }
    if (v.length > AppConstants.usernameMaxLength) {
      return 'Must be at most ${AppConstants.usernameMaxLength} characters';
    }
    if (!RegExp(r'^[a-z0-9_]+$').hasMatch(v)) {
      return 'Only lowercase letters, numbers, and underscores';
    }
    return null;
  }

  static String? age(String? value) {
    if (value == null || value.isEmpty) return 'Age is required';
    final age = int.tryParse(value);
    if (age == null) return 'Enter a valid number';
    if (age < AppConstants.minAge) return 'You must be at least ${AppConstants.minAge} years old';
    if (age > AppConstants.maxAge) return 'Enter a valid age';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value.replaceAll(' ', ''))) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < AppConstants.passwordMinLength) {
      return 'Must be at least ${AppConstants.passwordMinLength} characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Must contain at least one uppercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Must contain at least one number';
    }
    return null;
  }

  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    return null;
  }
}
