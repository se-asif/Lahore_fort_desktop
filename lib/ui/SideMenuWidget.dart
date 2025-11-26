import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';


import '../db_helper/DataBaseHelper.dart';
import '../providers/TicketsProvider.dart';
import '../utils/SharedPrefHelper.dart';
import '../utils/ToastUtils.dart';
import 'TicketListingScreen.dart';
import 'TicketScreen.dart';

class MySideMenu extends StatefulWidget {
  @override
  _MySideMenuState createState() => _MySideMenuState();
}

class _MySideMenuState extends State<MySideMenu> {
  final SideMenuController _controller = SideMenuController();
  int _currentIndex = 0;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TicketsProvider>().fetchVisitCount();

    });
  }



  @override
  Widget build(BuildContext context) {
    return Consumer<TicketsProvider>(
          builder: (context, provider, child)
    {
      return SideMenu(
        controller: _controller,
        backgroundColor: Colors.white,
        mode: SideMenuMode.compact,
        builder: (data) {
          print("visit vount from side menu ${provider.visitCount}");
          return SideMenuData(

            defaultTileData: SideMenuItemTileDefaults(
              hoverColor: Colors.black,

            ),
            animItems: SideMenuItemsAnimationData(),
            items: [

              /// First item with badge
              SideMenuItemDataTile(
                isSelected: _currentIndex == 0,
                onTap: () {
                                  setState(() => _currentIndex = 0);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ZooTicketScreen()),
                                  );
                                },
                title: 'Dashboard',
                titleStyle: TextStyle(
                  color: _currentIndex == 0 ? Colors.white : Colors.black,
                ),
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                hoverColor: Colors.blue,
                decoration: BoxDecoration(
                  gradient: _currentIndex == 0
                      ? const LinearGradient(
                    colors: [Color(0xffF9BA13), Color(0xffF9BA13)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                      : null,
                  color: _currentIndex == 0 ? null : Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                margin: EdgeInsetsDirectional.only(top: 24),

              ),

              SideMenuItemDataTile(
                isSelected: _currentIndex == 1,
                onTap: () {
                  setState(() => _currentIndex = 1);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TicketListingScreen()),
                  );
                },

                title: 'Ticket Listing',
                titleStyle: TextStyle(
                  color: _currentIndex == 1 ? Colors.white : Colors.black,
                ),
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                hoverColor: Colors.blue,
                decoration: BoxDecoration(
                  gradient: _currentIndex == 1
                      ? const LinearGradient(
                    colors: [Color(0xffF9BA13), Color(0xffF9BA13)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                      : null,
                  color: _currentIndex == 1 ? null : Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                badgeBuilder: (tile) {
                  return Stack(
                    children: [
                      tile,
                      if (provider.visitCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              provider.visitCount.toString(),
                              style: TextStyle(fontSize: 8, color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  );
                },


              ),
            ],

            // Adding the logout button at the bottom
            footer: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              // Adjust bottom padding
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovering = true),
                onExit: (_) => setState(() => _isHovering = false),
                child: InkWell(
                  onTap: () async {
                    //if (await HelperFunction.hasInternetConnection()) {
                    final pendingData = await provider.getPendingCounts();
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
                      if (context.mounted) {
                        Navigator.pushNamed(context, '/login');
                      }
                    }
                    //  }
                  },
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: _isHovering ? Colors.grey[300] : Colors.white,
                      // Hover effect
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.logout, color: _isHovering
                            ? Colors.red
                            : Colors.black), // Change icon color on hover
                        if (data.isOpen)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              'Logout',
                              style: TextStyle(
                                color: _isHovering ? Colors.blue : Colors
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


          );
        },
      );
    }
    );
  }
}

