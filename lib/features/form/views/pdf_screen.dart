import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law_app/features/form/providers/pdf_controller.dart';

class PDFScreen extends ConsumerStatefulWidget {
  const PDFScreen({super.key});

  @override
  ConsumerState<PDFScreen> createState() => _PDFScreenState();
}

class _PDFScreenState extends ConsumerState<PDFScreen> {
  @override
  Widget build(BuildContext context) {
    final path = ref.watch(pdfTempFilePathProvider);

    if (path == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        actions: [
          // ตั้งค่าแจ้งเตือน
          IconButton(
            icon: const Icon(Icons.timer_outlined),
            onPressed: () {
              // Handle notification settings action
            },
          ),
          // download button
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Handle download action
            },
          ),
        ],
      ),
      // show pdf form assets/pdf_form.pdf
      body: PDFView(
        backgroundColor: Colors.white,
        filePath: path),
    );
  }
}
