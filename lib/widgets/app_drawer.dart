import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// import 'package:flutter_tags/flutter_tags.dart';

import '../constants/page_titles.dart';
import '../constants/route_names.dart';
import '../modules/home/controller/home_notifier.dart';
import '../modules/home/model/home_model.dart';
import 'app_route_observer.dart';

final storage = FirebaseStorage.instance;

/// The navigation drawer for the app.
/// This listens to changes in the route to update which page is currently been shown
class AppDrawer extends ConsumerStatefulWidget {
  const AppDrawer({
    required this.permanentlyDisplay,
    Key? key,
    // this.orders
  }) : super(key: key);

  final bool permanentlyDisplay;
  // final orders;

  @override
  AppDrawerState createState() => AppDrawerState();
}

class AppDrawerState extends ConsumerState<AppDrawer> with RouteAware {
  late String _selectedRoute;
  late AppRouteObserver _routeObserver;
  String? selectedRouteCurrent;
  late TextEditingController usernameController;
  late TextEditingController phoneNumberController;
  late TextEditingController tableController;
  @override
  void initState() {
    super.initState();
    _routeObserver = AppRouteObserver();
    usernameController = TextEditingController();
    phoneNumberController = TextEditingController();
    tableController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    _routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _updateSelectedRoute();
  }

  @override
  void didPop() {
    _updateSelectedRoute();
  }

  @override
  Widget build(BuildContext context) {
    Future<String> downloadUrl(photo) async {
      var downloadUrl =
          storage.ref("business_logo").child(photo).getDownloadURL();

      return downloadUrl;
    }

    AsyncValue<Business> response = ref.watch(responseProvider("bandiis"));

    return Drawer(
      child: Row(children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Color(0xFF181818),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(30))),
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          const SizedBox(height: 100),
                          response.when(
                              data: (dataResponse) => FutureBuilder<String>(
                                  future: downloadUrl(dataResponse.logo),
                                  builder: (context, snapshot) {
                                    Container(
                                      height: 50,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                      ),
                                    );
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return ClipRect(
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        heightFactor: 0.8,
                                        child: SvgPicture.network(
                                          snapshot.data.toString(),
                                          width: 300,
                                          height: 300,
                                        ),
                                      ),
                                    );
                                  }),
                              error: (err, stack) => Text('Error: $err'),
                              loading: () => const LinearProgressIndicator()),
                          const SizedBox(height: 30),
                          response.when(
                              data: (dataResponse) => const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Bem vindo,",
                                        style: TextStyle(color: Colors.white54),
                                      ),
                                    ],
                                  ),
                              error: (err, stack) => Text('Error: $err'),
                              loading: () => const LinearProgressIndicator()),
                          response.when(
                              data: (dataResponse) => Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        response.value!.name,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 24),
                                      ),
                                    ],
                                  ),
                              error: (err, stack) => Text('Error: $err'),
                              loading: () => const LinearProgressIndicator()),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1),
                          ListTile(
                            selectedTileColor: const Color(0xFF00796b),
                            leading:
                                const Icon(Icons.home, color: Colors.white54),
                            title: Text(
                              PageTitles.home.toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 14),
                            ),
                            onTap: () async {
                              await _navigateTo(context, RouteNames.home);
                            },
                            selected: _selectedRoute == RouteNames.home,
                          ),
                          ListTile(
                            selectedTileColor: const Color(0xFF00796b),
                            leading: const Icon(Icons.fastfood,
                                color: Colors.white54),
                            title: Text(PageTitles.products.toUpperCase(),
                                style: const TextStyle(
                                    color: Colors.white54, fontSize: 14)),
                            onTap: () async {
                              await _navigateTo(context, RouteNames.products);
                            },
                            selected: _selectedRoute == RouteNames.products,
                          ),
                          ListTile(
                            selectedTileColor: const Color(0xFF00796b),
                            leading: const Icon(Icons.bar_chart,
                                color: Colors.white54),
                            title: Text(PageTitles.reports.toUpperCase(),
                                style: const TextStyle(
                                    color: Colors.white54, fontSize: 14)),
                            onTap: () async {
                              await _navigateTo(context, RouteNames.reports);
                            },
                            selected: _selectedRoute == RouteNames.reports,
                          ),
                          ListTile(
                            selectedTileColor: const Color(0xFF00796b),
                            leading: const Icon(Icons.settings,
                                color: Colors.white54),
                            title: Text(
                              PageTitles.settings.toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 14),
                            ),
                            onTap: () async {
                              await _navigateTo(context, RouteNames.settings);
                            },
                            selected: _selectedRoute == RouteNames.settings,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }

  /// Closes the drawer if applicable (which is only when it's not been displayed permanently) and navigates to the specified route
  /// In a mobile layout, the a modal drawer is used so we need to explicitly close it when the user selects a page to display
  Future<void> _navigateTo(BuildContext context, String routeName) async {
    if (widget.permanentlyDisplay) {
      Navigator.pop(context);
    }
    await Navigator.pushNamed(context, routeName);
  }

  void _updateSelectedRoute() {
    setState(() {
      _selectedRoute = ModalRoute.of(context)!.settings.name!;
    });
  }
}
