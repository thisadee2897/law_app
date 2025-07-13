import 'package:flutter/material.dart';

class RecurrenceBottomSheet extends StatelessWidget {
  final String currentRecurrence;
  final Function(String) onRecurrenceChanged;

  const RecurrenceBottomSheet({
    super.key,
    required this.currentRecurrence,
    required this.onRecurrenceChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final recurrenceOptions = [
      {'value': 'none', 'title': 'ไม่ต้องทำซ้ำ', 'subtitle': 'แจ้งเตือนเพียงครั้งเดียว', 'icon': Icons.schedule},
      {'value': 'daily', 'title': 'ทุกวัน', 'subtitle': 'แจ้งเตือนทุกวันในเวลาเดียวกัน', 'icon': Icons.today},
      {'value': 'weekly', 'title': 'ทุกสัปดาห์', 'subtitle': 'แจ้งเตือนทุกสัปดาห์ในวันและเวลาเดียวกัน', 'icon': Icons.view_week},
      {'value': 'monthly', 'title': 'ทุกเดือน', 'subtitle': 'แจ้งเตือนทุกเดือนในวันที่และเวลาเดียวกัน', 'icon': Icons.calendar_month},
      {'value': 'yearly', 'title': 'ทุกปี', 'subtitle': 'แจ้งเตือนทุกปีในวันที่และเวลาเดียวกัน', 'icon': Icons.event_repeat},
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.repeat,
                  color: theme.primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'การทำซ้ำ',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Options
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recurrenceOptions.length,
            itemBuilder: (context, index) {
              final option = recurrenceOptions[index];
              final isSelected = currentRecurrence == option['value'];
              
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected 
                        ? theme.primaryColor 
                        : theme.dividerColor.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? theme.primaryColor.withOpacity(0.1)
                          : theme.primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      option['icon'] as IconData,
                      color: isSelected 
                          ? theme.primaryColor
                          : theme.primaryColor.withOpacity(0.7),
                      size: 24,
                    ),
                  ),
                  title: Text(
                    option['title'] as String,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected 
                          ? theme.primaryColor
                          : theme.textTheme.titleMedium?.color,
                    ),
                  ),
                  subtitle: Text(
                    option['subtitle'] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                    ),
                  ),
                  trailing: AnimatedScale(
                    scale: isSelected ? 1.0 : 0.8,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? theme.primaryColor
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected 
                              ? theme.primaryColor
                              : theme.dividerColor,
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              size: 16,
                              color: theme.colorScheme.onPrimary,
                            )
                          : null,
                    ),
                  ),
                  onTap: () {
                    onRecurrenceChanged(option['value'] as String);
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
