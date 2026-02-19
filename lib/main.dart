import 'package:flutter/material.dart';
import 'package:lahorefortdesktop/providers/LoginProvider.dart';
import 'package:lahorefortdesktop/providers/TicketsProvider.dart';
import 'package:lahorefortdesktop/services/local_api_server.dart';
import 'package:lahorefortdesktop/ui/DashBoardScreen.dart';
import 'package:lahorefortdesktop/ui/TicketScreen.dart';
import 'package:lahorefortdesktop/ui/login_screen.dart';
import 'package:lahorefortdesktop/utils/SharedPrefHelper.dart';
import 'package:lahorefortdesktop/utils/navigation_service.dart';
import 'package:lahorefortdesktop/widgets/TimeValidationWrapper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'db_helper/DataBaseHelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool serverStarted = await LocalApiServer.startServer();

  await SharedPrefHelper.init();

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  await DatabaseHelper.instance.checkAndClearIfNeeded();
  runApp(
    serverStarted ? const MyApp() : const ServerErrorApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => LoginProvider()),
            Provider<DatabaseHelper>.value(value: DatabaseHelper.instance),
            ChangeNotifierProvider(
              create: (context) => TicketsProvider(
                databaseHelper: context.read<DatabaseHelper>(),
              ),
            ),
          ],
          child: MaterialApp(
            navigatorKey: rootNavigatorKey,
            title: 'Lahore Fort Desktop',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            initialRoute: '/login',
            routes: {
              '/login': (context) => LoginScreen(),
              '/dashboard': (context) => DashboardScreen(),
              '/home': (context) => ZooTicketScreen(),
            },
            builder: (context, widget) {
              return TimeValidationWrapper(child: widget!);
            },
          ),
        );
      },
    );
  }
}
class ServerErrorApp extends StatelessWidget {
  const ServerErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Colors.red.shade50,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber_rounded, size: 100, color: Colors.red.shade700),
                    const SizedBox(height: 32),
                    const Text(
                      'Server Failed to Start',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'This application requires your computer\'s network IP to be set to:\n\n'
                          '192.168.1.112\n\n'
                          'Please go to Network Settings → IPv4 → set it to static with the above IP.\n\n'
                          'Also make sure no other app is using port 8088.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      ),
                      onPressed: () {
                        // Restart the app to retry
                        main();
                      },
                      child: const Text(
                        'Retry',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}