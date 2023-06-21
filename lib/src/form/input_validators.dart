import 'package:flutter/widgets.dart';

/// `InputValidator` is a utility class that provides common input validations.
/// It contains static functions that each return a `FormFieldValidator`.
/// These functions can be used to validate form fields in Flutter.
abstract final class InputValidators {
  static final _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$",
  );

  /// Returns a validator that checks if the input string matches the given [regExp].
  ///
  /// If the input string doesn't match, it returns the given [message].
  static FormFieldValidator<String> match({
    required RegExp regExp,
    String? message,
  }) {
    message ??= 'Input must match $regExp pattern';
    return (String? value) {
      if (!regExp.hasMatch(value ?? '')) return message;
      return null;
    };
  }

  /// Returns a validator that checks if the input string is a valid email address.
  ///
  /// If the input string is not a valid email, it returns the given [message].
  static FormFieldValidator<String> email({
    String message = 'This is not a valid email address',
  }) {
    return (String? value) {
      if (!_emailRegExp.hasMatch(value ?? '')) return message;
      return null;
    };
  }

  /// Returns a validator that checks if the length of the input string is
  /// between [min] and [max].
  ///
  /// If the length of the input string is less than [min], it returns [minMessage].
  /// If the length of the input string is more than [max], it returns [maxMessage].
  static FormFieldValidator<String> length({
    int? max,
    int min = 0,
    String? minMessage,
    String? maxMessage,
  }) {
    max ??= 10000;

    maxMessage ??= 'Maximum $max characters are allowed';
    minMessage ??= 'Minimum $min characters are required';

    return (String? value) {
      if (value == null || value.length < min) return minMessage;
      if (value.length > max!) return maxMessage;
      return null;
    };
  }

  /// Returns a validator that checks if the input string contains the given [pattern].
  ///
  /// If the input string doesn't contain the pattern, it returns the given [message].
  static FormFieldValidator<String> contains({
    required String pattern,
    String? message,
  }) {
    assert(pattern.isNotEmpty, '`pattern` must not be empty');
    message ??= 'Input must include `$pattern` inside it';

    return (String? value) {
      if (!value!.contains(pattern)) return message;
      return null;
    };
  }

  /// Returns a validator that checks if the input string is a valid password.
  ///
  /// The password must be at least 8 characters long, have at least one uppercase,
  /// one lowercase and one number.
  ///
  /// If the input string is not a valid password, it returns the given [message].
  static FormFieldValidator<String> password({
    String message =
        'Must have at least 8 characters, uppercase, lowercase & number',
  }) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'This field is required';
      }

      final regExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
      if (value.length < 8 || !regExp.hasMatch(value)) {
        return message;
      }

      return null;
    };
  }

  /// Returns a validator that checks if the input string is not empty.
  ///
  /// If the input string is empty, it returns the given [message].
  static FormFieldValidator<String> required({
    String message = 'This field is required',
  }) {
    return (String? value) {
      if (value == null || value.isEmpty) return message;
      return null;
    };
  }

  /// Returns a validator that sequentially applies all the validators from the
  /// given [validators] list.
  ///
  /// The function stops executing and returns the error message as soon as a
  /// validator fails.
  static FormFieldValidator<T> multiple<T>(
    List<FormFieldValidator<T>> validators,
  ) {
    return (T? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }

      return null;
    };
  }
}
