import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quron_app/core/app/router/app_router.dart';
import 'package:quron_app/feautures/view_model/audio_provider.dart';
import 'package:quron_app/feautures/view_model/quron_provider.dart';
import 'package:quron_app/feautures/view_model/theme_provider.dart';
import 'package:quron_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => QuronProvider()),
          ChangeNotifierProvider(create: (_) => AudioProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: router,
              title: 'Quron App',
              theme: ThemeData(
                brightness: Brightness.light,
                fontFamily: 'Comfortaa',
                primarySwatch: Colors.blue,
                textTheme: Typography.englishLike2018.apply(
                  fontFamily: 'Comfortaa',
                  fontSizeFactor: 1.0,
                ),
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              ),
              darkTheme: ThemeData.dark().copyWith(
                textTheme: ThemeData.dark().textTheme.apply(
                  fontFamily: 'Comfortaa',
                  fontSizeFactor: 1.0,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
