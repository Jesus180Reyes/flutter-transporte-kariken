import 'package:drivers_app/src/screens/screens.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drivers_app/src/providers/appdata_provider.dart';
import 'package:drivers_app/src/screens/payment_screen.dart';
import 'package:drivers_app/src/screens/search_screen.dart';

import 'src/screens/payment_screen.dart';
import 'src/screens/search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

DatabaseReference userRef =
    FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppDataProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Taxi Driver App',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Colors.grey[200],
        ),
        initialRoute: 'login',
        routes: {
          'main': (_) => const MainScreen(),
          'login': (_) => const LoginScreen(),
          'register': (_) => const RegisterScreen(),
          'intro': (_) => const IntroScreen(),
          'search': (_) => const SearchScreen(),
          'payment': (_) => const PaymentScreen(),
        },
      ),
    );
  }
}
