import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mapas/controllers/gps_controller.dart';
import 'package:mapas/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => GPSController())],
      child: MaterialApp(
        title: 'App de Mapas',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {'/': (context) => const InicializePage()},
      ),
    );
  }
}

class InicializePage extends StatefulWidget {
  const InicializePage({super.key});

  @override
  State<InicializePage> createState() => _InicializeState();
}

class _InicializeState extends State<InicializePage> {
  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
