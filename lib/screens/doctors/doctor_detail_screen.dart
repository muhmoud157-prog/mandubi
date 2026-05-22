import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mandubi/models/doctor.dart';
import 'package:mandubi/models/visit.dart';
import 'package:mandubi/services/firestore_service.dart';
import 'package:mandubi/theme/app_theme.dart';
import 'package:mandubi/widgets/visit_card.dart';

class DoctorDetailScreen extends StatelessWidget {
  const DoctorDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final doctor = Get.arguments as Doctor;
    final firestoreService = FirestoreService();
    final dateFormat = intl.DateFormat('yyyy-MM-dd', 'ar_SA');

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الطبيب'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Doctor Info Card
            Container(
              color: AppTheme.backgroundColor,
              padding: const EdgeInsets.all(AppTheme.paddingMedium),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctor.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryDarkColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppTheme.paddingSmall,
                                    vertical: AppTheme.paddingXSmall,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getClassificationColor(doctor.classification),
                                    borderRadius: BorderRadius.circular(
                                      AppTheme.borderRadiusSmall,
                                    ),
                                  ),
                                  child: Text(
                                    'فئة ${doctor.classification}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.paddingLarge),
                      // Details
                      _buildDetailItem('التخصص', doctor.specialty),
                      _buildDetailItem('العيادة', doctor.clinicHospital),
                      _buildDetailItem('المنطقة', doctor.region),
                      _buildDetailItem('رقم الهاتف', doctor.phoneNumber),
                      if (doctor.pharmaciesNotes.isNotEmpty)
                        _buildDetailItem('ملاحظات الصيدليات', doctor.pharmaciesNotes),
                      if (doctor.lastVisit != null)
                        _buildDetailItem(
                          'آخر زيارة',
                          dateFormat.format(doctor.lastVisit!),
                        ),
                      _buildDetailItem(
                        'عدد الزيارات',
                        doctor.visitCount.toString(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Visits List
            Padding(
              padding: const EdgeInsets.all(AppTheme.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الزيارات السابقة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryDarkColor,
                    ),
                  ),
                  const SizedBox(height: AppTheme.paddingMedium),
                  FutureBuilder<List<Visit>>(
                    future: firestoreService.getVisitsByDoctor(doctor.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text('خطأ: ${snapshot.error}'),
                        );
                      }

                      final visits = snapshot.data ?? [];

                      if (visits.isEmpty) {
                        return Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.history,
                                size: 48,
                                color: AppTheme.greyColor,
                              ),
                              const SizedBox(height: AppTheme.paddingMedium),
                              const Text(
                                'لا توجد زيارات سابقة',
                                style: TextStyle(
                                  color: AppTheme.textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Column(
                        children: visits
                            .map((visit) => VisitCard(
                              visit: visit,
                              showDoctorName: false,
                              onTap: () {},
                              onDelete: () {
                                // TODO: Delete visit
                              },
                            ))
                            .toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textPrimaryColor,
              ),
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
