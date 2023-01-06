import 'package:drivers_app/main.dart';
import 'package:drivers_app/src/widgets/auth_background.dart';
import 'package:drivers_app/src/widgets/card_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drivers_app/src/providers/register_form_provider.dart';
import 'package:drivers_app/src/ui/input_decorations.dart';
import 'package:drivers_app/src/widgets/utilities/progress_dialog.dart';
import 'package:drivers_app/src/widgets/widgets.dart';

import '../../main.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Crear Cuenta',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => RegisterFormProvider(),
                      child: RegisterForm(),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'login'),
                child: const Text(
                  'Ya tienes Una Cuenta? Inicia Sesion',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: use_key_in_widget_constructors, must_be_immutable
class RegisterForm extends StatelessWidget {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController lastNameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);

    return Form(
      key: registerForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            controller: nameTextEditingController,
            obscureText: false,
            autocorrect: false,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'ej: John',
              labelText: 'Nombre',
              prefixIcon: Icons.person,
            ),
            onChanged: (value) => registerForm.name = value,
            validator: (value) {
              return (value != null && value.length > 1)
                  ? null
                  : 'Ingresa Tu Nombre';
            },
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            controller: lastNameTextEditingController,
            obscureText: false,
            autocorrect: false,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'ej: Dominguez',
              labelText: 'Apellido',
              prefixIcon: Icons.person,
            ),
            onChanged: (value) => registerForm.lastName = value,
            validator: (value) {
              return (value != null && value.length > 1)
                  ? null
                  : 'Ingresa Tu Apellido';
            },
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            controller: phoneTextEditingController,
            obscureText: false,
            autocorrect: false,
            keyboardType: TextInputType.phone,
            decoration: InputDecorations.authInputDecoration(
              hintText: '212-324-4152',
              labelText: 'Numero de Telefono',
              prefixIcon: Icons.phone,
            ),
            onChanged: (value) => registerForm.cel = value,
            validator: (value) {
              return (value != null && value.length == 10)
                  ? null
                  : 'El Numero de Digitos debe ser de 10 digitos';
            },
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            controller: emailTextEditingController,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'Example@gmail.com',
              labelText: 'Correo Electronico',
              prefixIcon: Icons.alternate_email_sharp,
            ),
            onChanged: (value) => registerForm.email = value,
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = RegExp(pattern);
              return regExp.hasMatch(value ?? '')
                  ? null
                  : 'El Ingresado no luce como un Correo';
            },
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            controller: passwordTextEditingController,
            obscureText: true,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: '*********',
              labelText: 'Contraseña',
              prefixIcon: Icons.lock_outline,
            ),
            onChanged: (value) => registerForm.password = value,
            validator: (value) {
              return (value != null && value.length >= 6)
                  ? null
                  : 'La Contraseña debe ser mayor a 6 Caracteres';
            },
          ),
          const SizedBox(
            height: 30,
          ),
          MaterialButton(
            onPressed: () {
              (!registerForm.isValidForm()) ? null : registerNewUser(context);
              // Navigator.pushReplacementNamed(context, 'main');
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.indigo,
            child: Container(
              padding: const EdgeInsets.all(15),
              // padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: const Text(
                'Crear Cuenta',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ProgressDialog(
              message: 'Creando Cuenta, Porfavor Espera...');
        },
        barrierDismissible: false);
    final User? firebaseUser =
        (await firebaseAuth.createUserWithEmailAndPassword(
      email: emailTextEditingController.text,
      password: passwordTextEditingController.text,
    ))
            .user;

    if (firebaseUser != null) {
      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "lastName": lastNameTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        // "password": passwordTextEditingController.text.trim(),
      };
      userRef.child(firebaseUser.uid).set(userDataMap);
      Navigator.pushReplacementNamed(context, 'main');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
            'Cuenta Creada Exitosamente!!😊😊',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
            'Upps Parece que Hubo un Problema con la Creacion de cuenta, Porfavor Vuelve a Intentarlo',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }
}
