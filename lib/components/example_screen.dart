import 'package:flutter/material.dart';
import 'package:law_app/components/base_full_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SummaryWidget extends BaseStatefulWidget {
  const SummaryWidget({super.key});
  @override
  BaseState<SummaryWidget> createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends BaseState<SummaryWidget> {
  @override
  Widget buildDesktop(BuildContext context, SizingInformation sizingInformation) {
    return Center(child: Text('Desktop View', style: Theme.of(context).textTheme.titleLarge));
  }

  @override
  Widget buildTablet(BuildContext context, SizingInformation sizingInformation) {
    return Center(child: Text('Tablet View', style: Theme.of(context).textTheme.titleLarge));
  }

  @override
  Widget buildMobile(BuildContext context, SizingInformation sizingInformation) {
    return Center(child: Text('Mobile View', style: Theme.of(context).textTheme.titleLarge));
  }
}
