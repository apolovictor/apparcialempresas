import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../products/controller/product_list.notifier.dart';
import '../../products/controller/products_notifier.dart';
import '../../products/model/products_model.dart';
import '../../products/views/product_add.dart';
import '../../products/views/product_quick_edit.dart';
import '../controller/routes_controller.dart';
import 'app_drawer.dart';
import 'top_bar.dart';
import 'top_bar_item.dart';

/// A responsive scaffold for our application.
/// Displays the navigation drawer alongside the [Scaffold] if the screen/window size is large enough
class AppScaffold extends HookConsumerWidget {
  const AppScaffold(
      {required this.body,
      this.pageTitle,
      // this.orderReceived,
      // this.orders,
      required Key? key})
      : super(key: key);

  final Widget body;

  final String? pageTitle;

  // final orderReceived;
  // final orders;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool displayMobileLayout = MediaQuery.of(context).size.width < 600;
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final routeListNotifier = ref.watch(routeListProvider);
    final isProductOpened = ref.watch(isProductsOpenedProvider);
    int productSelected = ref.watch(selectedProductNotifier);
    final filter = ref.watch(filterNotifier);

    List<Product> filteredProducts = ref.watch(filteredProductListProvider);
    List<Product>? products = ref.watch(exampleProvider).value;

    bool isActiveEdit = ref.watch(isActiveEditNotifier);
    final Animation<double> animation = Tween(begin: .0, end: 1.0).animate(
        CurvedAnimation(
            parent: getQuickFieldsController(ref), curve: Curves.ease));

    return Scaffold(
      drawer: displayMobileLayout
          ? const AppDrawer(
              // orders: orders,
              permanentlyDisplay: false,
            )
          : null,
      body: Container(
        height: height,
        width: width,
        child: Stack(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 375),
              width: isProductOpened ? width * 0.7 : width,
              height: height * 0.1,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                    child: Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      children: routeListNotifier
                          .map(
                            (e) => TopBarItem(
                              route: e,
                              indexRoute: routeListNotifier.indexWhere(
                                  (element) => element.title == e.title),
                              icon: e.title == '/'
                                  ? const Icon(Icons.home, size: 40)
                                  : e.title == '/produtos'
                                      ? const Icon(Icons.restaurant_menu,
                                          size: 40)
                                      : const Icon(Icons.table_bar, size: 40),
                            ),
                          )
                          .toList(),
                    ),
                    //
                  ),
                ],
              ),
            ),

            /// Body
            Positioned(
              top: height * 0.1,
              child: Container(
                  height: height * 0.9,
                  width: width,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.03, vertical: height * 0.03),
                    child: body,
                  )),
            ),

            /// Add Product Widget
            Positioned(
              right: 0,
              child: ProductAdd(
                width: width,
                height: height,
              ),
            ),

            /// Edit Product Widget
            Positioned(
              right: 0,
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 375),
                    width: (isActiveEdit && productSelected > -1)
                        ? width * 0.3
                        : 0,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      color: productSelected > -1
                          ? filter['category'].isNotEmpty &&
                                  filteredProducts.isNotEmpty
                              ? Color(int.parse(
                                  filteredProducts[productSelected]
                                      .secondaryColor))
                              : products!.isNotEmpty
                                  ? Color(int.parse(
                                      products[productSelected].secondaryColor))
                                  : Colors.transparent
                          : Colors.transparent,
                    ),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return ProducQuickEdit(
                          key: key,
                          height: height,
                          width: width,
                          animation: animation,
                          constraints: constraints);
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
