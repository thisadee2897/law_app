import 'package:flutter/material.dart';
import 'package:law_app/components/export.dart';
import '../providers/controllers/category_controller.dart';
import 'widgets/home_screen_mobile_widgets.dart';
import 'package:upgrader/upgrader.dart';

class HomeScreen extends BaseStatefulWidget {
  const HomeScreen({super.key});
  @override
  BaseState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeScreen> {
  @override
  void initState() {
    ref.read(dataAppProvider.notifier).get();
    super.initState();
  }

  @override
  Widget buildDesktop(BuildContext context, SizingInformation sizingInformation) {
    return Center(child: Text('Desktop View', style: Theme.of(context).textTheme.titleLarge));
  }

  @override
  Widget buildTablet(BuildContext context, SizingInformation sizingInformation) {
    return UpgradeAlert(showIgnore: false, showLater: false, dialogStyle: UpgradeDialogStyle.cupertino, child: HomeScreenMobileWidgets());
  }

  @override
  Widget buildMobile(BuildContext context, SizingInformation sizingInformation) {
    return UpgradeAlert(showIgnore: false, showLater: false, dialogStyle: UpgradeDialogStyle.cupertino, child: HomeScreenMobileWidgets());
  }
}
