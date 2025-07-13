import 'package:flutter/material.dart';
import 'package:law_app/core/database/models/form_model.dart';

class MultiSelectPdfBottomSheet extends StatefulWidget {
  final List<FormModel> availablePdfs;
  final List<FormModel> selectedPdfs;
  final Function(FormModel) onToggle;
  final VoidCallback? onClearAll;

  const MultiSelectPdfBottomSheet({super.key, required this.availablePdfs, required this.selectedPdfs, required this.onToggle, this.onClearAll});

  @override
  State<MultiSelectPdfBottomSheet> createState() => _MultiSelectPdfBottomSheetState();
}

class _MultiSelectPdfBottomSheetState extends State<MultiSelectPdfBottomSheet> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FormModel> get filteredPdfs {
    if (_searchQuery.isEmpty) {
      return widget.availablePdfs;
    }
    widget.availablePdfs.sort((a, b) {
      if (b.favorite == a.favorite) return 0;
      return b.favorite ? 1 : -1;
    });
    return widget.availablePdfs.where((pdf) => pdf.formName.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(color: theme.scaffoldBackgroundColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 4,
            width: 40,
            decoration: BoxDecoration(color: theme.dividerColor, borderRadius: BorderRadius.circular(2)),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.picture_as_pdf, color: theme.primaryColor, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('เลือกไฟล์ PDF', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      Text(
                        'เลือกได้หลายไฟล์ (${widget.selectedPdfs.length} ไฟล์)',
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7)),
                      ),
                    ],
                  ),
                ),
                if (widget.selectedPdfs.isNotEmpty)
                  TextButton.icon(
                    onPressed: widget.onClearAll,
                    icon: const Icon(Icons.clear_all, size: 18),
                    label: const Text('ยกเลิกทั้งหมด'),
                    style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
                  ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ค้นหาไฟล์ PDF...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _searchQuery.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                        : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.dividerColor)),
                filled: true,
                fillColor: theme.cardColor,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          const SizedBox(height: 16),

          // PDF List
          Expanded(
            child:
                filteredPdfs.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(_searchQuery.isEmpty ? Icons.description_outlined : Icons.search_off, size: 64, color: theme.dividerColor),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty ? 'ไม่มีไฟล์ PDF' : 'ไม่พบไฟล์ที่ตรงกับการค้นหา',
                            style: theme.textTheme.bodyLarge?.copyWith(color: theme.textTheme.bodyLarge?.color?.withOpacity(0.6)),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredPdfs.length,
                      itemBuilder: (context, index) {
                        final pdf = filteredPdfs[index];
                        final isSelected = widget.selectedPdfs.any((selected) => selected.id == pdf.id);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSelected ? theme.primaryColor : theme.dividerColor.withOpacity(0.3), width: isSelected ? 2 : 1),
                          ),
                          child: Stack(
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                leading: Column(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: isSelected ? theme.primaryColor.withOpacity(0.1) : theme.primaryColor.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(Icons.picture_as_pdf, color: isSelected ? theme.primaryColor : theme.primaryColor.withOpacity(0.7), size: 24),
                                    ),
                                  ],
                                ),
                                title: Text(
                                  pdf.formName,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    color: isSelected ? theme.primaryColor : theme.textTheme.titleMedium?.color,
                                  ),
                                ),
                                subtitle: Text(
                                  'ไฟล์ PDF',
                                  style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.7)),
                                ),
                                trailing: AnimatedScale(
                                  scale: isSelected ? 1.0 : 0.8,
                                  duration: const Duration(milliseconds: 200),
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: isSelected ? theme.primaryColor : Colors.transparent,
                                      border: Border.all(color: isSelected ? theme.primaryColor : theme.dividerColor, width: 2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: isSelected ? Icon(Icons.check, size: 16, color: theme.colorScheme.onPrimary) : null,
                                  ),
                                ),
                                onTap: () => widget.onToggle(pdf),
                              ),
                              if (pdf.favorite ==true)
                                Padding(padding: const EdgeInsets.only(top: 4, left: 4), child: Icon(Icons.favorite, color: theme.primaryColor, size: 16)),
                            ],
                          ),
                        );
                      },
                    ),
          ),

          // Bottom actions
          if (widget.selectedPdfs.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: theme.cardColor, border: Border(top: BorderSide(color: theme.dividerColor.withOpacity(0.3)))),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'เลือกแล้ว ${widget.selectedPdfs.length} ไฟล์',
                      style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('ยืนยัน'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
