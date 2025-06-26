import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law_app/features/home/providers/category_controller.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(categoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Law App')),
      body: SafeArea(
        bottom: false,
        child: ResponsiveGridList(
          horizontalGridMargin: 10,
          verticalGridMargin: 10,
          minItemWidth: 200,
          minItemsPerRow: 2,
          children: List.generate(
            data.length,
            (index) => InkWell(
              borderRadius: BorderRadius.circular(40),
              onTap: () {},
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    image: DecorationImage(image: AssetImage(data[index].imagePath), fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
