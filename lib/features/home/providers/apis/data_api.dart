import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law_app/models/h_d_data_app_model.dart';

class DataAppApi {
  final Ref ref;
  // final String _path = '';
  DataAppApi({required this.ref});
  Future<List<HDDataAppModel>> get() async {
    // Response response = await ref.read(apiClientProvider).get(_path, queryParameters: {'limit': limit});
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(jsonData);
    return data.map((e) => HDDataAppModel.fromJson(e)).toList();
  }
}

final apiDataApp = Provider<DataAppApi>((ref) => DataAppApi(ref: ref));
final jsonData = [
  {"hd_id": "0", "hd_name": "ทั้งหมด", "hd_image": "assets/images/fervour-lighting-sound-2559.png", "hd_updated_at": "2023-10-01T12:00:00Z", "form": []},
  {
    "hd_id": "1",
    "hd_name": "ความร้อนและแสงสว่าง",
    "hd_image": "assets/images/fervour-lighting-sound-2559.png",
    "hd_updated_at": "2023-10-01T12:00:00Z",
    "form": [
      {
          "hd_id": "1",
          "form_id": "1", 
          "form_name": "Criminal Law", 
          "form_pdf": "assets/pdfs/test.pdf", 
          "favorite": false, 
          "updated_at": "2023-10-01T12:00:00Z",
          },
      {"hd_id": "1", "form_id": "2", "form_name": "Civil Law", "form_pdf": "assets/pdfs/test.pdf", "favorite": true, "updated_at": "2023-10-01T12:00:00Z"},
      {"hd_id": "1", "form_id": "3", "form_name": "Family Law", "form_pdf": "assets/pdfs/test.pdf", "favorite": false, "updated_at": "2023-10-01T12:00:00Z"},
      {"hd_id": "1", "form_id": "4", "form_name": "Property Law", "form_pdf": "assets/pdfs/test.pdf", "favorite": false, "updated_at": "2023-10-01T12:00:00Z"},
      {"hd_id": "1", "form_id": "5", "form_name": "Contract Law", "form_pdf": "assets/pdfs/test.pdf", "favorite": false, "updated_at": "2023-10-01T12:00:00Z"},
      {"hd_id": "1", "form_id": "6", "form_name": "Tort Law", "form_pdf": "assets/pdfs/test.pdf", "favorite": false, "updated_at": "2023-10-01T12:00:00Z"},
      {
        "hd_id": "1",
        "form_id": "7",
        "form_name": "Administrative Law",
        "form_pdf": "assets/pdfs/test.pdf",
        "favorite": false,
        "updated_at": "2023-10-01T12:00:00Z",
      },
      {
        "hd_id": "1",
        "form_id": "8",
        "form_name": "International Law",
        "form_pdf": "assets/pdfs/test.pdf",
        "favorite": false,
        "updated_at": "2023-10-01T12:00:00Z",
      },
      {
        "hd_id": "1",
        "form_id": "9",
        "form_name": "Constitutional Law",
        "form_pdf": "assets/pdfs/test.pdf",
        "favorite": false,
        "updated_at": "2023-10-01T12:00:00Z",
      },
      {
        "hd_id": "1",
        "form_id": "10",
        "form_name": "Intellectual Property Law",
        "form_pdf": "assets/pdfs/test.pdf",
        "favorite": false,
        "updated_at": "2023-10-01T12:00:00Z",
      },
    ],
  },
];
