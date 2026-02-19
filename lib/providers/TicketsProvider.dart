import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../data_models/get_categories/ticket_category_model.dart';
import '../data_models/login_datamodel/user_model.dart';
import '../data_models/post_response/post_response_model.dart';
import '../data_models/visiting_data_list/visiting_data_list.dart';
import '../db_helper/DataBaseHelper.dart';
import '../dio_service/dio_service.dart';
import '../ui/SummaryDialog.dart';
import '../utils/Constants.dart';
import '../utils/HelperFunctions.dart';
import '../utils/SharedPrefHelper.dart';
import '../utils/ToastUtils.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
class TicketsProvider with ChangeNotifier {
  final DioService _dioService = DioService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  TicketCategoriesResponse? _ticketCategoriesResponse;
  TicketCategoriesResponse? get ticketCategoriesResponse  => _ticketCategoriesResponse;
  final Map<int, int> _categoryPersons = {};
  final Map<int, List<int>> _categoryTimestamps = {};



  DatabaseHelper? databaseHelper;
  User? _user;
  User? get user => _user;

  int _visitCount = 0;
  int get visitCount => _visitCount;


  Future<int> getPendingCounts() async {
    final pending = await _fetchPendingVisitData();
    return pending.length;
  }


  String windowsId = '';
  List<VisitingDataList>?  _visitingDataList;
  List<VisitingDataList>? get visitingDataList => _visitingDataList;

  List<VisitingDataList>?  _visitingSummaryDataList;
  List<VisitingDataList>? get visitingSummaryDataList => _visitingSummaryDataList;

  TicketsProvider({required DatabaseHelper databaseHelper}) : databaseHelper = databaseHelper {
    loadUser();
    databaseHelper.getVisitingData();
    databaseHelper.getVisitingData().then((data) {
      print("Database Data: $data");
    });
    startBackgroundTask();
    applyFilter();
    databaseHelper.visitCountNotifier.addListener(() {
      _visitCount = databaseHelper.visitCountNotifier.value;
      notifyListeners();
    });


  }

  Future<void> fetchVisitCount() async {
    final data = await DatabaseHelper.instance.getPendingData();
    print("visit count in provider ${data.length}");
    _visitCount = data.length;
    notifyListeners();
  }

  Future<void> loadUser() async {
    _user = SharedPrefHelper.getUser();
    print("User loaded in provider: $_user");
    print("User ID: ${_user?.userId}");
    print("User Name: ${_user?.firstName} ${_user?.lastName}");
    print("Parking Lot: ${_user?.parkingLotName}");

    if (_user != null) {
      notifyListeners();
    } else {
      print("⚠️ No user found in SharedPreferences");
    }
    //databaseHelper?.resetDatabase();
    var macId = (await getWindowsId())!;
    windowsId =macId!.replaceAll('{', '').replaceAll('}', '');
    print("Windows id $windowsId");
  }

  Map<int, int> get categoryPersons => _categoryPersons;
  int get totalPersons => _categoryPersons.values.fold(0, (sum, count) => sum + count);
  void setCategoriesFromCache(List<TicketCategory> cachedCategories) {
    fetchVisitCount();
    _ticketCategoriesResponse = TicketCategoriesResponse(catagories: cachedCategories);
    notifyListeners();
  }
  double get totalCost {
    if (_ticketCategoriesResponse == null) return 0.0;
    return _ticketCategoriesResponse!.catagories.fold(0, (sum, category) {
      int count = _categoryPersons[category.id] ?? 0;
      return sum + (count * category.routineCharges!);
    });
  }
  List<Map<String, dynamic>> get selectedCategoryDetailsList {
    if (_ticketCategoriesResponse == null) return [];

    return _categoryPersons.entries
        .where((entry) => entry.value > 0)
        .map((entry) {
      final category = _ticketCategoriesResponse!.catagories.firstWhere(
            (cat) => cat.id == entry.key,
      );
      return {
        "categoryId": category.id,
        "categoryName": category.name, // Assuming 'name' field exists
        "routineCharges": category.routineCharges ?? 0.0,
        "totalPersons": entry.value,
        "timestamp": _categoryTimestamps[category.id] ?? 0, // Include timestamp
        // "visitorTypeId" : category.visitorTypeId,
        // "parkingLotsId" : category.parkingLotsId,
        "categoryCharges" : entry.value * category.routineCharges!
      };
    })
        .toList();
  }


