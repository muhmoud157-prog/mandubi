import 'package:get/get.dart';
import 'package:mandubi/models/visit.dart';
import 'package:mandubi/services/firestore_service.dart';

class VisitsController extends GetxController {
  final firestoreService = FirestoreService();
  
  final RxList<Visit> visits = <Visit>[].obs;
  final RxList<Visit> todayVisits = <Visit>[].obs;
  final RxList<Visit> overdueVisits = <Visit>[].obs;
  final RxList<Visit> upcomingVisits = <Visit>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllVisits();
  }

  Future<void> fetchAllVisits() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final allVisits = await firestoreService.getAllVisits();
      visits.assignAll(allVisits);
      categorizeVisits();
    } catch (e) {
      errorMessage.value = 'خطأ في تحميل الزيارات: $e';
      Get.snackbar('خطأ', errorMessage.value, duration: const Duration(seconds: 3));
    } finally {
      isLoading.value = false;
    }
  }

  void categorizeVisits() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    todayVisits.clear();
    overdueVisits.clear();
    upcomingVisits.clear();

    for (final visit in visits) {
      final visitDate = DateTime(
        visit.nextFollowUpDate.year,
        visit.nextFollowUpDate.month,
        visit.nextFollowUpDate.day,
      );

      if (visitDate.isBefore(today)) {
        // زيارة متأخرة
        overdueVisits.add(visit);
      } else if (visitDate.isAtSameMomentAs(today)) {
        // زيارة اليوم
        todayVisits.add(visit);
      } else if (visitDate.isBefore(tomorrow.add(const Duration(days: 7)))) {
        // زيارات قادمة خلال أسبوع
        upcomingVisits.add(visit);
      }
    }

    // Sort by date
    todayVisits.sort((a, b) => a.nextFollowUpDate.compareTo(b.nextFollowUpDate));
    overdueVisits.sort((a, b) => a.nextFollowUpDate.compareTo(b.nextFollowUpDate));
    upcomingVisits.sort((a, b) => a.nextFollowUpDate.compareTo(b.nextFollowUpDate));
  }

  Future<Visit> addVisit(Visit visit) async {
    try {
      isLoading.value = true;
      final newVisit = await firestoreService.addVisit(visit);
      visits.add(newVisit);
      categorizeVisits();
      Get.snackbar('نجح', 'تم إضافة الزيارة بنجاح');
      return newVisit;
    } catch (e) {
      errorMessage.value = 'خطأ في إضافة الزيارة: $e';
      Get.snackbar('خطأ', errorMessage.value);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateVisit(Visit visit) async {
    try {
      isLoading.value = true;
      await firestoreService.updateVisit(visit);
      final index = visits.indexWhere((v) => v.id == visit.id);
      if (index != -1) {
        visits[index] = visit;
      }
      categorizeVisits();
      Get.snackbar('نجح', 'تم تحديث الزيارة');
    } catch (e) {
      errorMessage.value = 'خطأ في تحديث الزيارة: $e';
      Get.snackbar('خطأ', errorMessage.value);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteVisit(String visitId) async {
    try {
      isLoading.value = true;
      await firestoreService.deleteVisit(visitId);
      visits.removeWhere((v) => v.id == visitId);
      categorizeVisits();
      Get.snackbar('نجح', 'تم حذف الزيارة');
    } catch (e) {
      errorMessage.value = 'خطأ في حذف الزيارة: $e';
      Get.snackbar('خطأ', errorMessage.value);
      rethrow;
    } finally {
      isLoading.value = false;
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
