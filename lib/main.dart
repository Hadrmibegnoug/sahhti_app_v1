import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/router/app_routes.dart';
//import 'passport_medical/presentation/screens/tabscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ymmdyaqjuallibixpeil.supabase.co',
    anonKey: 'sb_publishable_MMhux97CTu6TO5VQbVkdeg_CDAr6Xzw',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      //home: const Tabscreen(),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