  List<Map<String, dynamic>> get typeWiseDataMap {
    if (_ticketCategoriesResponse == null) return [];

    return _categoryPersons.entries
        .where((entry) => entry.value > 0) // Only include categories with persons
        .map((entry) {
      final category = _ticketCategoriesResponse!.catagories.firstWhere(
            (cat) => cat.id == entry.key,
      );

      final String fareId = category.visitorTypeId.toString();
      final int count = entry.value;
      final String serviceName = category.name.toString();
      final int routineCharges = category.routineCharges ?? 0;
      final int amount = count * routineCharges;
      final Object transactionUniqueIds = _categoryTimestamps[category.id] ?? [];

      return {
        "serviceName" : serviceName,
        "visitorTypeId": fareId,
        "categoryId": category.id,
        "count": count,
        "amount": amount,
        "routine_charges": routineCharges,
        "transection_unique_ids": transactionUniqueIds
      };
    })
        .toList();
  }


  void clearAllData() {
    _categoryPersons.clear();
    _categoryTimestamps.clear();
    notifyListeners();
  }
  void printSummaryList(BuildContext context){
    SummaryDialog.showBillDialog(context, visitingSummaryDataList!);
  }


  Future<void> addTicketsDataToList() async {
    await loadUser();

    var uId = DateTime.now().millisecondsSinceEpoch.toString();
    _visitingDataList = [
      VisitingDataList(
          typeWiseData: typeWiseDataMap,
          paymentId: "1",
          totalPersons: totalPersons.toString(),
          totalAmount: totalCost.toString(),
          gateId: user?.gatesId.toString(),
          parkingLotId: user?.parkingLotsId.toString(),
          userId: user?.userId.toString(),
          date: getTimeDate(),
          userName: "${user?.firstName} ${user?.lastName}",
          gateName: user?.name,
          ticketingPoint: user?.name,
          transactionUniqueId: uId,
          userMacId: windowsId,
          isUploaded: 0,
          billNo: uId
      ),
    ];

    print('user id ${user?.userId.toString()}');
    print('user name ${user?.firstName} ${user?.lastName}');
    print(visitingDataList);

  }
  void updateIsUploaded(int newValue) {
    _visitingDataList = _visitingDataList
        ?.map((data) => data.copyWith(isUploaded: newValue))
        .toList();
    print(_visitingDataList);
  }

  Future<void> dataAddToDB(BuildContext context) async {
    //await databaseHelper?.resetDatabase();
   await addTicketsDataToList();
    if (categoryPersons.isNotEmpty) {

      if (visitingDataList != null && visitingDataList!.isNotEmpty && await HelperFunction.hasInternetConnection()) {
        updateIsUploaded(1);
        _visitingSummaryDataList = visitingDataList;
        print('summary list is $visitingSummaryDataList');
        for (var data in visitingDataList!) {
          postVisitingData(context, data);
          await databaseHelper?.insertVisitingData(data);
        }

        clearAllData();
      } else {
        updateIsUploaded(0);
        for (var data in visitingDataList!) {
          await databaseHelper
              ?.insertVisitingData(data); // Pass object directly
        }
        print("Data saved successfully in SQLite!");
        clearAllData();
      }
    } else {
      clearAllData();
      print("No data available to save.");
      //ToastUtils.showErrorToast(context, "Please select any Service");
    }
  }

  // Increase person count
  void increasePersonCount(int categoryId) {

    _categoryPersons[categoryId] = (_categoryPersons[categoryId] ?? 0) + 1;
    // Add timestamp to list
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _categoryTimestamps.putIfAbsent(categoryId, () => []).add(timestamp);
    print(categoryPersons);
    print(totalCost);
    print(totalPersons);
    print (selectedCategoryDetailsList);
    // print (_categoryTimestamps);
    notifyListeners();
    //addTicketsDataToList();
  }

