import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rive_animation/components/side_menu.dart';
import 'package:flutter_rive_animation/constants.dart';
import 'package:flutter_rive_animation/pages/home/home_screen.dart';
import 'package:flutter_rive_animation/utils/rive_utils.dart';
import 'package:rive/rive.dart';
import '../../components/menu_button.dart';
import '../../model/rive_asset.dart';
import '../../components/animated_bar.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scaleAnimation;

  RiveAsset selectedBottomNav = bottomNav.first;
  late SMIBool isSideBarClose;
  bool isSideMenuClose = true;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        setState(() {});
      });
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn),
    );
    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor2,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            width: 288,
            left: isSideMenuClose ? -288 : 0,
            height: MediaQuery.of(context).size.height,
            child: const SideMenu(),
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(
                (animation.value - 30 * animation.value * pi / 180),
              ),
            child: Transform.translate(
              offset: Offset(animation.value * 265, 0),
              child: Transform.scale(
                scale: scaleAnimation.value,
                child: ClipRRect(
                    borderRadius: isSideMenuClose
                        ? const BorderRadius.all(Radius.zero)
                        : const BorderRadius.all(Radius.circular(24)),
                    child: const HomeScreen()),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideMenuClose ? 0 : 220,
            top: 12,
            child: MenuButton(
              riveOnInit: (artBoard) {
                StateMachineController controller = RiveUtils.getRiveController(
                    artBoard,
                    stateMachineName: 'State Machine');
                isSideBarClose = controller.findSMI("isOpen") as SMIBool;
                isSideBarClose.value = true;
              },
              press: () {
                isSideBarClose.value = !isSideBarClose.value;
                if (isSideMenuClose) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
                setState(() {
                  isSideMenuClose = isSideBarClose.value;
                });
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0, 100 * animation.value),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: backgroundColor2.withOpacity(0.8),
              borderRadius: const BorderRadius.all(
                Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(
                  bottomNav.length,
                  (index) => GestureDetector(
                    onTap: () {
                      bottomNav[index].input!.change(true);
                      if (bottomNav[index] != selectedBottomNav) {
                        setState(() {
                          selectedBottomNav = bottomNav[index];
                        });
                      }
                      Future.delayed(const Duration(seconds: 1), () {
                        bottomNav[index].input!.change(false);
                      });
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBar(
                            isActive: bottomNav[index] == selectedBottomNav),
                        SizedBox(
                          height: 36,
                          width: 36,
                          child: Opacity(
                            opacity:
                                bottomNav[index] == selectedBottomNav ? 1 : 0.5,
                            child: RiveAnimation.asset(
                              bottomNav.first.src,
                              artboard: bottomNav[index].artBoard,
                              onInit: (artBoard) {
                                StateMachineController controller =
                                    RiveUtils.getRiveController(artBoard,
                                        stateMachineName:
                                            bottomNav[index].stateMachineName);
                                bottomNav[index].input =
                                    controller.findSMI("active") as SMIBool;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
