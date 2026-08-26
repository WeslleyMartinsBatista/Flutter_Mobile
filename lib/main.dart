import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile_flutter/view/loginView.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('pt_BR', null);

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
