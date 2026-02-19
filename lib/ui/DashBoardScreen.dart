import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../data_models/login_datamodel/user_model.dart';
import '../db_helper/DataBaseHelper.dart';
import '../providers/TicketsProvider.dart';
import '../utils/SharedPrefHelper.dart';
import '../utils/ToastUtils.dart';
import '../utils/TimeValidationHelper.dart';
import 'TicketListingScreen.dart';
import 'TicketScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController pageController = PageController();
  SideMenuController sideMenuController = SideMenuController();

  bool _isHovering = false;
  bool isExpanded = false;
  User? user;

  Timer? _cleanupTimer;
  Timer? _timeValidationTimer;

  @override
  void initState() {
    super.initState();
    loadUser();

    // ✅ Check database every hour
    _cleanupTimer = Timer.periodic(Duration(hours: 1), (timer) async {
      await DatabaseHelper.instance.checkAndClearIfNeeded();
    });
    sideMenuController.addListener((index) {
      pageController.jumpToPage(index);
    });
  }

  @override
  void dispose() {
    _cleanupTimer?.cancel();
    _timeValidationTimer?.cancel();
    super.dispose();
  }

  // ✅ Show time validation error
  void _showTimeValidationError() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange, size: 30),
            SizedBox(width: 10),
            Text('Time Sync Lost'),
          ],
        ),
        content: Text(
          'System time is no longer synchronized.\n'
              'Please fix your system time to continue using the application.',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => exit(0),
            child: Text('Exit App', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> loadUser() async {
    User? loadedUser = SharedPrefHelper.getUser();
    if (loadedUser != null) {
      setState(() {
        user = loadedUser;
      });
      print("User loaded in provider: $user");
    }
  }
  void _showLogoutConfirmation(BuildContext context) async {
    final stats = await DatabaseHelper.instance.getDatabaseStats();
    final hoursUntilClear = stats['hours_until_clear'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Logout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to logout?'),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('📊 Database Info:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('• Total Records: ${stats['total_records']}'),
                  Text('• Uploaded: ${stats['uploaded_records']}'),
                  Text('• Database clears in: $hoursUntilClear hours'),
                  SizedBox(height: 8),
                  Text(
                    '✅ Your ticket data will remain accessible until 12 AM',
                    style: TextStyle(color: Colors.green.shade700, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              debugPrint('Logging out...');
              await SharedPrefHelper.removeUser();
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                    (_) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            child: Consumer<TicketsProvider>(
              builder: (context, provider, child) {
                return SideMenu(
                  onDisplayModeChanged: (mode) {
                    print(mode);
                  },
                  controller: sideMenuController,
                  collapseWidth: 24,
                  showToggle: true,
                  footer: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: MouseRegion(
                      onEnter: (_) => setState(() => _isHovering = true),
                      onExit: (_) => setState(() => _isHovering = false),
                      child: InkWell(
                        onTap: () async {
                          // ✅ UPDATED LOGOUT LOGIC
                          final pendingData = await provider.getPendingCounts();
                          print('pending data $pendingData');
                          if (pendingData > 0) {
                            ToastUtils.showErrorToast(
                              context,
                              'Please upload all pending entries first',
                            );
                          } else {
                            // ✅ Show confirmation with database info
                            _showLogoutConfirmation(context);
                          }
                        },
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: _isHovering ? Colors.grey[300] : Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.logout,
                                  color: _isHovering
                                      ? Colors.red
                                      : Colors.black),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Logout',
                                      style: TextStyle(
                                        color: _isHovering
                                            ? Colors.blue
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  style: SideMenuStyle(
                    displayMode: SideMenuDisplayMode.auto,
                    decoration: BoxDecoration(),
                    openSideMenuWidth: 65.w,
                    compactSideMenuWidth: 34.w,
                    hoverColor: Colors.blue[100],
                    selectedColor: Colors.lightBlue,
                    selectedIconColor: Colors.white,
                    unselectedIconColor: Colors.black54,
                    backgroundColor: Colors.white,
                    selectedTitleTextStyle: TextStyle(color: Colors.white),
                    unselectedTitleTextStyle: TextStyle(color: Colors.black54),
                    iconSize: 20,
                    itemBorderRadius: const BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                    showTooltip: true,
                    showHamburger: true,
                    itemHeight: 50.0,
                    itemInnerSpacing: 8.0,
                    itemOuterPadding: const EdgeInsets.symmetric(
                        horizontal: 5.0),
                    toggleColor: Colors.black54,
                    selectedTitleTextStyleExpandable:
                    TextStyle(color: Colors.white),
                    unselectedTitleTextStyleExpandable:
                    TextStyle(color: Colors.black54),
                    selectedIconColorExpandable: Colors.white,
                    unselectedIconColorExpandable: Colors.black54,
                    arrowCollapse: Colors.orangeAccent,
                    arrowOpen: Colors.white,
                    iconSizeExpandable: 24.0,
                  ),
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 20),
                      Icon(Icons.person, size: 50, color: Colors.blue),
                      SizedBox(height: 10),
                      Text(
                        user!.firstName + " " + user!.lastName,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Divider(indent: 10, endIndent: 10),

                    ],
                  ),
                  items: [
                    SideMenuItem(
                      title: 'Home',
                      icon: Icon(Icons.home_outlined),
                      onTap: (index, _) =>
                          sideMenuController.changePage(index),
                    ),
                    SideMenuItem(
                      title: 'Ticket Listing',
                      icon: Icon(Icons.list_alt_outlined),
                      onTap: (index, _) =>
                          sideMenuController.changePage(index),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              children: [
                ZooTicketScreen(),
                TicketListingScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}