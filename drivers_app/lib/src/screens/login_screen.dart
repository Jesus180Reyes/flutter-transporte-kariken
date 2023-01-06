import 'package:drivers_app/main.dart';
import 'package:drivers_app/src/providers/login_form_provider.dart';
import 'package:drivers_app/src/ui/input_decorations.dart';
import 'package:drivers_app/src/widgets/auth_background.dart';
import 'package:drivers_app/src/widgets/card_container.dart';
import 'package:drivers_app/src/widgets/utilities/progress_dialog.dart';
import 'package:drivers_app/src/widgets/utilities/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:drivers_app/src/widgets/widgets.dart';

import '../../main.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
                      'Inicio de Sesion',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _LoginForm(),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'register'),
                child: const Text(
                  'Crear una Nueva Cuenta',
                  style: TextStyle(
                    fontSize: 17,
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

// ignore: must_be_immutable
class _LoginForm extends StatelessWidget {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            controller: emailTextEditingController,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'Example@gmail.com',
              labelText: 'Correo Electronico',
              prefixIcon: Icons.alternate_email_sharp,
            ),
            onChanged: (value) => loginForm.email = value,
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
            onChanged: (value) => loginForm.password = value,
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
              (!loginForm.isValidForm())
                  ? null
                  : loginAndAuthenticateUser(context);

              // : Navigator.pushReplacementNamed(context, 'main');
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.indigo,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: const Text(
                'Ingresar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  void loginAndAuthenticateUser(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ProgressDialog(
              message: 'Iniciando Sesion, Porfavor Espera...');
        },
        barrierDismissible: false);
    final User? firebaseUser = (await firebaseAuth
            .signInWithEmailAndPassword(
      email: emailTextEditingController.text,
      password: passwordTextEditingController.text,
    )
            .catchError((error) {
      Navigator.pop(context);
      displayToastMessage('Error: ' + error.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      userRef.child(firebaseUser.uid).once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          Navigator.pushReplacementNamed(context, 'main');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 3),
              content: Text(
                'Inicio de Sesion Exitosamente😉',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );

          // displayToastMessage('Inicio de Sesion Exitosamente', context);

        } else {
          Navigator.pop(context);

          firebaseAuth.signOut();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 3),
              content: Text(
                'Este Correo No esta Registrado, Crea una Cuenta',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }
      });
    } else {
      Navigator.pop(context);

      // displayToastMessage(
      //     'Upps Parece que Hubo un error, Vuelve a Intentarlo', context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
            'Upps Parece que Hubo un error, Vuelve a Intentarlo',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }
}
