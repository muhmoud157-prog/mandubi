import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandubi/controllers/doctors_controller.dart';
import 'package:mandubi/controllers/visits_controller.dart';
import 'package:mandubi/models/visit.dart';
import 'package:mandubi/theme/app_theme.dart';
import 'package:uuid/uuid.dart';

class AddVisitScreen extends StatefulWidget {
  const AddVisitScreen({Key? key}) : super(key: key);

  @override
  State<AddVisitScreen> createState() => _AddVisitScreenState();
}

class _AddVisitScreenState extends State<AddVisitScreen> {
  late TextEditingController productsController;
  late TextEditingController samplesController;
  late TextEditingController feedbackController;
  
  DateTime selectedVisitDate = DateTime.now();
  DateTime selectedFollowUpDate = DateTime.now().add(const Duration(days: 7));
  String? selectedDoctorId;
  String? selectedDoctorName;
  
  final formKey = GlobalKey<FormState>();
  final doctorsController = Get.find<DoctorsController>();
  final visitsController = Get.find<VisitsController>();

  @override
  void initState() {
    super.initState();
    productsController = TextEditingController();
    samplesController = TextEditingController();
    feedbackController = TextEditingController();
  }

  @override
  void dispose() {
    productsController.dispose();
    samplesController.dispose();
    feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة زيارة جديدة'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor Selection
                _buildLabel('اختر الطبيب'),
                Obx(() => DropdownButtonFormField<String>(
                  value: selectedDoctorId,
                  items: doctorsController.doctors.map((doctor) {
                    return DropdownMenuItem(
                      value: doctor.id,
                      child: Text(doctor.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDoctorId = value;
                      selectedDoctorName = doctorsController.doctors
                          .firstWhere((d) => d.id == value)
                          .name;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'اختر طبيب',
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'الرجاء اختيار طبيب';
                    }
                    return null;
                  },
                )),
                const SizedBox(height: AppTheme.paddingMedium),

                // Visit Date
                _buildLabel('تاريخ الزيارة'),
                ListTile(
                  title: Text(
                    'تاريخ الزيارة: ${selectedVisitDate.toLocal().toString().split(' ')[0]}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectVisitDate(context),
                ),
                const SizedBox(height: AppTheme.paddingMedium),

                // Products
                _buildLabel('الأصناف المعروضة'),
                TextFormField(
                  controller: productsController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'أدخل الأصناف التي تم عرضها',
                    prefixIcon: const Icon(Icons.shopping_bag),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال الأصناف';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.paddingMedium),

                // Samples
                _buildLabel('العينات المقدمة'),
                TextFormField(
                  controller: samplesController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'أدخل العينات المقدمة',
                    prefixIcon: const Icon(Icons.inventory),
                  ),
                ),
                const SizedBox(height: AppTheme.paddingMedium),

                // Feedback
                _buildLabel('ملخص الزيارة والملاحظات'),
                TextFormField(
                  controller: feedbackController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'أدخل ملخص الزيارة والملاحظات',
                    prefixIcon: const Icon(Icons.note),
                  ),
                ),
                const SizedBox(height: AppTheme.paddingMedium),

                // Next Follow-up Date
                _buildLabel('تاريخ المتابعة القادمة'),
                ListTile(
                  title: Text(
                    'تاريخ المتابعة: ${selectedFollowUpDate.toLocal().toString().split(' ')[0]}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectFollowUpDate(context),
                ),
                const SizedBox(height: AppTheme.paddingLarge),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSave,
                    child: const Text('إضافة الزيارة'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.paddingSmall),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: AppTheme.fontSizeLarge,
          fontWeight: FontWeight.w600,
          color: AppTheme.primaryDarkColor,
        ),
      ),
    );
  }

  Future<void> _selectVisitDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedVisitDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedVisitDate) {
      setState(() => selectedVisitDate = picked);
    }
  }

  Future<void> _selectFollowUpDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedFollowUpDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedFollowUpDate) {
      setState(() => selectedFollowUpDate = picked);
    }
  }

  void _handleSave() {
    if (formKey.currentState!.validate()) {
      final newVisit = Visit(
        id: const Uuid().v4(),
        doctorId: selectedDoctorId!,
        doctorName: selectedDoctorName!,
        visitDate: selectedVisitDate,
        productsDetailed: productsController.text,
        sampleGiven: samplesController.text,
        feedbackNotes: feedbackController.text,
        nextFollowUpDate: selectedFollowUpDate,
        createdAt: DateTime.now(),
      );

      visitsController.addVisit(newVisit).then((_) {
        Get.back();
      }).catchError((error) {
        Get.snackbar('خطأ', 'فشل حفظ الزيارة: $error');
      });
    }
  }
}
