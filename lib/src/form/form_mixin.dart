import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

/// A mixin that adds form submission capabilities to widgets.
///
/// This mixin adds a [GlobalKey] for a [FormState] to the widget,
/// as well as a method for form submission. The submission process includes
/// validating and saving the form state, followed by a custom submission
/// routine defined by the overriding [onSubmit] method.
///
/// Example usage.
///
/// ```dart
/// import 'package:sparkit/sparkit.dart';
/// import 'package:flutter/material.dart';
///
/// class MyFormView extends StatelessWidget with FormMixin {
///   MyFormView({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return Form(
///       child: Column(children: [
///         // Other Widgets ...
///         TextButton(
///           onPressed: submit,
///           child: const Text('Submit'),
///         )
///       ]),
///     );
///   }
///
///   @override
///   void onSubmit() {
///     // add implementation as per need.
///   }
/// }
/// ```
mixin FormMixin on Diagnosticable {
  /// The global key used to access the form state.
  final formKey = GlobalKey<FormState>();

  /// Submits the form.
  ///
  /// The form state is accessed via [formKey]. If the form state is valid,
  /// it is saved and the [onSubmit] method is triggered. If the form state is
  /// null or not valid then an error is thrown.
  void submit() {
    final formState = formKey.currentState;

    if (formState == null) {
      throw FlutterError(
        'FormMixin: formKey must be attached to a Form widget before '
        'using the submitter method.',
      );
    }

    if (formState.validate()) {
      formState.save();
      onSubmit();
    }
  }

  /// Defines a custom submission routine.
  ///
  /// This method is triggered by the [submit] method if the form state is valid.
  /// It can be asynchronously overridden in the widget using the mixin to define
  /// a custom form submission routine.
  FutureOr<void> onSubmit();
}
