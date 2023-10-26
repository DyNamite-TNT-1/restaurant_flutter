import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_flutter/app_ceiling.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/screens/messenger/messenger.dart';
import 'package:restaurant_flutter/screens/reservation_tab/reservation_tab.dart';
import 'package:restaurant_flutter/utils/utils.dart';

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

class ScaffoldWithNavigationRail extends StatefulWidget {
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
  State<ScaffoldWithNavigationRail> createState() =>
      _ScaffoldWithNavigationRailState();
}

class _ScaffoldWithNavigationRailState extends State<ScaffoldWithNavigationRail>
    with TickerProviderStateMixin {
  late AnimationController _moveController;
  late Animation<double> _moveAnimation;
  bool isOpenReservationTab = false;
  String tagRequestServices = "";

  late AnimationController _chatController;
  late Animation<double> _chatAnimation;
  bool isOpenChat = false;
  @override
  void initState() {
    super.initState();
    Preferences.setPreferences();
    prepareAnimations();
  }

  //Setting up the animation
  void prepareAnimations() {
    _moveController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      reverseDuration: Duration(milliseconds: 300),
    );
    _moveAnimation = CurvedAnimation(
      parent: _moveController,
      curve: Curves.easeInOut,
    );

    _chatController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      reverseDuration: Duration(milliseconds: 300),
    );
    _chatAnimation = CurvedAnimation(
      parent: _chatController,
      curve: Curves.easeInOut,
    );
  }

  void _runAnimationCheck() {
    if (isOpenReservationTab) {
      _moveController.forward();
    } else {
      _moveController.reverse();
    }
  }

  void _runCheckChatAnimation() {
    if (isOpenChat) {
      _chatController.forward();
    } else {
      _chatController.reverse();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _moveController.dispose();
    _chatController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isOpenChat = !isOpenChat;
          });
          _runCheckChatAnimation();
        },
        child: Icon(Icons.chat),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              AppCeiling(
                onTapReservation: () {
                  setState(() {
                    isOpenReservationTab = !isOpenReservationTab;
                  });
                  _runAnimationCheck();
                },
              ),
              Container(
                color: primaryColor,
                height: 1,
                width: double.infinity,
              ),
              Expanded(
                child: Row(
                  children: [
                    NavigationRail(
                      selectedIndex: widget.selectedIndex,
                      onDestinationSelected: widget.onDestinationSelected,
                      labelType: NavigationRailLabelType.all,
                      backgroundColor: backgroundColor,
                      destinations: <NavigationRailDestination>[
                        NavigationRailDestination(
                          label: Text(
                              Translate.of(context).translate("dashboard")),
                          icon: Icon(Icons.home),
                        ),
                        NavigationRailDestination(
                          label: Text(Translate.of(context).translate("dish")),
                          icon: SvgPicture.asset(
                            AssetImages.icForkKnife,
                            height: 20,
                            colorFilter: ColorFilter.mode(
                              widget.selectedIndex == 1 ? blueColor : textColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        NavigationRailDestination(
                          label: Text(Translate.of(context).translate("drink")),
                          icon: SvgPicture.asset(
                            AssetImages.icDrink,
                            height: 20,
                            colorFilter: ColorFilter.mode(
                              widget.selectedIndex == 2 ? blueColor : textColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        NavigationRailDestination(
                          label:
                              Text(Translate.of(context).translate("service")),
                          icon: SvgPicture.asset(
                            AssetImages.icMicro,
                            height: 20,
                            colorFilter: ColorFilter.mode(
                              widget.selectedIndex == 3 ? blueColor : textColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        NavigationRailDestination(
                          label:
                              Text(Translate.of(context).translate("history")),
                          icon: SvgPicture.asset(
                            AssetImages.icAvailableCalendar,
                            height: 20,
                            colorFilter: ColorFilter.mode(
                              widget.selectedIndex == 4 ? blueColor : textColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        NavigationRailDestination(
                          label:
                              Text(Translate.of(context).translate("setting")),
                          icon: SvgPicture.asset(
                            AssetImages.icSetting,
                            height: 20,
                            colorFilter: ColorFilter.mode(
                              widget.selectedIndex == 5 ? blueColor : textColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const VerticalDivider(thickness: 1, width: 1),
                    Expanded(child: widget.body),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            //TODO ANHDUC not use both top and bottom params here, if not, animation failed
            child: SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: _moveAnimation,
              child: ReservationTab(
                onTapClose: () {
                  if (isOpenReservationTab) {
                    setState(() {
                      isOpenReservationTab = false;
                    });
                    _runAnimationCheck();
                  }
                },
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: 20,
            child: SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: _chatAnimation,
              child: MessengerScreen(),
            ),
          ),
        ],
      ),
    );
  }
}