  // Decrease person count
  void decreasePersonCount(int categoryId) {
    if (_categoryPersons.containsKey(categoryId) && _categoryPersons[categoryId]! > 0) {
      _categoryPersons[categoryId] = _categoryPersons[categoryId]! - 1;

      if (_categoryTimestamps.containsKey(categoryId) && _categoryTimestamps[categoryId]!.isNotEmpty) {
        _categoryTimestamps[categoryId]!.removeLast();
      }

      if (_categoryPersons[categoryId] == 0) {
        _categoryTimestamps.remove(categoryId);
      }
    }

    notifyListeners();
  }


  String getTimeDate(){
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    print(formattedDate); // Example: 2024-03-01 14:30:00
    return formattedDate;
  }

  Future<String?> getWindowsId() async {
    final deviceInfo = DeviceInfoPlugin();
    final windowsInfo = await deviceInfo.windowsInfo;
    return windowsInfo.deviceId; // Unique ID for Windows device
  }

  String typeData(VisitingDataList visitingDataList) {
    var typedata = visitingDataList.typeWiseData;

    if (typedata == null || typedata.isEmpty) {
      print("⚠️ typeWiseData is null or empty!");
      return '';
    }

    print("🔹 typeWiseData: $typedata"); // Debugging check

    final Map<String, dynamic> nestedMap = {};

    for (var data in typedata) {
      print("🔹 Processing data: $data"); // Check each iteration

      final String fareId = data['visitorTypeId'].toString(); // Ensure it's a String
      final String categoryId = data['categoryId'].toString(); // Ensure it's a String

      // Ensure parent key exists
      nestedMap[fareId] ??= {};

      // If category already exists, update existing values
      if (nestedMap[fareId]!.containsKey(categoryId)) {
        nestedMap[fareId]![categoryId]["count"] += data["count"];
        nestedMap[fareId]![categoryId]["amount"] += data["amount"];

        // Add transection_unique_ids to list
        nestedMap[fareId]![categoryId]["transection_unique_ids"]
            .add(data["transection_unique_ids"]);
      } else {
        // Create new entry with transection_unique_ids as a list
        nestedMap[fareId]![categoryId] = {
          "amount": data["amount"],
          "count": data["count"],
          "routine_charges": data["routine_charges"],
          "categoryName": data["serviceName"],
          "category_id": data["categoryId"],
          "transection_unique_ids": data["transection_unique_ids"] // Store as list
        };
      }
    }

    String jsonString = jsonEncode(nestedMap);
    print("✅ Final nestedMap: $jsonString");
    return jsonString;
  }

