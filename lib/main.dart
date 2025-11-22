import 'package:flutter/material.dart';
import 'package:flutter_hn_clone/db/database.dart';
import 'package:flutter_hn_clone/screens/home.dart';
import 'package:flutter_hn_clone/states/tab_bar_notifier.dart';
import 'package:flutter_hn_clone/utils/theme.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>(
          create: (_) => AppDatabase(),
          dispose: (context, db) => db.close(),
        ),
        ChangeNotifierProvider<TabBarNotifier>(create: (_) => TabBarNotifier()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
