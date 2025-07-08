import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law_app/features/form/providers/pdf_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

// final selectedPdfProvider = StateProvider<String?>((ref) => null);

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
            onPressed: () async {
              ScaffoldMessenger.of(context).clearSnackBars();
              downloadAssetPdfToDevice(assetPath: path, filename: 'pdf_form.pdf');
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PDF downloaded successfully!')));
              await OpenFile.open(path);
            },
          ),
        ],
      ),
      // show pdf form assets/pdf_form.pdf
      body: PDFView(backgroundColor: Colors.white, filePath: path),
    );
  }
}

Future<String?> downloadAssetPdfToDevice({required String assetPath, required String filename}) async {
  try {
    // โหลดไฟล์ PDF จาก assets
    final byteData = await rootBundle.load(assetPath);

    // หา directory ที่จะบันทึก (app-specific directory)
    final directory = await getApplicationDocumentsDirectory(); // หรือ getDownloadsDirectory() ถ้าใช้งาน desktop
    final filePath = '${directory.path}/$filename';

    final file = File(filePath);

    // เขียนข้อมูลลงไฟล์
    await file.writeAsBytes(byteData.buffer.asUint8List());

    return filePath;
  } catch (e) {
    print('Download failed: $e');
    return null;
  }
}
