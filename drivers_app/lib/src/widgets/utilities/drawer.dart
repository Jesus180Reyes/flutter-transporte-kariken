import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:drivers_app/src/services/config_maps.dart';

class Drawers extends StatelessWidget {
  const Drawers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const SizedBox(
            height: 165,
            child: DrawerHeader(
              decoration: BoxDecoration(
                  // color: Colors.red,
                  ),
              child: InfoProfile(),
            ),
          ),
          const Divider(
            thickness: 1,
            height: 10,
          ),
          const SizedBox(
            height: 12,
          ),
          const ListTile(
            leading: Icon(Icons.history),
            title: Text(
              'Mis Viajes',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Mi Perfil',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text(
              'About',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.directions),
            title: Text(
              'Mis Direcciones',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, 'login');
            },
            child: const ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                'Cerrar Sesion',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoProfile extends StatelessWidget {
  const InfoProfile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/user_icon.png',
          height: 65,
          width: 65,
        ),
        const SizedBox(
          width: 16,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              (userCurrentInfo != null)
                  ? '${userCurrentInfo!.name} ${userCurrentInfo!.lastName}'
                  : "Profile Name",
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(
              height: 6.0,
            ),
            const Text('Ver Perfil'),
          ],
        )
      ],
    );
  }
}
