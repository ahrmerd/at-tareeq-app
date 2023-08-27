import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';

class MyTab {
  final Tab tab;
  final Widget tabView;

  const MyTab({required this.tab, required this.tabView});
}

class MyTabView extends StatefulWidget {
  final List<MyTab> tabs;
  final TabController? tabController;

  const MyTabView({Key? key, required this.tabs, this.tabController})
      : super(key: key);

  @override
  State<MyTabView> createState() => _MyTabViewState();
}

class _MyTabViewState extends State<MyTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = widget.tabController ??
        TabController(vsync: this, length: widget.tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = widget.tabs.map((e) => e.tab).toList();
    List<Widget> tabViews = widget.tabs.map((e) => e.tabView).toList();
    return Scaffold(
      appBar: TabBar(
        indicatorColor: primaryColor,
        labelColor: primaryColor,
        unselectedLabelColor: Colors.grey,
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        indicatorWeight: 3,
        tabs: tabs,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: TabBarView(
          controller: _tabController,
          children: tabViews,
        ),
      ),
    );
  }
}
