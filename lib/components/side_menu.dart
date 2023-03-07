import 'package:flutter/material.dart';
import 'package:flutter_rive_animation/model/rive_asset.dart';
import 'package:flutter_rive_animation/utils/rive_utils.dart';
import 'package:rive/rive.dart';
import 'info_card.dart';
import 'side_menu_tile.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  RiveAsset selectedMenu = sideMenu.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: 288,
        color: const Color(0xFF17203A),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const InfoCard(
                name: 'Ankush Paul',
                professions: 'Flutter Developer',
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  top: 32,
                  bottom: 16,
                ),
                child: Text(
                  'Browse'.toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ),
              ...sideMenu.map(
                (menu) => SideMenuTile(
                  menu: menu,
                  riveOnInit: (artBoard) {
                    StateMachineController controller =
                        RiveUtils.getRiveController(artBoard,
                            stateMachineName: menu.stateMachineName);
                    menu.input = controller.findSMI("active") as SMIBool;
                  },
                  press: () {
                    menu.input!.change(true);
                    Future.delayed(const Duration(seconds: 1), () {
                      menu.input!.change(false);
                    });
                    setState(() {
                      selectedMenu = menu;
                    });
                  },
                  isActive: selectedMenu == menu,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  top: 32,
                  bottom: 16,
                ),
                child: Text(
                  'History'.toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ),
              ...sideMenu2.map(
                (menu) => SideMenuTile(
                  menu: menu,
                  riveOnInit: (artBoard) {
                    StateMachineController controller =
                        RiveUtils.getRiveController(artBoard,
                            stateMachineName: menu.stateMachineName);
                    menu.input = controller.findSMI("active") as SMIBool;
                  },
                  press: () {
                    menu.input!.change(true);
                    Future.delayed(const Duration(seconds: 1), () {
                      menu.input!.change(false);
                    });
                    setState(() {
                      selectedMenu = menu;
                    });
                  },
                  isActive: selectedMenu == menu,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
