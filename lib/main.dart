<<<<<<< HEAD
import 'package:e_scolar_app/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_route/app_routes.dart';
=======
import 'package:e_scolar_app/home_screen/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

>>>>>>> 7961d6c2c2f8e2551eeff971619272f84bc666cf
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
<<<<<<< HEAD
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
    ),
  ], child: const MyApp()));
=======
  runApp(const MyApp());
>>>>>>> 7961d6c2c2f8e2551eeff971619272f84bc666cf
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
=======
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
>>>>>>> 7961d6c2c2f8e2551eeff971619272f84bc666cf
      // routerConfig: ,
    );
  }
}
