import 'package:flutter/material.dart';
// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:mezunlarsistemi/mesaj/app/landing_page.dart';
import 'package:provider/provider.dart';
import 'package:mezunlarsistemi/locator.dart';
 import 'mesaj/viewmodel/user_model.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
         if (snapshot.hasError) {
          return Text("hata cıktı");
        }

         if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }

         return CircularProgressIndicator();
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserModel(),
      child: MaterialApp(
          title: 'MEZUN TRAKYA',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.cyan,
          ),
      home:LandingPage())
    );
  }
}