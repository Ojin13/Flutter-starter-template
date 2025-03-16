import 'package:flutter/material.dart';
import 'package:flutter_starter_template/common/theme/app_colors.dart';

import '../../model/navigation_tab.dart';
import '../offstage_navigator.dart';

class TabbedScaffold extends StatefulWidget {
  const TabbedScaffold({super.key});

  @override
  TabbedScaffoldState createState() => TabbedScaffoldState();
}

class TabbedScaffoldState extends State<TabbedScaffold> {
  late List<NavigationTab> allDestinations;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeTabs();
  }

  void _initializeTabs() {
    allDestinations = <NavigationTab>[
      NavigationTab(icon: Icon(Icons.map), label: 'Tab 1', child: Container()),
      NavigationTab(icon: Icon(Icons.calendar_today), label: 'Tab 2', child: Container()),
      NavigationTab(icon: Icon(Icons.leaderboard), label: 'Tab 3', child: Container()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(bottomNavigationBar: _buildNavigationBar(), body: _buildIndexedStack());
  }

  Widget _buildNavigationBar() {
    final double bottomMenuHeight = 80;

    return Container(
        color: Theme.of(context).extension<AppColors>()!.customColor1,
        child: SafeArea(
          child: SizedBox(
            height: bottomMenuHeight,
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Theme.of(context).extension<AppColors>()!.customColor1.withOpacity(0.1),
                  offset: Offset(0, -10),
                  blurRadius: 10.0,
                  spreadRadius: 0,
                )
              ]),
              child: NavigationBar(
                backgroundColor: Theme.of(context).extension<AppColors>()!.customColor1,
                selectedIndex: _currentTabIndex,
                onDestinationSelected: _onItemTapped,
                destinations: allDestinations.map<NavigationDestination>(
                      (NavigationTab destination) {
                    return NavigationDestination(
                      icon: destination.icon,
                      label: destination.label,
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ));
  }

  Widget _buildIndexedStack() {
    return IndexedStack(
      index: _currentTabIndex,
      children: allDestinations.map<OffstageNavigator>(
            (NavigationTab destination) {
          return OffstageNavigator(
            index: allDestinations.indexOf(destination),
            currentTabIndex: _currentTabIndex,
            navigationTab: destination,
          );
        },
      ).toList(),
    );
  }

  void _onItemTapped(int index) {
    if (_currentTabIndex == index) {
      // If the user taps the current tab again, pop to the root of that tab
      var navigatorKey = allDestinations[index].navigatorKey;
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentTabIndex = index;
      });
    }
  }
}
