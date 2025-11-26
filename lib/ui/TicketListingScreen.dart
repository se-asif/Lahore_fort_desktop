import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:provider/provider.dart';

import '../data_models/visiting_data_list/visiting_data_list.dart';
import '../db_helper/DataBaseHelper.dart';
import '../providers/TicketsProvider.dart';
import '../utils/HelperFunctions.dart';
import '../utils/ToastUtils.dart';
import 'SideMenuWidget.dart';

class TicketListingScreen extends StatefulWidget {
  const TicketListingScreen({super.key});

  @override
  State<TicketListingScreen> createState() => _TicketListingScreenState();
}

class _TicketListingScreenState extends State<TicketListingScreen> {

  DateTime? fromDate;
    DateTime? toDate;
    List<VisitingDataList> filteredVisitingData = [];
  bool showPending = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    fromDate = DateTime(today.year, today.month, today.day);
    toDate = DateTime(today.year, today.month, today.day);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {

    setState(() => isLoading = true);
    try {
      final allData = await _fetchVisitData();
      setState(() => filteredVisitingData = allData);
    } finally {
      setState(() => isLoading = false);
    }
    await _applyFilter();
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  Future<List<VisitingDataList>> _fetchVisitData({DateTime? from, DateTime? to}) async {
    List<VisitingDataList> allData = await DatabaseHelper.instance.getVisitingData();

    // Sort by date in descending order (newest first)
    allData.sort((a, b) => DateTime.parse(b.date!).compareTo(DateTime.parse(a.date!)));

    if (from != null && to != null) {
      return allData.where((ticket) {
        try {
          final ticketDate = DateTime.parse(ticket.date!).toLocal();
          final ticketOnlyDate = DateTime(ticketDate.year, ticketDate.month, ticketDate.day);
          final fromOnlyDate = DateTime(from.year, from.month, from.day);
          final toOnlyDate = DateTime(to.year, to.month, to.day);

          return (ticketOnlyDate.isAtSameMomentAs(fromOnlyDate) ||
                 (ticketOnlyDate.isAtSameMomentAs(toOnlyDate)) ||
                 (ticketOnlyDate.isAfter(fromOnlyDate) && ticketOnlyDate.isBefore(toOnlyDate)));
        } catch (e) {
          print("Error parsing date for ticket: ${ticket.date}");
          return false;
        }
      }).toList();
    }

    return allData;
  }

  Future<List<VisitingDataList>> _fetchPendingVisitData({DateTime? from, DateTime? to}) async {
    List<VisitingDataList> allData = await DatabaseHelper.instance.getVisitingData();

    // Sort by date in descending order (newest first)
    allData.sort((a, b) => DateTime.parse(b.date!).compareTo(DateTime.parse(a.date!)));

    return allData.where((ticket) => ticket.isUploaded == 0).toList();
  }

  Future<void> _applyFilter() async {
    setState(() => isLoading = true);
    try {
      // 1) grab everything
      final allData = await DatabaseHelper.instance.getVisitingData();

      // 2) if “pending only” mode, drop uploaded ones
      var result = showPending
          ? allData.where((t) => t.isUploaded == 0).toList()
          : allData;

      // 3) if either fromDate or toDate is set, filter by those bounds
      if (fromDate != null || toDate != null) {
        // normalize compare to date-only
        result = result.where((t) {
          final dt = DateTime.parse(t.date!).toLocal();
          final only = DateTime(dt.year, dt.month, dt.day);

          if (fromDate != null) {
            final f = DateTime(fromDate!.year, fromDate!.month, fromDate!.day);
            if (only.isBefore(f)) return false;
          }
          if (toDate != null) {
            final t = DateTime(toDate!.year, toDate!.month, toDate!.day);
            if (only.isAfter(t)) return false;
          }
          return true;
        }).toList();
      }

      // 4) sort newest-first
      result.sort((a, b) => DateTime.parse(b.date!).compareTo(DateTime.parse(a.date!)));

      // 5) update UI
      setState(() => filteredVisitingData = result);
    } finally {
      setState(() => isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {

    final ticketsProvider = Provider.of<TicketsProvider>(context, listen: false);
print("whole widget calledd");
    return Scaffold(
        backgroundColor: Color(0xffE5E5E5),
        body: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Tickting Report',
                  style: TextStyle(
                      fontSize: 8.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Filter by ",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const Text(
                      "dates",
                      style: TextStyle(color: Colors.purple, fontSize: 16),
                    ),
                    const SizedBox(width: 10),
                    _buildDateField(context, "From", fromDate, true),
                    const SizedBox(width: 10),
                    _buildDateField(context, "To", toDate, false),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        _applyFilter();
                      },
                      icon: const Icon(Icons.search, color: Colors.white),
                      label: const Text(
                        "Search",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Show Pending Only"),
                              Switch(
                                value: showPending,
                                onChanged: (value) {
                                  setState(() {
                                    showPending = value;
                                  });
                                  _applyFilter();
                                },
                              ),
                            ],
                          ),
              ],
            ),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Padding(
                padding:  EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildHeaderCell("User Name"),
                    SizedBox(width: 12.sp,),
                    _buildHeaderCell("Total Amount"),
                    SizedBox(width: 10.sp,),
                    _buildHeaderCell("Total Persons"),
                    SizedBox(width: 10.sp,),
                    _buildHeaderCell("Gate Name"),
                    SizedBox(width: 7.sp,),
                    _buildHeaderCell("Date"),
                    //_buildHeaderCell("Lot ID"),
                    _buildHeaderCell("Txn ID"),
                   SizedBox(width: 16.sp,),
                   // _buildHeaderCell("User ID"),
                    _buildHeaderCell("Status"),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<VisitingDataList>>(
                future: Future.value(filteredVisitingData),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No data found"));
                    }

                    final visitingData = snapshot.data!;

                        return ListView.builder(
                         // padding: const EdgeInsets.all(8.0),
                          itemCount: visitingData.length,
                          itemBuilder: (context, index) {
                            final ticket = visitingData[index];

                            return Card(
                                                elevation: 2,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                //margin: const EdgeInsets.symmetric(vertical: 8),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                      _buildValueCell(ticket.userName ?? ""),
                                                                 _buildValueCell(ticket.totalAmount ?? ""),
                                                                 _buildValueCell(ticket.totalPersons ?? ""),
                                                                 _buildValueCell(ticket.gateName ?? ""),
                                                                 _buildValueCell(ticket.date ?? ""),
                                                                // _buildValueCell(ticket.parkingLotId ?? ""),

                                                                 _buildValueCell(ticket.transactionUniqueId ?? ""),
                                                                // _buildValueCell(ticket.userId ?? ""),
                                                          SizedBox(width: 16.sp,),

                                                          Divider(),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Consumer<TicketsProvider>(
                                                                    builder: (context, provider, child) {
                                                                      return _buildStatusChip(ticket.isUploaded.toString());
                                                                    },
                                                                  ),
                                                                  const SizedBox(height: 8),

                                                                  //const SizedBox(width: 8),

                                                                  Consumer<TicketsProvider>(
                                                                    builder: (context, provider, child) {
                                                                      if (ticket.isUploaded.toString() == "0") {
                                                                        return ElevatedButton(
                                                                          onPressed: () async {
                                                                            if(await HelperFunction.hasInternetConnection()){
                                                                              provider.postVisitingDataFromDB(ticket);

                                                                              await Future.delayed(const Duration(seconds: 2));
                                                                              _applyFilter();
                                                                            } else {
                                                                              ToastUtils.showErrorToast(context, "Please Connect to internet !");
                                                                            }
                                                                             // Call a method to handle upload
                                                                          },
                                                                          style: ElevatedButton.styleFrom(
                                                                            backgroundColor: Colors.purple,
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                            ),
                                                                          ),
                                                                          child: const Text("Upload", style: TextStyle(color: Colors.white)),
                                                                        );
                                                                      } else {
                                                                        return const SizedBox(); // Hide button if uploaded
                                                                      }
                                                                    },
                                                                  ),

                                                                ],
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                              );

                          },
                        );
                      },
                    ),
            )
          ],
        )
    );

  }

  Widget _buildDateField(BuildContext context, String label, DateTime? date, bool isFromDate) {
      return GestureDetector(
        onTap: () => _selectDate(context, isFromDate),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Text(
                date == null ? label : "${date.day}/${date.month}/${date.year}",
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.calendar_today, color: Colors.grey),
            ],
          ),
        ),
      );
    }
  }

Widget _buildHeaderCell(String text) {
  return Expanded(
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget _buildValueCell(String text) {
  return Expanded(
    child: Text(
      text,
      textAlign: TextAlign.center,
    ),
  );
}

Widget _buildStatusChip(String status) {
  bool isDone = status == "1"; // Check if status is "1"

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: isDone ? Colors.green.shade200 : Colors.red.shade200,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isDone ? Icons.check_circle : Icons.error,
          color: isDone ? Colors.green : Colors.red,
          size: 18,
        ),
        const SizedBox(width: 4),
        Text(
          isDone ? "Done" : "Pending", // Show "Done" or "Pending"
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDone ? Colors.green : Colors.red,
          ),
        ),
      ],
    ),
  );
}


