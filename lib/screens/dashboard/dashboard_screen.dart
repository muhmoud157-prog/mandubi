import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mandubi/controllers/visits_controller.dart';
import 'package:mandubi/routes/app_routes.dart';
import 'package:mandubi/theme/app_theme.dart';
import 'package:mandubi/widgets/visit_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final visitsController = Get.put(VisitsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة التحكم'),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () => visitsController.fetchAllVisits(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الإحصائيات السريعة
                Obx(() {
                  final summary = visitsController.getDashboardSummary();
                  return Column(
                    children: [
                      // الزيارات المتأخرة
                      _buildStatCard(
                        title: 'زيارات متأخرة',
                        count: summary['overdueCount'],
                        icon: Icons.warning_amber_rounded,
                        color: AppTheme.errorColor,
                        onTap: () {},
                      ),
                      const SizedBox(height: AppTheme.paddingMedium),
                      // الزيارات اليوم
                      _buildStatCard(
                        title: 'زيارات اليوم',
                        count: summary['todayCount'],
                        icon: Icons.calendar_today,
                        color: AppTheme.warningColor,
                        onTap: () {},
                      ),
                      const SizedBox(height: AppTheme.paddingMedium),
                      // الزيارات القادمة
                      _buildStatCard(
                        title: 'زيارات قادمة',
                        count: summary['upcomingCount'],
                        icon: Icons.schedule,
                        color: AppTheme.primaryColor,
                        onTap: () {},
                      ),
                    ],
                  );
                }),
                const SizedBox(height: AppTheme.paddingLarge),

                // الزيارات المطلوبة اليوم
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'الزيارات المقررة اليوم',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDarkColor,
                      ),
                    ),
                    Obx(() => Text(
                      '${visitsController.todayVisits.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    )),
                  ],
                ),
                const SizedBox(height: AppTheme.paddingMedium),

                // قائمة الزيارات اليوم
                Obx(() {
                  if (visitsController.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (visitsController.todayVisits.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppTheme.paddingLarge,
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 48,
                            color: AppTheme.successColor,
                          ),
                          const SizedBox(height: AppTheme.paddingMedium),
                          const Text(
                            'لا توجد زيارات مقررة اليوم',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: visitsController.todayVisits
                        .map((visit) => VisitCard(
                      visit: visit,
                      onTap: () {
                        // TODO: Navigate to visit detail
                      },
                      onDelete: () {
                        visitsController.deleteVisit(visit.id);
                      },
                    ))
                        .toList(),
                  );
                }),

                const SizedBox(height: AppTheme.paddingLarge),

                // الزيارات المتأخرة
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'الزيارات المتأخرة',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDarkColor,
                      ),
                    ),
                    Obx(() => Text(
                      '${visitsController.overdueVisits.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.errorColor,
                      ),
                    )),
                  ],
                ),
                const SizedBox(height: AppTheme.paddingMedium),

                Obx(() {
                  if (visitsController.overdueVisits.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppTheme.paddingMedium,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'لا توجد زيارات متأخرة',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: visitsController.overdueVisits
                        .take(5)
                        .map((visit) => VisitCard(
                      visit: visit,
                      onTap: () {
                        // TODO: Navigate to visit detail
                      },
                      onDelete: () {
                        visitsController.deleteVisit(visit.id);
                      },
                    ))
                        .toList(),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.addVisit),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.paddingMedium),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(width: AppTheme.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      count.toString(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
