import 'package:get/get.dart';
import 'package:mandubi/models/doctor.dart';
import 'package:mandubi/services/firestore_service.dart';

class DoctorsController extends GetxController {
  final firestoreService = FirestoreService();
  
  final RxList<Doctor> doctors = <Doctor>[].obs;
  final RxList<Doctor> filteredDoctors = <Doctor>[].obs;
  final RxString selectedClassification = 'الكل'.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final List<String> classifications = ['الكل', 'A', 'B', 'C'];

  @override
  void onInit() {
    super.onInit();
    fetchAllDoctors();
  }

  Future<void> fetchAllDoctors() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final allDoctors = await firestoreService.getAllDoctors();
      doctors.assignAll(allDoctors);
      applyFilters();
    } catch (e) {
      errorMessage.value = 'خطأ في تحميل الأطباء: $e';
      Get.snackbar('خطأ', errorMessage.value, duration: const Duration(seconds: 3));
    } finally {
      isLoading.value = false;
    }
  }

  Future<Doctor> addDoctor(Doctor doctor) async {
    try {
      isLoading.value = true;
      final newDoctor = await firestoreService.addDoctor(doctor);
      doctors.add(newDoctor);
      applyFilters();
      Get.snackbar('نجح', 'تم إضافة الطبيب بنجاح');
      return newDoctor;
    } catch (e) {
      errorMessage.value = 'خطأ في إضافة الطبيب: $e';
      Get.snackbar('خطأ', errorMessage.value);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDoctor(Doctor doctor) async {
    try {
      isLoading.value = true;
      await firestoreService.updateDoctor(doctor);
      final index = doctors.indexWhere((d) => d.id == doctor.id);
      if (index != -1) {
        doctors[index] = doctor;
      }
      applyFilters();
      Get.snackbar('نجح', 'تم تحديث بيانات الطبيب');
    } catch (e) {
      errorMessage.value = 'خطأ في تحديث الطبيب: $e';
      Get.snackbar('خطأ', errorMessage.value);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteDoctor(String doctorId) async {
    try {
      isLoading.value = true;
      await firestoreService.deleteDoctor(doctorId);
      doctors.removeWhere((d) => d.id == doctorId);
      applyFilters();
      Get.snackbar('نجح', 'تم حذف الطبيب بنجاح');
    } catch (e) {
      errorMessage.value = 'خطأ في حذف الطبيب: $e';
      Get.snackbar('خطأ', errorMessage.value);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void filterByClassification(String classification) {
    selectedClassification.value = classification;
    applyFilters();
  }

  void searchDoctors(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void applyFilters() {
    List<Doctor> result = doctors.toList();

    // Apply classification filter
    if (selectedClassification.value != 'الكل') {
      result = result
          .where((doctor) => doctor.classification == selectedClassification.value)
          .toList();
    }

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      result = result
          .where((doctor) =>
              doctor.name.contains(searchQuery.value) ||
              doctor.specialty.contains(searchQuery.value) ||
              doctor.region.contains(searchQuery.value))
          .toList();
    }

    filteredDoctors.assignAll(result);
  }
}
