import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../data_models/login_datamodel/user_model.dart';
import '../db_helper/DataBaseHelper.dart';
import '../providers/TicketsProvider.dart';
import '../utils/SharedPrefHelper.dart';
import '../utils/ToastUtils.dart';
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
  late User user;

  @override
  void initState() {
    super.initState();
    loadUser(); // Load user data asynchronously
    sideMenuController.addListener((index) {
      pageController.jumpToPage(index);
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            // Increase width for better layout
        child : Consumer<TicketsProvider>(
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
                       // Adjust bottom padding
                       child: MouseRegion(
                         onEnter: (_) => setState(() => _isHovering = true),
                         onExit: (_) => setState(() => _isHovering = false),
                         child: InkWell(
                           onTap: () async {
                             final pendingData = await provider
                                 .getPendingCounts();
                             print('pending data $pendingData');
                             if (pendingData > 0) {
                               ToastUtils.showErrorToast(
                                 context,
                                 'Please upload all pending entries first',
                               );
                             } else {
                               print('Logging out...');
                               await SharedPrefHelper.clearAll();
                               await DatabaseHelper.instance.resetDatabase();
                               Navigator.pushNamed(context, '/login');
                             }
                             // print("Logging out...");

                           },
                           borderRadius: BorderRadius.circular(5),
                           child: Container(
                             padding: const EdgeInsets.symmetric(
                                 vertical: 10, horizontal: 10),
                             decoration: BoxDecoration(
                               color: _isHovering ? Colors.grey[300] : Colors
                                   .white,
                               // Hover effect
                               borderRadius: BorderRadius.circular(5),
                             ),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Icon(Icons.logout,
                                     color: _isHovering
                                         ? Colors.red
                                         : Colors.black),
                                 // Change icon color on hover

                                 Padding(
                                   padding: const EdgeInsets.only(left: 8),
                                   child: Text(
                                     'Logout',
                                     style: TextStyle(
                                       color: _isHovering
                                           ? Colors.blue
                                           : Colors
                                           .black, // Change text color on hover
                                     ),
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
                       unselectedTitleTextStyle: TextStyle(
                           color: Colors.black54),
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

                       // Additional properties for expandable items
                       selectedTitleTextStyleExpandable:
                       TextStyle(color: Colors.white),
                       // Adjust the style as needed
                       unselectedTitleTextStyleExpandable:
                       TextStyle(color: Colors.black54),
                       // Adjust the style as needed
                       selectedIconColorExpandable: Colors.white,
                       // Adjust the color as needed
                       unselectedIconColorExpandable: Colors.black54,
                       // Adjust the color as needed
                       arrowCollapse: Colors.orangeAccent,
                       // Adjust the color as needed
                       arrowOpen: Colors.white,
                       // Adjust the color as needed
                       iconSizeExpandable: 24.0, // Adjust the size as needed
                     ),
                     title: Column(
                       mainAxisSize: MainAxisSize.min, // Fix layout issue
                       children: [
                         SizedBox(height: 20),
                         Icon(Icons.person, size: 50, color: Colors.blue),
                         SizedBox(height: 10),
                         Text(
                           user.firstName + " " + user.lastName,
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
                 })
          ),

          /// **Expanded for Page View**
          Expanded(
            child: PageView(
              controller: pageController,
              children: [
                ZooTicketScreen(), // ✅ Home Screen
                TicketListingScreen(), // ✅ Ticket Listing Screen
              ],
            ),
          ),
        ],
      ),
    );
  }
}