  Future<PostResponseModel?> postVisitingData(BuildContext context, VisitingDataList visitingDataList ) async {
    _isLoading = true;
    notifyListeners();

    var typeWiseData = typeData(visitingDataList);
    try {
      final fullUrl = "${_dioService.baseUrl}${Constants.postVisitingData}";
      print("🔄 API Request Sent: '$fullUrl'");
      print("🔄 API Request Sent: '$typeWiseData'");


      Response response = await _dioService.postRequest(
        Constants.postVisitingData,
        {
          'typeWiseData': typeWiseData,
          'paymentId': visitingDataList.paymentId,
          'totalPersons': visitingDataList.totalPersons, // Modify as needed
          'totalAmount': visitingDataList.totalAmount,
          'gate_id': visitingDataList.gateId,
          'parking_lot_id': visitingDataList.parkingLotId,
          'user_id': visitingDataList.userId,
          'date': visitingDataList.date,
          'transection_unique_id': visitingDataList.transactionUniqueId,
          'user_mac_id': visitingDataList.userMacId,
          'bill_no' : visitingDataList.billNo
        },
        options: Options(
          validateStatus: (status) => true, // ✅ Allow all status codes
        ),
      );


      print({
        'typeWiseData': typeWiseData,
        'paymentId': visitingDataList.paymentId,
        'totalPersons': visitingDataList.totalPersons, // Modify as needed
        'totalAmount': visitingDataList.totalAmount,
        'gate_id': visitingDataList.gateId,
        'parking_lot_id': visitingDataList.parkingLotId,
        'user_id': visitingDataList.userId,
        'date': visitingDataList.date,
        'transection_unique_id': visitingDataList.transactionUniqueId,
        'user_mac_id': visitingDataList.userMacId,
        'bill_no' : visitingDataList.billNo
      },);

      print("📥 Response Data: ${response.data}");

      if (response.statusCode == 200) {
        print("✅ Success! Status Code: ${response.statusCode}");

        // Parse the response using PostResponseModel
        final postResponse = PostResponseModel.fromJson(response.data);
        ToastUtils.showSuccessToast(context, postResponse.success!);

        updateIsUploaded(1);
        print("before in condition!");
        // if(categoryPersons.isNotEmpty){
        //        if (visitingDataList != null) {
        //
        //          await databaseHelper?.insertVisitingData(visitingDataList); // Pass object directly
        //
        //
        //              print("Data saved successfully in SQLite!");
        //              clearAllData();
        //            } else {
        //              print("No data available to save.");
        //            }
        // } else {
        //   ToastUtils.showErrorToast(context, "Please select any Service");
        // }
        notifyListeners();

        return postResponse; //  Return parsed response
      } else {
        print("Failed! Status Code: ${response.statusCode}");

        // Parse error response
        final errorResponse = PostResponseModel.fromJson(response.data);

        updateIsUploaded(0);

        ToastUtils.showErrorToast(
          context,
          errorResponse.error ?? "Unauthorized access. Please check your credentials.",
        );
      }
    } catch (e) {
      print(" Error during post: $e");
      ToastUtils.showErrorToast(context, "Something went wrong. Try again later.");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return null;
  }
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _showPending = false;
  List<VisitingDataList> _filteredVisitingData = [];

  DateTime? get fromDate => _fromDate;
  DateTime? get toDate => _toDate;
  bool get showPending => _showPending;
  List<VisitingDataList> get filteredVisitingData => _filteredVisitingData;

  Future<void> setFromDate(DateTime? date) async {
    _fromDate = date;
    notifyListeners();
  }

  Future<void> setToDate(DateTime? date) async {
    _toDate = date;
    notifyListeners();
  }

  Future<void> setShowPending(bool value) async {
    _showPending = value;
    notifyListeners();
  }

  Future<void> applyFilter() async {
    if (_showPending) {
      _filteredVisitingData = await _fetchPendingVisitData(from: _fromDate, to: _toDate);
    } else {
      _filteredVisitingData = await _fetchVisitData(from: _fromDate, to: _toDate);
    }
    notifyListeners();
  }

  Future<List<VisitingDataList>> _fetchVisitData({DateTime? from, DateTime? to}) async {
    List<VisitingDataList> allData = await DatabaseHelper.instance.getVisitingData();

    if (from != null && to != null) {
      return allData.where((ticket) {
        DateTime ticketDate = DateTime.parse(ticket.date!).toLocal();
        DateTime ticketOnlyDate = DateTime(ticketDate.year, ticketDate.month, ticketDate.day);
        DateTime fromOnlyDate = DateTime(from.year, from.month, from.day);
        DateTime toOnlyDate = DateTime(to.year, to.month, to.day);

        return ticketOnlyDate.isAtSameMomentAs(fromOnlyDate) ||
            ticketOnlyDate.isAtSameMomentAs(toOnlyDate) ||
            (ticketOnlyDate.isAfter(fromOnlyDate) && ticketOnlyDate.isBefore(toOnlyDate));
      }).toList();
    }

    return allData;
  }


  Timer? _timer;

  void startBackgroundTask() {
    print("start background task");
    _timer?.cancel();
    _timer = Timer.periodic(Duration(minutes: 1), (timer) async {
      print("Background task running at ${DateTime.now()}");

      final hasInternet = await HelperFunction.hasInternetConnection();
      print("Internet available: $hasInternet");

      if (!hasInternet) return;

      final pendingData = await _fetchPendingVisitData();
      print("Pending data: ${pendingData.length}");

      for (final visit in pendingData) {
        await postVisitingDataFromDB(visit);
      }
    });
  }


  Future<List<VisitingDataList>> _fetchPendingVisitData({DateTime? from, DateTime? to}) async {
    List<VisitingDataList> allData = await DatabaseHelper.instance.getVisitingData();
    return allData.where((ticket) => ticket.isUploaded == 0).toList();
  }



  Future<PostResponseModel?> postVisitingDataFromDB(VisitingDataList visitingDataList ) async {
    _isLoading = true;
    notifyListeners(); // Notify UI to show loader


    var typeWiseData = typeData(visitingDataList);
    try {
      final fullUrl = "${_dioService.baseUrl}${Constants.postVisitingData}";
      print("🔄 API Request Sent: '$fullUrl'");
      print("🔄 API Request Sent: '$fullUrl'");


      Response response = await _dioService.postRequest(
        Constants.postVisitingData,
        {
          'typeWiseData': typeWiseData,
          'paymentId': visitingDataList.paymentId,
          'totalPersons': visitingDataList.totalPersons,
          'totalAmount': visitingDataList.totalAmount,
          'gate_id': visitingDataList.gateId,
          'parking_lot_id': visitingDataList.parkingLotId,
          'user_id': visitingDataList.userId,
          'date': visitingDataList.date,
          'transection_unique_id': visitingDataList.transactionUniqueId,
          'user_mac_id': visitingDataList.userMacId,
          'bill_no' : visitingDataList.billNo
        },
        options: Options (
          validateStatus: (status) => true,
        ),
      );


      print({ "post data body"
          'typeWiseData': typeWiseData,
        'paymentId': visitingDataList.paymentId,
        'totalPersons': visitingDataList.totalPersons,
        'totalAmount': visitingDataList.totalAmount,
        'gate_id': visitingDataList.gateId,
        'parking_lot_id': visitingDataList.parkingLotId,
        'user_id': visitingDataList.userId,
        'date': visitingDataList.date,
        'transection_unique_id': visitingDataList.transactionUniqueId,
        'user_mac_id': visitingDataList.userMacId,
      },);

      print("Response Data: ${response.data}");


      if (response.statusCode == 200) {
        print(" Success! Status Code: ${response.statusCode}");
        final postResponse = PostResponseModel.fromJson(response.data);
        print("database id ${visitingDataList.id!}");
        await databaseHelper?.updateIsUploaded(visitingDataList.transactionUniqueId!);
        updateRecord();
        notifyListeners();
        return postResponse;
      } else {
        print("Failed! Status Code: ${response.statusCode}");
        final errorResponse = PostResponseModel.fromJson(response.data);

        // Show error toast if error message exists
        // ToastUtils.showErrorToast(
        //   context,
        //   errorResponse.error ?? "Unauthorized access. Please check your credentials.",
        // );
      }
    } catch (e) {
      print(" Error during post: $e");
      //ToastUtils.showErrorToast(context, "Something went wrong. Try again later.");
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return null;
  }

  Future<void> updateRecord() async {
    List<VisitingDataList> updatedList = await DatabaseHelper.instance.getVisitingData();

    _visitingDataList = updatedList;
    notifyListeners();
  }




  Future<TicketCategoriesResponse?> getCategories(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    fetchVisitCount();

    try {
      final fullUrl = "${_dioService.baseUrl}${Constants.getCategories}";
      final user = await SharedPrefHelper.getUser();
      if (user == null) {
        print("User not found in SharedPreferences!");
        ToastUtils.showErrorToast(context, "User not found. Please login.");
      }

      String? id = user?.parkingLotsId.toString();
      print(" API Request Sent: '$fullUrl'");
      print("Request Data: {'id': $id}");

      Response response = await _dioService.getRequest(Constants.getCategories, {
        'id': "2",

      },
        options: Options(
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200) {
        print(" Success! Status Code: ${response.statusCode}");
        print(" Success! Status Code: ${response.statusMessage}");
        print(" Response Data: ${response.data}");

        TicketCategoriesResponse ticketCategoriesResponse  = TicketCategoriesResponse.fromJson(response.data);
        ToastUtils.showSuccessToast(context, "🎉 Data fetched!");
        await SharedPrefHelper.saveCategoriesList(ticketCategoriesResponse.catagories);
        // Save user in provider
        _ticketCategoriesResponse = ticketCategoriesResponse;
        notifyListeners();

        // Save user in SharedPreferences
        await SharedPrefHelper.saveCategoriesList(ticketCategoriesResponse.catagories);
        var getList = await SharedPrefHelper.getCategoriesList();
        print("get save catagory $getList");

        return ticketCategoriesResponse;
      } else {
        print("Failed! Status Code: ${response.statusCode}");
        print("Failed! Status Code: ${response.statusMessage}");
        print("Response Data: ${response.data}");
      }
    } catch (e) {
      print("Error adding post: $e");

    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return null;
  }

}