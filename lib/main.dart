import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile_flutter/view/loginView.dart';

import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('pt_BR', null);

  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    throw Exception(
      'Configure SUPABASE_URL e SUPABASE_ANON_KEY antes de executar o aplicativo.',
    );
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

  runApp(
    FinancialApp(
      themeNotifier: themeNotifier,
    ),
  );
}

class FinancialApp extends StatelessWidget {
  final ValueNotifier<ThemeMode> themeNotifier;

  const FinancialApp({
    super.key,
    required this.themeNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Aplicativo Financeiro',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          home: LoginView(
            themeNotifier: themeNotifier,
          ),
        );
      },
    );
  }
}
