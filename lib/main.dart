import 'package:KS_Stores/screens/EmailSetupScreen.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import './providers/AuthProvider.dart';
import './providers/ProductProvider.dart';

import './screens/AuthScreen.dart';
import './screens/users/HomeScreen.dart';
import './screens/SplashScreen.dart';
import './screens/admin/SectionScreen.dart';

import './utils/Styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        ChangeNotifierProvider.value(
          value: ProductProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: "Kufam",
          primarySwatch: MaterialColor(0xFF2B2B52, color),
        ),
        title: "KS Stores",
        debugShowCheckedModeBanner: false,
        home: InitPage(),
        // initialRoute: AuthScreen.routeName,
        routes: {
          AuthScreen.routeName: (context) => AuthScreen(),
          HomeScreen.routeName: (context) => HomeScreen(),
          ProductSectionScreen.routeName: (context) => ProductSectionScreen(),
          EmailSetupScreen.routeName: (context) => EmailSetupScreen()
        },
      ),
    );
  }
}

class InitPage extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: auth.authStateChanges(),
      builder: (_, snap) {
        if (snap.hasError) return Text("Something went wrong");
        if (!snap.hasData) return AuthScreen();
        switch (snap.connectionState) {
          case ConnectionState.waiting:
            return SplashScreen();
            break;
          default:
            return FutureBuilder(
              future: Provider.of<AuthProvider>(context, listen: false)
                  .getUserDetailsAtStartup(),
              builder: (_, snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  final bool isAdmin =
                      Provider.of<AuthProvider>(context, listen: false)
                          .isUserAdmin;

                  print("admin: $isAdmin");

                  if (isAdmin) {
                    return ProductSectionScreen();
                  } else {
                    return HomeScreen();
                  }
                }
                return SplashScreen();
              },
            );
        }
      },
    );
  }
}
