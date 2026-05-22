import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandubi/controllers/doctors_controller.dart';
import 'package:mandubi/models/doctor.dart';
import 'package:mandubi/theme/app_theme.dart';
import 'package:uuid/uuid.dart';

class AddDoctorScreen extends StatefulWidget {
  const AddDoctorScreen({Key? key}) : super(key: key);

  @override
  State<AddDoctorScreen> createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  late TextEditingController nameController;
  late TextEditingController specialtyController;
  late TextEditingController clinicController;
  late TextEditingController regionController;
  late TextEditingController phoneController;
  late TextEditingController notesController;
  
  String selectedClassification = 'A';
  final formKey = GlobalKey<FormState>();
  final doctorsController = Get.find<DoctorsController>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    specialtyController = TextEditingController();
    clinicController = TextEditingController();
    regionController = TextEditingController();
    phoneController = TextEditingController();
    notesController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    specialtyController.dispose();
    clinicController.dispose();
    regionController.dispose();
    phoneController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة طبيب جديد'),
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
                // Name
                _buildLabel('اسم الطبيب'),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'أدخل اسم الطبيب',
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال اسم الطبيب';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.paddingMedium),

                // Classification
                _buildLabel('التصنيف'),
                DropdownButtonFormField<String>(
                  value: selectedClassification,
                  items: ['A', 'B', 'C'].map((classification) {
                    return DropdownMenuItem(
                      value: classification,
                      child: Text('فئة $classification'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedClassification = value);
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.category),
                  ),
                ),
                const SizedBox(height: AppTheme.paddingMedium),

                // Specialty
                _buildLabel('التخصص'),
                TextFormField(
                  controller: specialtyController,
                  decoration: InputDecoration(
                    hintText: 'مثال: أسنان، قلب، عام',
                    prefixIcon: const Icon(Icons.local_hospital),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال التخصص';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.paddingMedium),

                // Clinic/Hospital
                _buildLabel('اسم العيادة أو المستشفى'),
                TextFormField(
                  controller: clinicController,
                  decoration: InputDecoration(
                    hintText: 'أدخل اسم العيادة أو المستشفى',
                    prefixIcon: const Icon(Icons.location_city),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال اسم العيادة';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.paddingMedium),

                // Region
                _buildLabel('المنطقة'),
                TextFormField(
                  controller: regionController,
                  decoration: InputDecoration(
                    hintText: 'مثال: المحويت، صنعاء',
                    prefixIcon: const Icon(Icons.location_on),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال المنطقة';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.paddingMedium),

                // Phone
                _buildLabel('رقم الهاتف'),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: '0969123456',
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال رقم الهاتف';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.paddingMedium),

                // Pharmacies Notes
                _buildLabel('ملاحظات الصيدليات'),
                TextFormField(
                  controller: notesController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'أدخل ملاحظات إضافية',
                    prefixIcon: const Icon(Icons.notes),
                  ),
                ),
                const SizedBox(height: AppTheme.paddingLarge),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSave,
                    child: const Text('إضافة الطبيب'),
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

  void _handleSave() {
    if (formKey.currentState!.validate()) {
      final newDoctor = Doctor(
        id: const Uuid().v4(),
        name: nameController.text,
        classification: selectedClassification,
        specialty: specialtyController.text,
        clinicHospital: clinicController.text,
        region: regionController.text,
        phoneNumber: phoneController.text,
        pharmaciesNotes: notesController.text,
        createdAt: DateTime.now(),
      );

      doctorsController.addDoctor(newDoctor).then((_) {
        Get.back();
      }).catchError((error) {
        Get.snackbar('خطأ', 'فشل حفظ الطبيب: $error');
      });
    }
  }
}
