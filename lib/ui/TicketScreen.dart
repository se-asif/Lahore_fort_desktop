import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../data_models/get_categories/ticket_category_model.dart';
import '../providers/TicketsProvider.dart';
import '../utils/Constants.dart';
import '../utils/HelperFunctions.dart';
import '../utils/SharedPrefHelper.dart';
import '../utils/ToastUtils.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:badges/badges.dart' as badges;

import 'ParkingReceiptDialog.dart';
import 'SideMenuWidget.dart';

class ZooTicketScreen extends StatefulWidget {
  @override
  _ZooTicketScreenState createState() => _ZooTicketScreenState();
}



class _ZooTicketScreenState extends State<ZooTicketScreen> {

  int _currentIndex = 0;
  PageController pageController = PageController();
  SideMenuController sideMenuController = SideMenuController();
  // @override
  // void initState() {
  //   super.initState();
  //
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //        Provider.of<TicketsProvider>(context, listen: false).getCategories(context);
  //
  //      });
  // }
  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((_) async {


      final ticketsProvider = Provider.of<TicketsProvider>(context, listen: false);

      await SharedPrefHelper.getUser();
      if (await HelperFunction.hasInternetConnection()) {
        ticketsProvider.getCategories(context);
      } else {
        List<TicketCategory> cachedCategories = await SharedPrefHelper.getCategoriesList();
        if (cachedCategories.isNotEmpty) {
          ticketsProvider.setCategoriesFromCache(cachedCategories);
        } else {
          ToastUtils.showErrorToast(context, "No internet and no cached data available.");
        }
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/lhore_fort.png',
              fit: BoxFit.cover,
            ),
          ),



          Positioned(
            top: 6,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Color(0xFFFFA726), Color(0xFFFFD700)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomRight,
                  ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                  child: Text(
                    Constants.lahoreZoo,
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'MyFont',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 60.h),
              child: Center(
                child: Container(
                  width: 250.w,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          tableHeader("TYPE"),
                          tableHeader("PRICE"),
                          tableHeader("PERSONS"),
                          tableHeader("AMOUNT"),
                        ],
                      ),
                      const Divider(),
                      Consumer<TicketsProvider>(
                        builder: (context, ticketsProvider, child) {
                          if (ticketsProvider.isLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (ticketsProvider.ticketCategoriesResponse == null ||
                              ticketsProvider.ticketCategoriesResponse!.catagories.isEmpty) {
                            return const Center(child: Text("No data available"));
                          }

                          final tickets = ticketsProvider.ticketCategoriesResponse!.catagories;

                          return Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: tickets.length,
                              itemBuilder: (context, index) {
                                return ticketRow(tickets[index], ticketsProvider);
                              },
                            ),
                          );
                        },
                      ),
                      const Divider(),
                      Consumer<TicketsProvider>(
                          builder: (context, ticketsProvider, child) {
                            return totalSection(ticketsProvider);
                          }),
                      SizedBox(height: 8.h),
                      Consumer<TicketsProvider>(
                        builder: (context, provider, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: paymentButton(
                                      "Reset", Colors.red, () {
                                    print("clear all called");
                                    provider.clearAllData();
                                    //
                                  })),
                              SizedBox(width: 10),
                              Expanded(
                                  flex: 2,
                                  child: paymentButton("Cash", Colors.green, () async {
                                    bool success = await provider.dataAddToDB(context);
                                    if (success && provider.visitingSummaryDataList != null &&
                                        provider.visitingSummaryDataList!.isNotEmpty) {
                                      await ParkingReceiptDialog.show(context, provider.visitingSummaryDataList);
                                      provider.clearState();
                                    } else if (!success) {
                                      ToastUtils.showErrorToast(context, "Please select at least one ticket");
                                    } else {
                                      ToastUtils.showErrorToast(context, "No tickets to print");
                                    }
                                  })),
                              Expanded(
                                  flex: 1,
                                  child:
                                  paymentButton("Print Bill", Colors.blueAccent, () {
                                    provider.printSummaryList(context);

                                  })),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: const EdgeInsets.only(left: 30,right: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("IP: 192.168.1.112"),
                            Text("VERSION : 1.0.8")
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          //MySideMenu()
        ],
      ),
    );
  }
  Widget tableHeader(String text) {
    return Expanded(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
  Widget ticketRow(TicketCategory category, TicketsProvider provider) {
    int personCount = provider.categoryPersons[category.id] ?? 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(category.name, style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
        Expanded(child: Text(category.routineCharges.toString(), style: TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  provider.decreasePersonCount(category.id);
                },
                icon: Icon(Icons.remove_circle, size: 32, color: Colors.red),
              ),

              SizedBox(width: 1.w,),
              Container(
                width: 18.w,
                height: 34.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.w),
                  color: Color(0xffF9BA13),
                ),
                child: FittedBox(
                  child: Text(
                    personCount.toString(),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),



              SizedBox(width: 1.w,),
              // Increase Button
              IconButton(
                onPressed: () {
                  provider.increasePersonCount(category.id);
                },
                icon: Icon(Icons.add_circle, size: 32, color: Colors.green),
              ),
            ],
          ),
        ),
        Expanded(
          child: Text(
            "Rs. ${personCount * category.routineCharges!}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
                fontSize: 20
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
  Widget totalSection(TicketsProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Color(0xffF5F5DC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF9A651D),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Text("Total:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Spacer(flex: 5,),

            Text("${provider.totalPersons}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Spacer(flex: 2,),
            Text(
              "Rs.${provider.totalCost}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            SizedBox(width: 16.w,)
          ],
        ),
      ),
    );
  }
  Widget paymentButton(String text, Color color, VoidCallback onPress) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: ElevatedButton(
          onPressed: onPress,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}