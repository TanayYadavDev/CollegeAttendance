import 'dart:ui';

import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _icons = [
    Icons.home_rounded,
    Icons.calendar_month_rounded,
    Icons.menu_book_rounded,
    Icons.settings_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    const navHeight = 70.0;
    const bubbleWidth = 72.0;
    const bubbleHeight = 52.0;
    const radius = navHeight / 2;

    return SafeArea(
      minimum: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 25,
              sigmaY: 25,
            ),
            child: Container(
              height: navHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                      Colors.white.withValues(alpha : 0.22),
                      Colors.white.withValues(alpha : 0.10),
                    ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha : 0.18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth =
                      constraints.maxWidth / _icons.length;

                  return Stack(
                    children: [

                      /// Sliding Glass Bubble
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 340),
                        curve: Curves.easeInOutCubicEmphasized,
                        left: itemWidth * currentIndex +
                            (itemWidth - bubbleWidth) / 2,
                        top: (navHeight - bubbleHeight) / 2 - 1,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 340),
                          curve: Curves.easeInOutCubicEmphasized,

                          width: bubbleWidth,
                          height: bubbleHeight,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),

                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withValues(alpha: 0.34),
                                Colors.white.withValues(alpha: 0.14),
                              ],
                            ),

                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.28),
                              width: 1,
                            ),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.10),
                                blurRadius: 18,
                              ),
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ),

                      /// Icons
                      Row(
                        children: List.generate(_icons.length, (index) {
                          final selected = index == currentIndex;

                          return Expanded(
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.circular(100),
                              onTap: () => onTap(index),
                              child: SizedBox(
                                height: navHeight,
                                child: Center(
                                  child: AnimatedScale(
                                    duration: const Duration(
                                        milliseconds: 250),
                                    curve: Curves.easeOut,
                                    scale: selected ? 1.08 : 1,
                                    child: Icon(
                                      _icons[index],
                                      size: 27,
                                        color: selected
                                          ? Colors.white
                                          : Colors.white.withValues(alpha: 0.72),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}