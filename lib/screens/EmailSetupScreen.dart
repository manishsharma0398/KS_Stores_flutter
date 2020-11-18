import 'package:flutter/material.dart';

class EmailSetupScreen extends StatefulWidget {
  static String routeName = "/email-setup-screen";

  @override
  _EmailSetupScreenState createState() => _EmailSetupScreenState();
}

class _EmailSetupScreenState extends State<EmailSetupScreen> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> routesArgs =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          if (routesArgs['login']) Container(),
          if (!routesArgs['login']) Container(),
        ],
      ),
    );
  }
}
