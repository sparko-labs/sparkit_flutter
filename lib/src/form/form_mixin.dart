import 'package:flutter/widgets.dart';

///
mixin FormMixin<T extends StatefulWidget, U> on State<T> {
  ///
  final formKey = GlobalKey<FormState>();

  ///
  U? submit() {
    final formState = formKey.currentState;

    if (formState == null) {
      throw FlutterError(
        'FormMixin: formKey must be attached to a Form widget before '
        'using the submitter method.',
      );
    }

    if (formState.validate()) {
      formState.save();

      return formData;
    }

    return null;
  }

  ///
  U get formData;
}
