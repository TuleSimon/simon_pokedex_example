import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simonpokedex/pages/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simonpokedex/services/database_service.dart';
import 'package:simonpokedex/services/http_service.dart';

void main() async{
  await _setUpServices();
  runApp(const MyApp());
}

Future<void> _setUpServices() async{
  GetIt.instance.registerSingleton<HttpService>(HttpService());
  GetIt.instance.registerSingleton<DatabaseService>(DatabaseService());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
          useMaterial3: true,
          textTheme: GoogleFonts.quattrocentoSansTextTheme(),
          brightness: Brightness.light
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

