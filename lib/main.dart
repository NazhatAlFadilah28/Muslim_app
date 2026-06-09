import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';

import 'repository/al-quraan_repository.dart';
import 'repository/gemini_ai_repository.dart';
import 'repository/hijri_calendar_repository.dart';
import 'viewmodel/shalat_view_model.dart';
import 'viewmodel/al-quraan_view_model.dart';
import 'viewmodel/hijri_calendar_view_model.dart';
import 'viewmodel/doa_view_model.dart';
import 'viewmodel/asmaul_husna_view_model.dart';
import 'viewmodel/location_view_model.dart';
import 'viewmodel/ramadan_tracker_view_model.dart';
import 'view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase initialization - commented out for demo mode
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AlQuranRepository>(create: (_) => AlQuranRepository()),
        Provider<GeminiAIRepository>(create: (_) => GeminiAIRepository()),
        Provider<HijriCalendarRepository>(
          create: (_) => HijriCalendarRepository(),
        ),
        ChangeNotifierProvider<ShalatViewModel>(
          create: (context) => ShalatViewModel(),
        ),
        ChangeNotifierProvider<AlQuranViewModel>(
          create: (context) => AlQuranViewModel(
            context.read<AlQuranRepository>(),
            context.read<GeminiAIRepository>(),
          ),
        ),
        ChangeNotifierProvider<HijriCalendarViewModel>(
          create: (context) =>
              HijriCalendarViewModel(context.read<HijriCalendarRepository>()),
        ),
        ChangeNotifierProvider<DoaViewModel>(
          create: (context) => DoaViewModel(),
        ),
        ChangeNotifierProvider<AsmaulHusnaViewModel>(
          create: (context) => AsmaulHusnaViewModel(),
        ),
        ChangeNotifierProvider<LocationViewModel>(
          create: (context) => LocationViewModel(),
        ),
        ChangeNotifierProvider<RamadanTrackerViewModel>(
          create: (context) => RamadanTrackerViewModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Muslim App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1B7D6F),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFE8F5E9),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
