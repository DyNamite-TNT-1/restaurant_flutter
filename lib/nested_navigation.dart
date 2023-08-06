import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_flutter/app_ceiling.dart';
import 'package:restaurant_flutter/configs/configs.dart';

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(
            key: key ?? const ValueKey<String>('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 450) {
        return ScaffoldWithNavigationBar(
          body: navigationShell,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
        );
      } else {
        return ScaffoldWithNavigationRail(
          body: navigationShell,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
        );
      }
    });
  }
}

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        destinations: const [
          NavigationDestination(label: 'Section A', icon: Icon(Icons.home)),
          NavigationDestination(label: 'Section B', icon: Icon(Icons.settings)),
        ],
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}

class ScaffoldWithNavigationRail extends StatelessWidget {
  const ScaffoldWithNavigationRail({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.chat),
      ),
      body: Column(
        children: [
          AppCeiling(),
          Expanded(
            child: Row(
              children: [
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: onDestinationSelected,
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: backgroundColor,
                  destinations: <NavigationRailDestination>[
                    NavigationRailDestination(
                      label: Text('Trang chủ'),
                      icon: Icon(Icons.home),
                    ),
                    NavigationRailDestination(
                      label: Text('Món ăn'),
                      icon: SvgPicture.asset(
                        Images.icForkKnife,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          selectedIndex == 1 ? blueColor : textColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    NavigationRailDestination(
                      label: Text('Thức uống'),
                      icon: SvgPicture.asset(
                        Images.icDrink,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          selectedIndex == 2 ? blueColor : textColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    NavigationRailDestination(
                      label: Text('Chỗ trống'),
                      icon: SvgPicture.asset(
                        Images.icAvailableCalendar,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          selectedIndex == 3 ? blueColor : textColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                // This is the main content.
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
