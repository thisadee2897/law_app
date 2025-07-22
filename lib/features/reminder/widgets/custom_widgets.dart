import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:law_app/core/database/models/form_model.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final bool enabled;
  final String? errorText;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final bool readOnly;

  const CustomTextField({
    super.key,
    this.readOnly = false,
    required this.label,
    this.hintText,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.enabled = true,
    this.errorText,
    this.onTap,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.textTheme.titleMedium?.color)),
        const SizedBox(height: 8),
        TextField(
          readOnly: readOnly,
          controller: controller,
          enabled: enabled,
          maxLines: maxLines,
          keyboardType: keyboardType,
          onTap: onTap,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            suffixIcon: suffixIcon,
            errorText: errorText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.dividerColor)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.5))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.primaryColor, width: 2)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.error)),
            disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.disabledColor.withOpacity(0))),
            filled: true,
            fillColor: enabled ? theme.cardColor : theme.disabledColor.withOpacity(0.1),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final VoidCallback? onTap;

  const CustomCard({super.key, required this.child, this.padding, this.margin, this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      child: Material(
        color: color ?? theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: padding ?? const EdgeInsets.all(20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: theme.dividerColor.withOpacity(0.1))),
            child: child,
          ),
        ),
      ),
    );
  }
}

class SelectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool hasValue;
  final String? errorText;
  final bool enabled;

  const SelectionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.onTap,
    this.hasValue = false,
    this.errorText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          elevation: 0,
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration:
                  enabled
                      ? BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              hasError
                                  ? theme.colorScheme.error
                                  : hasValue
                                  ? theme.primaryColor.withOpacity(0.3)
                                  : theme.dividerColor.withOpacity(0.3),
                          width: hasError || hasValue ? 1.5 : 1,
                        ),
                      )
                      : BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: hasValue ? theme.primaryColor.withOpacity(0.1) : theme.primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: hasValue ? theme.primaryColor : theme.primaryColor.withOpacity(0.7), size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: hasValue ? FontWeight.w600 : FontWeight.normal,
                            color: hasValue ? theme.primaryColor : theme.textTheme.titleMedium?.color,
                          ),
                        ),
                        if (subtitle != null)
                          Text(subtitle!, style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7))),
                      ],
                    ),
                  ),
                  if (enabled) Icon(Icons.arrow_forward_ios, size: 16, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5)),
                ],
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(errorText!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error)),
          ),
        ],
      ],
    );
  }
}

class SelectedPdfChip extends StatelessWidget {
  final String fileName;
  final VoidCallback onRemove;
  final bool downloadable;
  final FormModel form;

  const SelectedPdfChip({super.key, required this.fileName, required this.onRemove, this.downloadable = false, required this.form});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: downloadable ?() => download(context) : null,
      child: Container(
        margin: const EdgeInsets.only(right: 8, bottom: 8),
        decoration: BoxDecoration(
          color: !downloadable ? theme.primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: !downloadable ? theme.primaryColor.withOpacity(0.3) : Colors.green),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.picture_as_pdf, size: 16, color: theme.primaryColor),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  fileName,
                  style: theme.textTheme.bodySmall?.copyWith(color: downloadable ? Colors.green : theme.primaryColor, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              if (!downloadable)
                GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(color: theme.primaryColor, shape: BoxShape.circle),
                    child: Icon(Icons.close, size: 12, color: theme.colorScheme.onPrimary),
                  ),
                ),
              if (downloadable)
                // downloadable
                GestureDetector(
                  onTap: () => download(context),
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                    child: Icon(Icons.download, size: 12, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> download(BuildContext context) async {
    try {
      final byteData = await rootBundle.load(form.pdfPath);
      final bytes = byteData.buffer.asUint8List();
      final dir = await getTemporaryDirectory();
      final fileName = "SafeDoc_app_file_${form.code}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}";
      print('File name: $fileName');
      final file = File('${dir.path}/$fileName.pdf');
      if (await file.exists()) {
        await file.delete();
      }
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    } catch (e) {
      // Show error dialog
      if (context.mounted) {
        _showErrorDialog('ไม่สามารถเปิดเอกสารได้', context);
      }
    }
  }

  void _showErrorDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(children: [Icon(Icons.error_outline, color: Colors.red, size: 24), SizedBox(width: 8), const Text('เกิดข้อผิดพลาด')]),
            content: Text(message),
            actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('ตกลง'))],
          ),
    );
  }
}
