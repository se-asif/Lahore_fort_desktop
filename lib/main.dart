import 'package:flutter/material.dart';
import 'package:lahorefortdesktop/providers/LoginProvider.dart';
import 'package:lahorefortdesktop/providers/TicketsProvider.dart';
import 'package:lahorefortdesktop/ui/DashBoardScreen.dart';
import 'package:lahorefortdesktop/ui/TicketScreen.dart';
import 'package:lahorefortdesktop/ui/login_screen.dart';
import 'package:lahorefortdesktop/utils/SharedPrefHelper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'db_helper/DataBaseHelper.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefHelper.init();
  sqfliteFfiInit();
   databaseFactory = databaseFactoryFfi;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()), // Register provider
        Provider<DatabaseHelper>.value(value: DatabaseHelper.instance), // Pass DB Helper
                ChangeNotifierProvider(create: (context) => TicketsProvider(
                  databaseHelper: context.read<DatabaseHelper>(), // Inject DB Helper
                )),

      ],
      child:  MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  @override
   Widget build(BuildContext context) {
     return ScreenUtilInit(
       builder: (context, child) {
         return MaterialApp(
           title: 'Flutter Demo',
           theme: ThemeData(
             colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
             useMaterial3: true,
           ),
           debugShowCheckedModeBanner: false,
           initialRoute: '/login',
           routes: {
             '/login': (context) => LoginScreen(),
             '/dashboard': (context) => DashboardScreen(),
             '/home': (context) => ZooTicketScreen(),
           },
         );
       },
     );
   }
 }