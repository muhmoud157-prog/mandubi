import 'package:get/get.dart';
import 'package:mandubi/models/visit.dart';
import 'package:mandubi/services/firestore_service.dart';

class VisitsController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();

  RxList<Visit> allVisits = RxList<Visit>();
  RxList<Visit> todayVisits = RxList<Visit>();
  RxList<Visit> overdueVisits = RxList<Visit>();
  RxList<Visit> upcomingVisits = RxList<Visit>();
  RxBool isLoading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    fetchAllVisits();
    _firestoreService.getVisitsStream().listen((visits) {
      allVisits.value = visits;
      _categorizeVisits();
    });
  }

  Future<void> fetchAllVisits() async {
    try {
      isLoading.value = true;
      final visits = await _firestoreService.getAllVisits();
      allVisits.value = visits;
      _categorizeVisits();
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تحميل الزيارات');
    } finally {
      isLoading.value = false;
    }
  }

  void _categorizeVisits() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    todayVisits.value = allVisits
        .where((visit) =>
            visit.nextFollowUpDate.isAfter(today) &&
            visit.nextFollowUpDate.isBefore(tomorrow))
        .toList();

    overdueVisits.value = allVisits
        .where((visit) => visit.nextFollowUpDate.isBefore(today))
        .toList();

    upcomingVisits.value = allVisits
        .where((visit) =>
            visit.nextFollowUpDate.isAfter(tomorrow) ||
            visit.nextFollowUpDate.isAtSameMomentAs(tomorrow))
        .toList();
  }

  Future<void> addVisit({
    required String doctorId,
    required String doctorName,
    required DateTime visitDate,
    required String productsDetailed,
    required String samplesGiven,
    required String feedbackNotes,
    required DateTime nextFollowUpDate,
  }) async {
    try {
      final visit = Visit(
        doctorId: doctorId,
        doctorName: doctorName,
        visitDate: visitDate,
        productsDetailed: productsDetailed,
        samplesGiven: samplesGiven,
        feedbackNotes: feedbackNotes,
        nextFollowUpDate: nextFollowUpDate,
      );

      await _firestoreService.addVisit(visit);
      fetchAllVisits();
    } catch (e) {
      Get.snackbar('خطأ', 'فشل إضافة الزيارة');
    }
  }

  List<Visit> getVisitsByDoctor(String doctorId) {
    return allVisits.where((visit) => visit.doctorId == doctorId).toList();
  }

  Future<void> deleteVisit(String id) async {
    try {
      await _firestoreService.deleteVisit(id);
      fetchAllVisits();
      Get.snackbar('نجاح', 'تم حذف الزيارة');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل حذف الزيارة');
    }
  }

  Map<String, int> getDashboardSummary() {
    return {
      'todayCount': todayVisits.length,
      'overdueCount': overdueVisits.length,
      'upcomingCount': upcomingVisits.length,
    };
  }
}
