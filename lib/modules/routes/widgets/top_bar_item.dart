import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/colors.dart';
import '../../../constants/route_names.dart';
import '../../products/controller/products_notifier.dart';
import '../controller/routes_controller.dart';

class TopBarItem extends HookConsumerWidget {
  const TopBarItem(
      {super.key,
      required this.route,
      required this.indexRoute,
      required this.icon});

  final RouteNamesList route;
  final int indexRoute;
  final Widget icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int selectedRoute = ref.watch(selectedRouteNotifier);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 375),
      height: selectedRoute == indexRoute ? 80 : 60,
      width: selectedRoute == indexRoute ? 80 : 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: selectedRoute == indexRoute
            ? AppColors.lightShadowColor
            : Colors.transparent,
        boxShadow: const [
          BoxShadow(color: Colors.black45, offset: Offset(3, 3), blurRadius: 2),
          BoxShadow(color: Colors.white, offset: Offset(-3, -3), blurRadius: 2)
        ],
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () {
          ref
              .read(selectedRouteNotifier.notifier)
              .setSelected(route.title == '/'
                  ? 0
                  : route.title == '/produtos'
                      ? 1
                      : 2);
          Navigator.pushNamed(context, route.title);
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Positioned.fill(
              top: 2,
              left: 2,
              right: 2,
              bottom: 2,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0), child: icon),
            )
          ],
        ),
      ),
    );
    // return Stack(
    //   children: [
    //     Container(
    //       height: 50,
    //       width: 50,
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(40),
    //         // gradient: LinearGradient(colors: [
    //         //   Color(int.parse(category.secondaryColor!)),
    //         //   Color(int.parse(category.color!))
    //         // ], begin: Alignment.topLeft, end: Alignment.bottomRight),
    //         boxShadow: [
    //           BoxShadow(
    //               color: AppColors.shadowColor,
    //               offset: Offset(selectedRoute == indexRoute ? 1 : 4, 4),
    //               blurRadius: 2),
    //           BoxShadow(
    //               color: AppColors.lightShadowColor,
    //               offset: Offset(selectedRoute == indexRoute ? -1 : -4, -6),
    //               blurRadius: 12),
    //         ],
    //       ),
    //     ),
    //     Positioned.fill(
    //       top: 2,
    //       left: 2,
    //       right: 2,
    //       bottom: 2,
    //       child: Padding(
    //         padding: EdgeInsets.all(5),
    //         child: ClipRRect(
    //           borderRadius: BorderRadius.circular(15.0),
    //           child: icon,
    //         ),
    //       ),
    //     )
    //   ],
    // );
  }
}
