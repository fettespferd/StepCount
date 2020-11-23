import 'package:flutter/material.dart';
import 'package:pizzaCalc/app/module.dart';

class ProfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dein Profil'),
        backgroundColor: Colors.black12,
      ),
      body: GradientBackground(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text('Ausloggen'),
                  onPressed: () async {
                    await services.firebaseAuth.signOut();
                    await context.rootNavigator.pushReplacementNamed('/login');
                  },
                ),
                ElevatedButton(
                  child: Text('Einstellungen'),
                  onPressed: () => context.rootNavigator.pushNamed('/settings'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
