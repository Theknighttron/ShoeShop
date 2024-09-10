import 'package:flutter/material.dart';
import 'screens/signin_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Your App Name',
            theme: ThemeData(
                primarySwatch: Colors.blue,
                brightness: Brightness.dark,
                scaffoldBackgroundColor: Colors.blue.shade900,
                appBarTheme: AppBarTheme(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                ),
                textTheme: TextTheme(
                    bodyLarge: TextStyle(color: Colors.white70),
                    bodyMedium: TextStyle(color: Colors.white70),
                ),
            ),
            home: const SigninScreen(),
        );
    }
}
