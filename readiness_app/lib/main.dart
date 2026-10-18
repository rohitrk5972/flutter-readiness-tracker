import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'providers/progress_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final auth = AuthService();
  await auth.init();
  runApp(MyApp(auth: auth));
}

class MyApp extends StatelessWidget {
  final AuthService auth;
  const MyApp({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: auth),
        ChangeNotifierProxyProvider<AuthService, ProgressProvider>(
          create: (_) => ProgressProvider(),
          update: (_, a, p) => (p ?? ProgressProvider())..bindUser(a.currentUser),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Readiness Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF0B5394),
        ),
        home: Consumer<AuthService>(
          builder: (_, a, __) =>
              a.currentUser == null ? const LoginScreen() : const HomeScreen(),
        ),
      ),
    );
  }
}
