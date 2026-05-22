import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandubi/controllers/doctors_controller.dart';
import 'package:mandubi/models/doctor.dart';
import 'package:mandubi/routes/app_routes.dart';
import 'package:mandubi/theme/app_theme.dart';

class DoctorsScreen extends StatelessWidget {
  const DoctorsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final doctorsController = Get.put(DoctorsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('دليل الأطباء'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Padding(
            padding: const EdgeInsets.all(AppTheme.paddingMedium),
            child: Column(
              children: [
                // Search Field
                TextField(
                  onChanged: (value) => doctorsController.searchDoctors(value),
                  decoration: InputDecoration(
                    hintText: 'ابحث عن طبيب...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Obx(() => doctorsController.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              doctorsController.searchDoctors('');
                            },
                          )
                        : null),
                  ),
                ),
                const SizedBox(height: AppTheme.paddingMedium),
                // Classification Filter
                Obx(() => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: doctorsController.classifications.map((classification) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.paddingSmall,
                        ),
                        child: FilterChip(
                          label: Text(classification),
                          selected: doctorsController.selectedClassification.value ==
                              classification,
                          onSelected: (_) {
                            doctorsController.filterByClassification(classification);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                )),
              ],
            ),
          ),
          // Doctors List
          Expanded(
            child: Obx(() {
              if (doctorsController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (doctorsController.filteredDoctors.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 48,
                        color: AppTheme.greyColor,
                      ),
                      const SizedBox(height: AppTheme.paddingMedium),
                      const Text(
                        'لم يتم العثور على أطباء',
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeLarge,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: doctorsController.filteredDoctors.length,
                itemBuilder: (context, index) {
                  final doctor = doctorsController.filteredDoctors[index];
                  return _buildDoctorCard(context, doctor, doctorsController);
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.addDoctor),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDoctorCard(
    BuildContext context,
    Doctor doctor,
    DoctorsController controller,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.paddingMedium,
        vertical: AppTheme.paddingSmall,
      ),
      child: InkWell(
        onTap: () {
          // Navigate to doctor detail screen
          Get.toNamed(Routes.doctorDetail, arguments: doctor);
        },
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name and Classification
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      doctor.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDarkColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.paddingSmall,
                      vertical: AppTheme.paddingXSmall,
                    ),
                    decoration: BoxDecoration(
                      color: _getClassificationColor(doctor.classification),
                      borderRadius:
                          BorderRadius.circular(AppTheme.borderRadiusSmall),
                    ),
                    child: Text(
                      doctor.classification,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.paddingSmall),
              // Details
              _buildDetailRow(Icons.local_hospital, doctor.specialty),
              _buildDetailRow(Icons.location_on, doctor.region),
              _buildDetailRow(Icons.phone, doctor.phoneNumber),
              if (doctor.visitCount > 0)
                Padding(
                  padding: const EdgeInsets.only(top: AppTheme.paddingSmall),
                  child: Text(
                    'عدد الزيارات: ${doctor.visitCount}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getClassificationColor(String classification) {
    switch (classification) {
      case 'A':
        return AppTheme.successColor;
      case 'B':
        return AppTheme.warningColor;
      case 'C':
        return AppTheme.errorColor;
      default:
        return AppTheme.primaryColor;
    }
  }
}
