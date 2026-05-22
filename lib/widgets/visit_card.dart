import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mandubi/models/visit.dart';
import 'package:mandubi/theme/app_theme.dart';

class VisitCard extends StatelessWidget {
  final Visit visit;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final bool showDoctorName;

  const VisitCard({
    Key? key,
    required this.visit,
    required this.onTap,
    this.onDelete,
    this.showDoctorName = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = intl.DateFormat('yyyy-MM-dd', 'ar_SA');
    
    final isOverdue = visit.nextFollowUpDate.isBefore(DateTime.now());
    final isToday = _isToday(visit.nextFollowUpDate);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.paddingMedium,
        vertical: AppTheme.paddingSmall,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          decoration: BoxDecoration(
            borderLeft: BorderSide(
              color: isOverdue ? AppTheme.errorColor : AppTheme.primaryColor,
              width: 4,
            ),
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الرأس مع اسم الطبيب
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showDoctorName)
                          Text(
                            visit.doctorName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryDarkColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: 4),
                        Text(
                          'تاريخ الزيارة: ${dateFormat.format(visit.visitDate)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.greyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onDelete != null)
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: onDelete,
                          child: const Text('حذف'),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: AppTheme.paddingSmall),
              // الأصناف المعروضة
              if (visit.productsDetailed.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.paddingSmall),
                  child: Text(
                    'الأصناف: ${visit.productsDetailed}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              // تاريخ المتابعة القادمة
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.paddingSmall,
                  vertical: AppTheme.paddingXSmall,
                ),
                decoration: BoxDecoration(
                  color: isOverdue
                      ? AppTheme.errorColor.withOpacity(0.1)
                      : isToday
                          ? AppTheme.warningColor.withOpacity(0.1)
                          : AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                ),
                child: Text(
                  'المتابعة: ${dateFormat.format(visit.nextFollowUpDate)} ${isOverdue ? '⚠️ متأخرة' : isToday ? '📅 اليوم' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isOverdue
                        ? AppTheme.errorColor
                        : isToday
                            ? AppTheme.warningColor
                            : AppTheme.primaryColor,
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

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
