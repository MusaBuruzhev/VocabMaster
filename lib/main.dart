import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'state/auth_manager.dart';
import 'state/theme_manager.dart';
import 'state/vocab_manager.dart';
import 'ui/login_view.dart';
import 'ui/vocab_list_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const VocabMasterApp());
}

class VocabMasterApp extends StatelessWidget {
  const VocabMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthManager()),
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        ChangeNotifierProvider(create: (_) => VocabManager()),
      ],
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, _) {
          return MaterialApp(
            title: 'VocabMaster',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.teal,
                brightness: Brightness.light,
                primary: Colors.teal[700],
                secondary: Colors.amber[600],
                surface: Colors.white,
              ),
              textTheme: const TextTheme(
                headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                bodyLarge: TextStyle(fontSize: 16),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              cardTheme: CardTheme(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.teal,
                brightness: Brightness.dark,
                primary: Colors.teal[300],
                secondary: Colors.amber[400],
                surface: Colors.grey[900],
              ),
              textTheme: const TextTheme(
                headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                bodyLarge: TextStyle(fontSize: 16),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              cardTheme: CardTheme(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
            themeMode: themeManager.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: Consumer<AuthManager>(
              builder: (context, authManager, _) {
                return authManager.isAuthenticated
                    ? const VocabListView()
                    : const LoginView();
              },
            ),
          );
        },
      ),
    );
  }
}