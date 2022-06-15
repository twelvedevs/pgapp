import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pgapp/core/theme/theme.dart';
import 'package:pgapp/presentation/pages/home.dart';
import 'package:pgapp/presentation/pages/privacy.dart';
import 'package:pgapp/presentation/providers/password_provider.dart';
import 'package:pgapp/presentation/providers/theme_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Themes? theme = await ThemeProvider.getTheme();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp(theme: theme)));
  runApp(MyApp(theme: theme));
}

class MyApp extends StatelessWidget {
  final Themes? theme;

  const MyApp({Key? key, required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => ThemeProvider(theme: theme)),
          ChangeNotifierProvider(create: (context) => PasswordProvider()),
        ],
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          return MaterialApp(
            title: 'PGApp',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            initialRoute: '/',
            routes: {
              '/': (context) => const Home(),
              '/privacy': (context) => const Privacy(),
            },
            // home: const Home(),
          );
        });
  }
}
