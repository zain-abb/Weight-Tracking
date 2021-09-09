import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/data/providers/auth_provider.dart';
import 'package:weight_tracker/data/providers/weight_provider.dart';
import 'package:weight_tracker/presentation/router/app_router.dart';
import 'package:weight_tracker/presentation/screens/auth_screen.dart';
import 'package:weight_tracker/presentation/screens/home_screen.dart';
import 'package:weight_tracker/presentation/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthProvider>(
          create: (_) => AuthProvider(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthProvider>().authStateChanges,
          initialData: null,
        ),
        ChangeNotifierProvider.value(value: WeightProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: theme(),
        onGenerateRoute: onGenerateRoute,
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                    child: Text('Loading...'),
                  ),
                );
              }
              if (snapshot.hasData) {
                return HomeScreen();
              }
              return AuthScreen();
            }),
      ),
    );
  }
}
