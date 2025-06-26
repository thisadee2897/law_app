import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryProvider = StateProvider<List<Category>>((ref) {
  return [Category(id: '1', name: 'Criminal Law', imagePath: 'assets/images/fervour-lighting-sound-2559.png')];
});

class Category {
  final String id;
  final String name;
  final String imagePath;

  Category({required this.id, required this.name, required this.imagePath});
}
