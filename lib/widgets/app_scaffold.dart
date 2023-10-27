import 'package:flutter/material.dart';

import 'app_drawer.dart';

/// A responsive scaffold for our application.
/// Displays the navigation drawer alongside the [Scaffold] if the screen/window size is large enough
class AppScaffold extends StatelessWidget {
  const AppScaffold(
      {required this.body,
      this.pageTitle,
      this.loadingAppBar,
      // this.orderReceived,
      // this.orders,
      required Key? key})
      : super(key: key);

  final Widget body;

  final String? pageTitle;
  final bool? loadingAppBar;

  // final orderReceived;
  // final orders;

  @override
  Widget build(BuildContext context) {
    loadingAppBar ?? false;
    final bool displayMobileLayout = MediaQuery.of(context).size.width < 600;
    return Row(
      children: [
        // if (!displayMobileLayout)
        //   const AppDrawer(
        //     permanentlyDisplay: true,
        //   ),
        loadingAppBar!
            ? Expanded(
                child: Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    toolbarHeight: !displayMobileLayout ? 157 : 100,
                    // when the app isn't displaying the mobile version of app, hide the menu button that is used to open the navigation drawer
                    automaticallyImplyLeading: displayMobileLayout,
                    title: Text(pageTitle ?? ""),
                  ),
                  drawer: const AppDrawer(
                    // orders: orders,
                    permanentlyDisplay: false,
                  ),
                  //     : null,
                  body: body,
                ),
              )
            : Scaffold(body: body),
      ],
    );
  }
}
