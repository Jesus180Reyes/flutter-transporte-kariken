import 'package:flutter/material.dart';

class RegisterFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String name = '';
  String lastName = '';
  String cel = '';

  bool isValidForm() {
    // print('$email - $password');
    // print(formKey.currentState?.validate());
    return formKey.currentState?.validate() ?? false;
  }
}
